require 'spec_helper'

describe P2Ruby::Application do
  subject { P2Ruby::Application.new :ini => INI_PATH }

  it 'wraps P2ClientGate.P2Application OLE class' do
    subject.ole_type.name.should == 'IP2Application'
    show_ole
  end

  its(:ParserType) { should == 2 } # •	1 — Plaza; •	2 — Plaza-II (default)

  it 'loads P2ClientGate constants' do
    P2ClientGate::CS_CONNECTION_DISCONNECTED.should == 1
    P2::CS_CONNECTION_DISCONNECTED.should == 1
    P2ClientGate.constants.should have(23).constants
  end
end
