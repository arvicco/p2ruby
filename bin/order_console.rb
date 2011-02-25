#!/usr/bin/env ruby
# encoding: Windows-1251

require 'pathname'
lib = (Pathname.new(__FILE__).dirname + '../lib').expand_path.to_s
$:.unshift lib unless $:.include?(lib)
require 'p2ruby'

# This script replicates P2@AddOrderConsole.cpp functionality (but for async Send)

# First we need to cd into p2 main dir (and make sure Router is started)
ROUTER_INI = Dir["../../spec/**/client_router.ini"].first
ROUTER_PATH = Dir["**/P2MQRouter.exe"].first
router = P2Ruby::Router.new :path => ROUTER_PATH, :ini => ROUTER_INI

sleep 0.3
puts "Router started at #{ROUTER_PATH}..."
#------------------------

#$log = File.new "Log\\P2AddOrderConsole.log", 'w'
##     SetConsoleOutputCP(1251); ?
#

#####################################
def showerror(e)
  puts e
#  fprintf(g_fLog, "COM error occured\n");
#  fprintf(g_fLog, "\tError:        %08lx\n", e.Error());
#  fprintf(g_fLog, "\tErrorMessage: %s\n", e.ErrorMessage());
#  fprintf(g_fLog, "\tSource:       %s\n", static_cast<LPCTSTR>(e.Source()));
#  fprintf(g_fLog, "\tDescription:  %s\n", static_cast<LPCTSTR>(e.Description()));
end

#####################################
class CConnEvent < P2::Connection
  def initialize app_name #("P2ClientGate.P2Connection")
    # создаем объект Connection
    super :app_name => app_name, :host => "127.0.0.1", :port => 4001
    self.events.handler = self
    self.Connect()
  end

  # IP2ConnectionEvent
  def onConnectionStatusChanged(conn, new_status)
    puts "EVENT!"
    puts status_text new_status
  end
end

#####################################
class CDSEvents < P2::DataStream
  def initialize conn, short_name
    super :name => "FORTS_#{short_name}_REPL", :type => P2::RT_REMOTE_ONLINE#, #RT_COMBINED_DYNAMIC,
#          :db_conn_string => "P2DBSqLiteD.dll;;Log\\#{short_name}_.db"
    self.events.handler = self
    self.Open(conn)
  end

  def PrintRec(rec)
    unless rec.is_a? P2::Record
      puts "Couldn't print record #{rec}"
      return
    end

    puts (0..rec.Count).map { |i| rec.GetValAsStringByIndex(i) }.join "|"
  end

  # IP2DataStreamEvents
  def onStreamStateChanged(stream, newState)
    case newState
      when DS_STATE_CLOSE
        str = "CLOSED"
      when DS_STATE_LOCAL_SNAPSHOT
        str = "LOCAL_SNAPSHOT"
      when DS_STATE_REMOTE_SNAPSHOT
        str = "REMOTE_SNAPSHOT"
      when DS_STATE_ONLINE
        str = "ONLINE"
      when DS_STATE_CLOSE_COMPLETE
        str = "CLOSE_COMPLETE"
      when DS_STATE_REOPEN
        str = "REOPEN"
      when DS_STATE_ERROR
        str = "ERROR"
      else
        str = ""
    end
    puts "StreamStateChanged #{stream} - #{str}"
  end

  def onStreamDataInserted stream, tableName, rec
    puts "StreamDataInserted #{stream} - #{tableName} - #{rec}"
    PrintRec(rec)
  end

  def onStreamDataUpdated(stream, tableName, id, rec)
    puts "StreamDataUpdated #{stream} - #{tableName} - #{id} - #{rec}"
    PrintRec(rec)
  end

  def onStreamDataDeleted(stream, tableName, id, rec)
    puts "StreamDataDeleted #{stream} - #{tableName} - #{id} - #{rec}"
    PrintRec(rec)
  end

  def onStreamDatumDeleted(stream, tableName, rev)
    puts "StreamDatumDeleted #{stream} - #{tableName} - #{rev}"
    PrintRec(rec)
  end

  def onStreamDBWillBeDeleted(stream)
    puts "StreamDBWillBeDeleted #{stream} "
  end

  def onStreamLifeNumChanged(stream, lifeNum)
    puts "StreamLifeNumChanged #{stream} - #{lifeNum} "
  end

  def onStreamDataBegin(stream)
    puts "StreamDataBegin #{stream} "
  end

  def onStreamDataEnd(stream)
    puts "StreamDataEnd #{stream} "
  end
end

#####################################
def PrintMsg(reply, errCode)
  if (errCode == 0)
    c = reply.Field["P2_Category"]
    t = reply.Field["P2_Type"]

    if c == "FORTS_MSG" && t == 101
      code = reply.Field["code"]
      if (code == 0)
        orderId = reply.Field["order_id"]
        puts "Adding order Ok, Order_id is #{orderId}"
      else
        message = reply.Field["message"]
        puts "Adding order fail, logic error is #{message}"
      end
    elsif c == "FORTS_MSG" && t == 100
      errCode = reply.Field["err_code"]
      message = reply.Field["message"]
      puts "Adding order fail, system level error #{errCode}: #{message}"
    else
      puts "Unexpected MQ message recieved; category #{c} type #{t}"
    end
  else
    puts "Delivery errorCode: #{errCode}"
  end
end

#####################################
#class CAsyncMessageEvent :
#####################################
#class CAsyncSendEvent2 :

####################################
$exit = false

Signal.trap("INT") do |signo|
  puts "Send sync message?"
  if 'y' == gets.chomp
    puts "Sending sync message..."
    msg = msgs.message :name => "FutAddOrder",
                       :dest_addr => srv_addr,
                       :field => {
                           "P2_Category" => "FORTS_MSG",
                           "P2_Type" => 1,
                           "isin" => "RTS-3.11",
                           :price => "185500",
                           :amount => 1,
                           "client_code" => "001",
                           "type" => 1,
                           "dir" => 1}
    raw_reply = msg.Send(conn.ole, 5000) # посылаем, ждем ответа в течение 5000 миллисекунд
    reply = P2Ruby::Message.new :ole => raw_reply

    PrintMsg(reply, errCode)
  else
    puts "Interrupted... (#{signo})"
    $exit = true
  end
end

#####################################
#void ThreadProc(void* name)


#####################################
begin
  conn = CConnEvent.new "RbOrderConsole"
  dsFUTNFO = CDSEvents.new conn, "FUTINFO"

  srv_addr = conn.ResolveService("FORTS_SRV")

  puts "Press any key to send message"
  msgs = P2::MessageFactory.new :ini => "p2fortsgate_messages.ini"

  conn.ProcessMessage2(1000) until $exit
rescue => e
  showerror(e)
  raise e
ensure
  router.exit
end
