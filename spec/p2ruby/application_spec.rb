# encoding: CP1251
require 'spec_helper'

describe P2::Application, "singleton app object" do
  after(:all) { P2::Application.reset CLIENT_INI }
  subject { P2::Application.instance CLIENT_INI }

  it 'wraps P2ClientGate.P2Application OLE class' do
    subject.ole_type.name.should == 'IP2Application'
    show_ole
  end

  its(:clsid) { should == '{08A95064-05C2-4EF4-8B5D-D6211C2C9880}' }
  its(:progid) { should == 'P2ClientGate.P2Application.1' }
  its(:opts) { should have_key :ini }
  its(:ini) { should == CLIENT_INI }
  its(:ole) { should be_a WIN32OLE }
  its(:ParserType) { should == 2 } # �	1 � Plaza; �	2 � Plaza-II (default)

  it 'is a Singleton' do
    a1 = P2::Application.instance
    a2 = P2::Application.instance
    a1.object_id.should == a2.object_id
  end

  context '.reset' do

    it 'resets Application singleton' do
      a1 = P2::Application.instance
      P2::Application.reset CLIENT_INI1
      a2 = P2::Application.instance
      a1.object_id.should_not == a2.object_id
    end
  end
end
