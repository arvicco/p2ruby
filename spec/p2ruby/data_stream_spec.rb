require 'spec_helper'

describe P2Ruby::DataStream do
  before(:all) do
    start_router
    P2Ruby::Application.reset CLIENT_INI
    @conn = P2Ruby::Connection.new :app_name => 'DSTest',
                                   :host => "127.0.0.1", :port => 4001
    @conn.Connect().should == P2::P2ERR_OK
  end

  after(:all) { stop_router }

  describe '.new' do
    subject { P2Ruby::DataStream.new :stream_name => 'RTS_INDEX_REPL',
                                           :type => P2::RT_REMOTE_SNAPSHOT }

    it 'wraps P2ClientGate.P2DataStream OLE class' do
      subject.ole_type.name.should == 'IP2DataStream'
      show_ole
    end

    its(:clsid) { should == '{914893CB-0864-4FBB-856A-92C3A1D970F8}' }
    its(:progid) { should == 'P2ClientGate.P2DataStream.1' }
    its(:opts) { should be_a Hash }
    its(:ole) { should be_a WIN32OLE }
    its(:StreamName) { should == 'RTS_INDEX_REPL' }
    its(:Type) { should == P2::RT_REMOTE_SNAPSHOT }
    its(:State) { should == P2::DS_STATE_CLOSE }
    its(:TableSet) { should == nil }
    its(:DBConnString) { should == '' }
  end

  it 'is possible to set settable properties' do
    subject.Type = P2::RT_LOCAL
    subject.DBConnString = 'Blah'
    subject.StreamName = 'BLAH_REPL'
#    subject.TableSet = P2Ruby::TableSet.new

    subject.Type.should == P2::RT_LOCAL
    subject.DBConnString.should == 'Blah'
    subject.StreamName.should == 'BLAH_REPL'
#    subject.TableSet.should == 'Blah'
  end

  it 'should not be open initially' do
    subject.should_not be_open
    subject.should_not be_opened
  end

  describe '#Open()', 'opens replication data stream'
#      it 'fails to connect' do
#        @conn = P2Ruby::Connection.new :app_name => random_name, :timeout => 200,
#                                       :host => "127.0.0.1", :port => 1313
#        expect { @conn.Connect() }.to raise_error /Couldn't connect to MQ/
#        @conn.should_not be_connected
#        @conn.status_text.should == "Connection Disconnected"
#  end
#
  describe '#Close()', 'closes replication data stream'

#    context 'when connected to Router' do
#      before do
#        @conn = P2Ruby::Connection.new :app_name => random_name,
#                                       :host => "127.0.0.1", :port => 4001
#        @conn.Connect()
#        @conn.should be_connected
#      end
#
#      it 'disconnects from Router successfully' do
#        @conn.Disconnect()
#        expect { @conn.NodeName }.to raise_error /Couldn't get MQ node name/
#        @conn.should_not be_connected
#        @conn.status_text.should == "Connection Disconnected"
#      end
#    end
#
#    context 'when NOT connected to Router' do
#      it 'it`s noop' do
#        @conn = P2Ruby::Connection.new :app_name => random_name,
#                                       :host => "127.0.0.1", :port => 1313
#        @conn.Disconnect()
#        @conn.should_not be_connected
#      end
#    end
#  end
#

  describe '#events' do
    before(:each) do
      @ds = P2Ruby::DataStream.new :stream_name => 'FORTS_VM_REPL',
                                   :type => P2::RT_REMOTE_SNAPSHOT
      @ds.ole.setproperty 'type', 8
      p @ds.Type
      @events = @ds.events
      @event_fired = false
    end

    it 'provides access to (IP2ConnectionEvent interface) events' do
      @events.should be_kind_of WIN32OLE_EVENT
    end

    it 'allows setting callbacks for IP2ConnectionEvent interface events' do
      @events.on_event do |event_name, ole, state|
        @event_fired = true
        p "EVENT: #{event_name}, #{ole}, #{state}"
        event_name.should == "StreamStateChanged"
        ole.ole_type.name.should == "IP2DataStream"
        state.should be_kind_of Fixnum
      end

      @ds.Open(@conn.ole)
      @conn.ProcessMessage2(100) # Grabs messages/events from queue
      @event_fired.should == true
    end

    it 'allows setting explicit handler for IP2ConnectionEvent events' do
      class TestHandler
        attr_accessor :event_fired

        def onStreamStateChanged(ole, status)
          puts "StatusTextChanged"
          @event_fired = true
          p "HANDLER EVENT (StreamStateChanged): #{ole}, #{status}"
          ole.ole_type.name.should == "IP2DataStream"
          status.is_a?(Fixnum).should == true # We are inside Handler class, no #be_kind_of
        end
      end

      @events.handler = TestHandler.new
      @ds.Open(@conn.ole)
      @conn.ProcessMessage2(100) # Grabs messages/events from queue

      @events.handler.should be_a TestHandler
      @events.handler.event_fired.should == true
    end
  end #events
end
