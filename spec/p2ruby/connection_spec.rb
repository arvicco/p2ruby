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
      it 'raises on NodeName access' do
        expect { subject.NodeName }.to raise_error /Couldn't get MQ node name/
      end
    end

    context 'with options' do
      subject { P2Ruby::Connection.new :app_name => "APP-#{rand 10000}",
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
      it 'raises on NodeName access' do
        expect { subject.NodeName }.to raise_error /Couldn't get MQ node name/
      end
#      its(:NodeName) { should == "??" }
    end

    describe '#connect' do
      context 'when Router service is running' do
        before :all do

        end
        it 'connects successfully' do
          conn = P2Ruby::Connection.new :app_name => "APP-#{rand 10000}",
                                        :host => "127.0.0.1", :port => 4001
          conn.Connect().should == P2::P2ERR_OK
        end

      end
    end

  end
end
