require 'spec_helper'

describe P2Ruby::Application, "singleton app object" do
  before(:all) { P2Ruby::Application.instance CLIENT_INI }
  subject { P2Ruby::Application.instance }

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
end
