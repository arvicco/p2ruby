#!/usr/bin/env ruby
# encoding: Windows-1251

require_relative 'start_script'

# This script replicates P2AddOrderConsole.cpp functionality (but for async Send)

# Event processing classes
######################################
class ConnectionEvents < P2::Connection
  def initialize app_name
    # создаем объект Connection
    super :app_name => app_name, :host => "127.0.0.1", :port => 4001
    self.events.handler = self
    self.Connect()
  end

  # IP2ConnectionEvent
  def onConnectionStatusChanged(conn, new_status)
    $log.puts "EVENT ConnectionStatusChanged: #{conn} - #{status_text new_status}"
  end
end

#####################################
class DataStreamEvents < P2::DataStream
  def initialize conn, short_name
    # создаем объект DataStream
    super :stream_name => "FORTS_#{short_name}_REPL", :type => P2::RT_COMBINED_DYNAMIC #,
#          :DBConnString => "P2DBSqLiteD.dll;;Log\\#{short_name}_.db"
    self.events.handler = self
    self.Open(conn)
  end

  def wrap(rec)
    P2::Record.new :ole => rec unless rec.is_a? P2::Record
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
    $log.puts "StreamStateChanged #{stream.StreamName} - #{str}"
  end

  def onStreamDataInserted stream, tableName, rec
#    return unless tableName == 'sys_messages'
    $log.puts "StreamDataInserted #{stream.StreamName} - #{tableName}: #{wrap(rec)}"
#    $log.puts "StreamDataInserted #{stream} - #{tableName} - #{rec}"
  end

  def onStreamDataUpdated(stream, tableName, id, rec)
    $log.puts "StreamDataUpdated #{stream.StreamName} - #{tableName} - #{id}: #{wrap(rec)}"
  end

  def onStreamDataDeleted(stream, tableName, id, rec)
    $log.puts "StreamDataDeleted #{stream.StreamName} - #{tableName} - #{id}: #{wrap(rec)}"
  end

  def onStreamDatumDeleted(stream, tableName, rev)
    $log.puts "StreamDatumDeleted #{stream.StreamName} - #{tableName} - #{rev}"
  end

  def onStreamDBWillBeDeleted(stream)
    $log.puts "StreamDBWillBeDeleted #{stream.name} "
  end

  def onStreamLifeNumChanged(stream, lifeNum)
    $log.puts "StreamLifeNumChanged #{stream.StreamName} - #{lifeNum} "
  end

  def onStreamDataBegin(stream)
    $log.puts "StreamDataBegin #{stream.StreamName} "
  end

  def onStreamDataEnd(stream)
    $log.puts "StreamDataEnd #{stream.StreamName} "
  end

end

#####################################
#class CAsyncMessageEvent :
#####################################
#class CAsyncSendEvent2 :

# Global functions
#####################################
def showerror(e)
  $log.puts e
#  fprintf(g_fLog, "COM error occured\n");
#  fprintf(g_fLog, "\tError:        %08lx\n", e.Error());
#  fprintf(g_fLog, "\tErrorMessage: %s\n", e.ErrorMessage());
#  fprintf(g_fLog, "\tSource:       %s\n", static_cast<LPCTSTR>(e.Source()));
#  fprintf(g_fLog, "\tDescription:  %s\n", static_cast<LPCTSTR>(e.Description()));
end

def PrintMsg(reply, errCode)
  if (errCode == 0)
    $log.puts reply.parse_reply
  else
    $log.puts "Delivery errorCode: #{errCode}"
  end
end

# Signal handlers
####################################
Signal.trap("INT") do |signo|
  puts "Send sync message?"
  if 'y' == gets.chomp
    $log.puts "Sending sync message..."
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
    reply = P2::Message.new :ole => raw_reply

    PrintMsg(reply, errCode)
  else
    puts "Interrupted... (#{signo})"
    $exit = true
  end
end

# Main execution logics
#####################################
#void ThreadProc(void* name)

$log = File.new "log\\order_console.log", 'w'  #  STDOUT #
$exit = false

#####################################
start_router do
  P2::Application.reset CLIENT_INI
  conn = ConnectionEvents.new "RbOrderConsole"
  ds_events = DataStreamEvents.new conn, "FUTINFO"

  srv_addr = conn.ResolveService("FORTS_SRV")

  puts "Press any key to send message"
  msgs = P2::MessageFactory.new :ini => MESSAGE_INI

  conn.ProcessMessage2(1000) until $exit && conn.connected?
end
