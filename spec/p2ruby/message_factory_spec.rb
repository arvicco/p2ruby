# encoding: utf-8
require 'spec_helper'

describe P2Ruby::MessageFactory do
  before(:all) { P2Ruby::Application.reset CLIENT_INI }
  subject { P2Ruby::MessageFactory.new :ini => MESSAGE_INI }

  it 'wraps P2ClientGate.P2BLMessageFactory OLE class' do
    subject.ole_type.name.should == 'IP2BLMessageFactory'
    show_ole
  end

  its(:clsid) { should == '{501786DA-CA02-45C1-B815-1C58C383265D}' }
  its(:progid) { should == 'P2ClientGate.P2BLMessageFactory.1' }
  its(:opts) { should have_key :ini }
  its(:ole) { should be_a WIN32OLE }

  describe '#Init()', 'is implicitly called by #new'
  # Init ( BSTR structFile, BSTR signFile); - »нициализаци€ объекта.
  # јргументы
  # Х	structFile Ч ini-файл, содержащий схему сообщений.
  # Х	signFile Ч не используетс€.

  describe '#CreateMessageByName()', 'creates raw (unwrapped) OLE message objects' do
    # CreateMessageByName ( [in] BSTR msgName, [out,retval] IP2BLMessage** newMsg);
    # —оздание сообщени€ по имени.
    # јргументы
    # Х	msgName Ч им€ сообщени€ (им€ таблицы Ѕƒ).
    it 'creates raw OLE message objects according to scheme' do
      msg = subject.CreateMessageByName("FutAddOrder")
      msg.should be_a WIN32OLE # raw (unwrapped) OLE object!
      msg.ole_type.name.should == 'IP2BLMessage'
    end
  end

  describe '#message', 'creates P2Ruby::Message according to scheme' do
    # This is a P2Ruby object wrapper for CreateMessageByName

    it 'creates P2Ruby::Message wrapper given message opts' do
      msg = subject.message :name => "FutAddOrder", :dest_addr => 'Blah'
      msg.should be_a P2Ruby::Message
      msg.DestAddr.should == "Blah"
      p msg.Id
    end

    it 'creates P2Ruby::Message wrapper given a name and opts' do
      msg = subject.message "FutAddOrder", :dest_addr => 'Blah'
      msg.should be_a P2Ruby::Message
      msg.DestAddr.should == "Blah"
    end

    it 'creates P2Ruby::Message wrapper given a name WITHOUT opts' do
      msg = subject.message "FutAddOrder"
      msg.should be_a P2Ruby::Message
    end

    it 'fails to create P2Ruby::Message wrapper given wrong number of args' do
      [[], ["One", "two", {}], ['one', 'two', 'three']].each do |args|
        expect { msg = subject.message *args }.to raise_error ArgumentError
      end
    end

    it 'fails to create P2Ruby::Message wrapper given wrong message name' do
      expect { msg = subject.message 'Impossible' }.
          to raise_error /Couldn't create BL message by name/
    end
  end
end

