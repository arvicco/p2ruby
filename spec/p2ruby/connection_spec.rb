require 'spec_helper'

describe P2Ruby::Connection do
  subject { P2Ruby::Connection.new }

  it 'wraps P2ClientGate.P2Connection OLE class' do
    subject.ole_type.name.should == 'IP2Connection'
    show_ole
  end

  context 'by default' do
    its(:AppName) { should =~ /APP-./ }

    it 'rocks' do
      p subject.AppName
      p subject.LoginStr
      p subject.Host
      p subject.Port
      p subject.Status
      p subject.Timeout
#      p subject.NodeName
    end
  end
end
