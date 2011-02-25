# encoding: utf-8
require 'spec_helper'

describe P2Ruby::Message do
  before(:all) do
    P2Ruby::Application.reset CLIENT_INI
    @factory = P2Ruby::MessageFactory.new :ini => MESSAGE_INI
  end
  subject { @factory.message :name => "FutAddOrder",
                             :dest_addr => "FINTER_FORTS3.Dispatcher",
                             :field => {
                                 "P2_Category" => "FORTS_MSG",
                                 :P2_Type => 1,
                                 "isin" => "RTS-3.11",
                                 :price => "184500",
                                 :amount => 1,
                                 "client_code" => "001",
                                 "type" => 1,
                                 "dir" => 1
                             } }

  it 'is not instantiated directly, use MessageFactory instead'

  it 'wraps P2ClientGate.P2BLMessage OLE class' do
    subject.ole_type.name.should == 'IP2BLMessage'
    show_ole
  end

  its(:clsid) { should == '{A9A6C936-5A12-4518-9A92-90D75B41AF18}' }
  its(:progid) { should == 'P2ClientGate.P2BLMessage.1' }
  its(:opts) { should have_key :name }
  its(:ole) { should be_a WIN32OLE }
  its(:Name) { should == "" } # Why? Because there is no Message#Name= setter... :(
  its(:DestAddr) { should == "FINTER_FORTS3.Dispatcher" }

  context 'working with named property Field' do
    it 'initializes Field named properties correctly' do
      subject.Field["P2_Category"].should == "FORTS_MSG"
      subject.Field["P2_Type"].should == 1
      subject.Field['isin'].should == "RTS-3.11"
      subject.Field['price'].should == "184500"
      subject.Field['amount'].should == 1
      subject.Field['client_code'].should == "001"
      subject.Field['type'].should == 1
      subject.Field['dir'].should == 1
    end

    it 'manually sets Field named properties as needed' do
      subject.Field["P2_Category"] = "WHATEVER"
      subject.Field['isin'] = "RTS-3.12"
      subject.Field['amount'] = 100
      subject.Field["P2_Category"].should == "WHATEVER"
      subject.Field['isin'].should == "RTS-3.12"
      subject.Field['amount'].should == 100
    end

    it 'does not test following Fields:' do
      #  [table:message:FutAddOrder]
      #  field = broker_code,c4,,""
      #  field = isin,c25
      #  field = client_code,c3
      #  field = type,i4
      #  field = dir,i4
      #  field = amount,i4
      #  field = price,c17
      #  field = comment,c20,,""
      #  field = broker_to,c20,,""
      #  field = ext_id,i4,,0
      #  field = du,i4,,0
      #  field = date_exp,c8,,""
      #  field = hedge,i4,,0

      p subject.Id()
      p subject.Version()
      print "P2_Type "; p subject.Field["P2_Type"] #служебные поля.
      print "isin "; p subject.Field["isin"]
      print "price "; p subject.Field["price"]
      print "client_code "; p subject.Field["client_code"]

      subject.Field["hedge"] = -1
      print "hedge "; p subject.Field["hedge"]

      print "P2_Type asLL "; p subject.FieldAsLONGLONG["P2_Type"]
      print "hedge asLL "; p subject.FieldAsLONGLONG["hedge"]

      p subject.Field["dir"] ################################
      p subject.Field["amount"]
      p subject.Field["type"]
    end
  end # 'working with named property Field'

  context 'with active connection' do
    before(:all) do
      start_router
      P2Ruby::Application.reset CLIENT_INI
      @conn = P2Ruby::Connection.new :app_name => 'DSTest',
                                     :host => "127.0.0.1", :port => 4001
      @conn.Connect
      @conn.should be_connected
      @conn.should be_logged
      # Disconnected connection, for comparison
      @disconn = P2Ruby::Connection.new :app_name => 'DSTestDisconnected',
                                        :host => "127.0.0.1", :port => 4001
    end

    after(:all) { stop_router }

    describe '#Send()' do
      it 'syncronously sends via active connection with timeout' do
        subject.Send(@conn, 1000)
      end

      it 'syncronously sends via raw connection ole' do
        subject.Send(@conn.ole, 1000)
      end

      it 'fails to send via inactive connection' do
        expect { subject.Send(@disconn, 1000) }.to raise_error /Coudln.t send MQ message/
      end

      it 'returns wrapped server reply message ' do
        reply = subject.Send(@conn, 1000)
        reply.should be_a P2::Message
        reply.Field["P2_Category"].should == "FORTS_MSG"
      end
    end #Send()

    describe '#parse_reply' do
      it 'analyses message as a server reply, returns result text' do
        msg = subject
        reply = msg.Send(@conn, 1000)
        reply.parse_reply.should =~ /Reply category: FORTS_MSG, type 101. Adding order Ok, Order_id:/

        msg.Field['price'] = '1' # Price outside of limits
        reply = msg.Send(@conn, 1000)
        reply.parse_reply.should =~ /Reply category: FORTS_MSG, type 101. Adding order fail, logic error:/
      end
    end
  end
end
