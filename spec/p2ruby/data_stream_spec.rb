# encoding: utf-8
require 'spec_helper'

def baseless_opts
  {:stream_name => 'RTS_INDEX_REPL',
   :type => P2::RT_COMBINED_DYNAMIC}
end

describe P2::DataStream do
  before(:all) do
    start_router
    P2::Application.reset CLIENT_INI
    @conn = P2::Connection.new :app_name => 'DSTest',
                               :host => "127.0.0.1", :port => 4001
    @conn.Connect
    @conn.should be_connected
    @conn.should be_logged
    # Disconnected connection, for comparison
    @disconn = P2::Connection.new :app_name => 'DSTestDisconnected',
                                  :host => "127.0.0.1", :port => 4001
  end

  after(:all) { stop_router }

  context 'initializing Baseless' do
    subject { P2::DataStream.new baseless_opts }
    describe '.new' do
      it 'wraps P2ClientGate.P2DataStream OLE class' do
        subject.ole_type.name.should == 'IP2DataStream'
        show_ole
      end

      its(:clsid) { should == '{914893CB-0864-4FBB-856A-92C3A1D970F8}' }
      its(:progid) { should == 'P2ClientGate.P2DataStream.1' }
      its(:opts) { should be_a Hash }
      its(:ole) { should be_a WIN32OLE }
      its(:StreamName) { should == 'RTS_INDEX_REPL' }
      its(:Type) { should == P2::RT_COMBINED_DYNAMIC }
      its(:State) { should == P2::DS_STATE_CLOSE }
      its(:TableSet) { should == nil }
      its(:DBConnString) { should == '' }
      its(:state_text) { should == 'Data Stream Closed' }

    end

    it 'is possible to set settable properties' do
      subject.Type = P2::RT_LOCAL
      subject.DBConnString = 'Blah'
      subject.StreamName = 'BLAH_REPL'

      subject.Type.should == P2::RT_LOCAL
      subject.DBConnString.should == 'Blah'
      subject.StreamName.should == 'BLAH_REPL'
    end

    it 'is possible to set either wrapped or unwrapped TableSet' do
      subject.TableSet = P2::TableSet.new :ini => TABLESET_INI, :life_num => 1313
      subject.TableSet.LifeNum.should == 1313

      subject.TableSet = (P2::TableSet.new :ini => TABLESET_INI, :life_num => 131313).ole
      subject.TableSet.LifeNum.should == 131313
    end

    it 'is possible to set/access StreamName property through aliases' do
      subject.Name ='Set through Name'
      subject.StreamName.should == 'Set through Name'
      subject.Name.should == 'Set through Name'
      subject.name.should == 'Set through Name'

      subject.name ='Now set through name'
      subject.StreamName.should == 'Now set through name'
      subject.Name.should == 'Now set through name'
      subject.name.should == 'Now set through name'
    end

    it 'should not be open initially' do
      subject.should_not be_open
      subject.should_not be_opened
    end
  end

  context 'when initialized Baseless' do
    subject { P2::DataStream.new baseless_opts }
    describe '#Open()' do
      it 'opens replication data stream via connection' do
        subject.Open(@conn)
        subject.should be_open
      end

      it 'opens replication data stream via raw connection ole' do
        subject.Open(@conn.ole)
        subject.should be_open
      end

      it 'fails to open data stream via disconnected connection?!' do
        @disconn.should_not be_connected
        expect { subject.Open(@disconn) }.to raise_error /Couldn't open baseless repl datastream/
        subject.should_not be_open
      end

      it 'fails to open data stream if arg is not a connection' do
        expect { subject.Open(subject) }.to raise_error /Type mismatch/
        expect { subject.Open(1313) }.to raise_error /not valid value/
        subject.should_not be_open
      end
    end

    describe '#Close()' do
      it 'closes opened replication data stream' do
        # --- before
        subject.Open(@conn)
        subject.should be_open

        # --- example
        subject.Close()
        subject.should_not be_open
      end

      it 'does not raise errors closing unopened stream' do
        # --- before
        subject.should_not be_open

        # --- example
        subject.Close()
        subject.should_not be_open
      end
    end
  end # when initialized Baseless

  describe '#events' do
    before do
      @ds = P2::DataStream.new baseless_opts
      @events = @ds.events
      @events_fired = 0
    end

    it 'provides access to (IP2ConnectionEvent interface) events' do
      @events.should be_kind_of WIN32OLE_EVENT
    end

    it 'allows setting callbacks for IP2ConnectionEvent interface events' do
      @events.on_event do |event_name, ole, state|
        @events_fired += 1
        p "EVENT: #{event_name}, #{ole}, #{state}"
        event_name.should == "StreamStateChanged"
        ole.ole_type.name.should == "IP2DataStream"
        state.should be_kind_of Fixnum
      end

      @ds.Open(@conn)
      @ds.Close()
#      @conn.ProcessMessage2(100) # Grabs messages/events from queue
      @events_fired.should == 2
    end

    it 'allows setting explicit handler for IP2ConnectionEvent events' do
      class TestHandler
        attr_accessor :events_fired

        def onStreamStateChanged(ole, status)
          @events_fired = (@events_fired || 0) + 1
          p "HANDLER EVENT (StreamStateChanged): #{ole}, #{status}"
          ole.ole_type.name.should == "IP2DataStream"
          status.is_a?(Fixnum).should == true # We are inside Handler class, no #be_kind_of
        end
      end

      @events.handler = TestHandler.new
      @events.handler.should be_a TestHandler

      @ds.Open(@conn)
      @ds.Close()
#      @conn.ProcessMessage2(100) # Grabs messages/events from queue
      @events.handler.events_fired.should == 2
    end
  end #events

  context 'when baseless data stream is open' do
    subject { P2::DataStream.new(baseless_opts).tap { |ds| ds.Open @conn } }

  end # when baseless data stream is open
end
