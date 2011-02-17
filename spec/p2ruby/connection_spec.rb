require 'spec_helper'

def random_name
  "APP-#{rand 10000}"
end

shared_examples_for 'new connection' do
  its(:Status) { should == P2::CS_CONNECTION_DISCONNECTED }
  its(:status_text) { should == "Connection Disconnected" }

  it 'raises on NodeName access' do
    expect { subject.NodeName }.to raise_error /Couldn't get MQ node name/
#      its(:NodeName) { should == "??" }
  end

  it 'is not connected right away' do
    subject.should_not be_connected
  end
end

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
      it_behaves_like 'new connection'
    end

    context 'with options' do
      subject { P2Ruby::Connection.new :app_name => random_name,
                                       :host => "localhost",
                                       :port => 3333,
                                       :timeout => 500,
                                       :login_str => "Blah" }
      its(:AppName) { should =~ /APP-./ }
      its(:Host) { should == "localhost" }
      its(:Port) { should == 3333 }
      its(:Timeout) { should == 500 }
      its(:LoginStr) { should == "Blah" }
      it_behaves_like 'new connection'
    end

    describe '#Connect()', 'creates local connection to Router' do
      context 'with correct connection parameters' do
        it 'connects successfully' do
          @conn = P2Ruby::Connection.new :app_name => random_name,
                                        :host => "127.0.0.1", :port => 4001
          @conn.Connect().should == P2::P2ERR_OK
          @conn.NodeName.should == ROUTER_LOGIN
          @conn.should be_connected
          @conn.status_text.should == "Connection Connected, Router Connected"
        end
      end

      context 'with wrong connection parameters' do
        it 'fails to connect' do
          @conn = P2Ruby::Connection.new :app_name => random_name, :timeout => 200,
                                        :host => "127.0.0.1", :port => 1313
          expect { @conn.Connect() }.to raise_error /Couldn't connect to MQ/
          @conn.should_not be_connected
          @conn.status_text.should == "Connection Disconnected"
        end
      end
    end

    describe '#Disconnect()', 'drops local connection to Router' do
      context 'when connected to Router' do
        before do
          @conn = P2Ruby::Connection.new :app_name => random_name,
                                         :host => "127.0.0.1", :port => 4001
          @conn.Connect()
          @conn.should be_connected
        end

        it 'disconnects from Router successfully' do
          @conn.Disconnect()
          expect { @conn.NodeName }.to raise_error /Couldn't get MQ node name/
          @conn.should_not be_connected
          @conn.status_text.should == "Connection Disconnected"
        end
      end

      context 'when NOT connected to Router' do
        it 'it`s noop' do
          @conn = P2Ruby::Connection.new :app_name => random_name,
                                         :host => "127.0.0.1", :port => 1313
          @conn.Disconnect()
          @conn.should_not be_connected
        end
      end
    end

    describe '#Logout(void)', 'drops Router connection to uplink (RTS)' do
      context 'when Router is connected' do
        before do
          @conn = P2Ruby::Connection.new :app_name => random_name,
                                         :host => "127.0.0.1", :port => 4001
          @conn.Connect()
          @conn.should be_connected
        end

        xit 'disconnects Router from uplink' do
          @conn.Logout()
          sleep 4
          @conn.status_text.should == "Connection Disconnected"
        end

        xit 'but keeps local connection to Router' do
          @conn.Logout()
          @conn.should be_connected
          @conn.status_text.should == "Connection Disconnected"
        end
      end

    end



  end
end
