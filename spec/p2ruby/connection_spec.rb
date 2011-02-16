require 'spec_helper'

describe P2Ruby::Connection do
  subject { P2Ruby::Connection.new }

  it 'wraps P2ClientGate.P2Connection OLE class' do
    subject.ole_type.name.should == 'IP2Connection'
    show_ole
  end

  its(:AppName){should =~ /APP-./}  # •	1 — Plaza; •	2 — Plaza-II (default)

end
