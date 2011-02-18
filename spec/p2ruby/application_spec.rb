require 'spec_helper'

describe P2Ruby::Application, "singleton app object" do
  after(:all) { P2Ruby::Application.reset CLIENT_INI }
  subject { P2Ruby::Application.instance CLIENT_INI }

  it 'wraps P2ClientGate.P2Application OLE class' do
    subject.ole_type.name.should == 'IP2Application'
    show_ole
  end

  its(:opts) { should have_key :ini }
  its(:ini) { should == CLIENT_INI }
  its(:ole) { should be_a WIN32OLE }
  its(:ParserType) { should == 2 } # •	1 — Plaza; •	2 — Plaza-II (default)

  it 'loads P2ClientGate constants' do
    P2ClientGate::CS_CONNECTION_DISCONNECTED.should == 1
    P2::CS_CONNECTION_DISCONNECTED.should == 1
    P2ClientGate.constants.should have_at_least(23).constants
  end

  it 'is a Singleton' do
    a1 = P2Ruby::Application.instance
    a2 = P2Ruby::Application.instance
    a1.object_id.should == a2.object_id
  end

  context '.reset' do

    it 'resets Application singleton' do
      a1 = P2Ruby::Application.instance
      P2Ruby::Application.reset
      a2 = P2Ruby::Application.instance
      a1.object_id.should_not == a2.object_id
    end
  end
end
