require 'spec_helper'

describe P2Ruby::Message do
  before(:all) do
    P2Ruby::Application.reset CLIENT_INI
    @factory = P2Ruby::MessageFactory.new :ini => MESSAGE_INI
  end
  subject { @factory.message :name => "FutAddOrder" }

  it 'is not instantiated directly, use MessageFactory instead'

  it 'wraps P2ClientGate.P2BLMessage OLE class' do
    subject.ole_type.name.should == 'IP2BLMessage'
    show_ole
  end

  its(:clsid) { should == '{A9A6C936-5A12-4518-9A92-90D75B41AF18}' }
  its(:progid) { should == 'P2ClientGate.P2BLMessage.1' }
  its(:opts) { should have_key :name }
  its(:ole) { should be_a WIN32OLE }

  describe '#Init()', 'is implicitely called by #new'
  # Init ( BSTR structFile, BSTR signFile); - »нициализаци€ объекта.
  # јргументы
  # Х	structFile Ч ini-файл, содержащий схему сообщений.
  # Х	signFile Ч не используетс€.

  describe '#CreateMessageByName()', 'creates raw (unwrapped) OLE message objects' do
    # CreateMessageByName ( [in] BSTR msgName, [out,retval] IP2BLMessage** newMsg);
    # —оздание сообщени€ по имени.
    # јргументы
    # Х	msgName Ч им€ сообщени€ (им€ таблицы Ѕƒ).
    xit 'creates raw OLE message objects according to scheme' do
      msg = subject.CreateMessageByName("FutAddOrder")
      msg.should be_a WIN32OLE # raw (unwrapped) OLE object!
      msg.ole_type.name.should == 'IP2BLMessage'
    end
  end

  describe '#message', 'creates P2Ruby::Messages according to scheme' do
    # This is a P2Ruby object wrapper for CreateMessageByName

    it 'creates P2Ruby::Messages according to scheme'
  end
end
