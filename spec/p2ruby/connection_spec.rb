require 'spec_helper'

describe P2Ruby::Connection do
  it 'wraps P2ClientGate.P2Connection OLE class' do
    subject.ole_type.name.should == 'IP2Connection'
    show_ole
  end

  describe '.new' do
    context 'by default' do
      subject { P2Ruby::Connection.new }

      its(:AppName) { should == '' }
      its(:Host) { should == '' }
      its(:Port) { should == 3000 }
      its(:Timeout) { should == 1000 }
      its(:LoginStr) { should == '' }
      its(:Status) { should == P2::CS_CONNECTION_DISCONNECTED }
      its(:NodeName) { should == "??" }
    end

    context 'with options' do
      subject { P2Ruby::Connection.new :app_name => "APP-#{rand(10000)}",
                                       :host => "localhost",
                                       :port => 3333,
                                       :timeout => 500,
                                       :login_str => "Blah" }

      its(:AppName) { should =~ /APP-./ }
      its(:Host) { should == "localhost" }
      its(:Port) { should == 3333 }
      its(:Timeout) { should == 500 }
      its(:LoginStr) { should == "Blah" }
      its(:Status) { should == P2::CS_CONNECTION_DISCONNECTED }
      its(:NodeName) { should == "??" }
    end
  end
end
