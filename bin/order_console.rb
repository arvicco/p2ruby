#!/usr/bin/env ruby
# encoding: Windows-1251

require_relative 'script_helper'

# This script replicates P2AddOrderConsole.cpp functionality (but for async Send)

# Event processing classes
######################################
class ConnectionEvents < P2::Connection
  def initialize app_name
    # Create Connection object
    super :ini => CLIENT_INI, :app_name => app_name,
          :host => "127.0.0.1", :port => 4001
    self.events.handler = self
    self.Connect()
  end

  # Define Handler for IP2ConnectionEvent event interface
  def onConnectionStatusChanged(conn, new_status)
    $log.puts "EVENT ConnectionStatusChanged: #{conn} - #{status_text new_status}"
  end
end

#####################################
class DataStreamEvents < P2::DataStream
  def initialize conn, short_name
    # Create DataStream object
    super :stream_name => "#{short_name}_REPL", :type => P2::RT_COMBINED_DYNAMIC #,
#          :DBConnString => "P2DBSqLiteD.dll;;Log\\#{short_name}_.db"
    self.events.handler = self
    self.Open(conn)
  end

  def wrap(rec)
    P2::Record.new :ole => rec
  end

  # Define Handlers for IP2DataStreamEvents event interface
  def onStreamStateChanged(stream, new_state)
    $log.puts "StreamStateChanged #{stream.StreamName} - #{state_text(new_state)}"
  end

  def onStreamDataInserted stream, table_name, rec
    return unless table_name == 'sys_messages' # Single out one table events
    $log.puts "StreamDataInserted #{stream.StreamName} - #{table_name}: #{wrap(rec)}"
  end

  def onStreamDataUpdated(stream, table_name, id, rec)
    $log.puts "StreamDataUpdated #{stream.StreamName} - #{table_name} - #{id}: #{wrap(rec)}"
  end

  def onStreamDataDeleted(stream, table_name, id, rec)
    $log.puts "StreamDataDeleted #{stream.StreamName} - #{table_name} - #{id}: #{wrap(rec)}"
  end

  def onStreamDatumDeleted(stream, table_name, rev)
    $log.puts "StreamDatumDeleted #{stream.StreamName} - #{table_name} - #{rev}"
  end

  def onStreamDBWillBeDeleted(stream)
    $log.puts "StreamDBWillBeDeleted #{stream.StreamName} "
  end

  def onStreamLifeNumChanged(stream, life_num)
    $log.puts "StreamLifeNumChanged #{stream.StreamName} - #{life_num} "
  end

  def onStreamDataBegin(stream)
    $log.puts "StreamDataBegin #{stream.StreamName} "
  end

  def onStreamDataEnd(stream)
    $log.puts "StreamDataEnd #{stream.StreamName} "
  end
end

#####################################
#class CAsyncMessageEvent : Not used, Async Send event interfaces not implemented :(
#####################################
#class CAsyncSendEvent2 : Not used, Async Send event interfaces not implemented :(

# Global functions
#####################################
def send_message conn, server_address, message_factory
  $log.puts "Sending sync message..."

  msg = message_factory.message ADD_ORDER_OPTS
  msg.DestAddr = server_address

  reply = msg.Send(conn, 1000)

  $log.puts reply.parse_reply

  $send = false
end

# Signal Handler (sends signals into main event loop via global variables)
####################################
Signal.trap("INT") do |signo|
  puts "Send sync message?"
  if 'y' == STDIN.gets.chomp
    $send = true
  else
    puts "Interrupted... (#{signo})"
    $exit = true
  end
end

# Main execution logics
#####################################
# void ThreadProc(void* name) : Not sure why second event loop is needed?

$log = ARGV.first == 'log' ? File.new("log\\order_console.log", 'w') : STDOUT
$exit = false
$send = false

start_router do
  conn = ConnectionEvents.new "RbOrderConsole"
  ds_futinfo = DataStreamEvents.new conn, "FORTS_FUTINFO"
#  ds_pos = DataStreamEvents.new conn, "FORTS_POS"
#  ds_part = DataStreamEvents.new conn, "FORTS_PART"
#  ds_futtrade = DataStreamEvents.new conn, "FORTS_FUTTRADE"
#  ds_optinfo = DataStreamEvents.new conn, "FORTS_OPTINFO"
#  ds_futaggr = DataStreamEvents.new conn, "FORTS_OPTAGGR"
#  ds_futaggr20 = DataStreamEvents.new conn, "FORTS_FUTAGGR20"
#  ds_optcommon = DataStreamEvents.new conn, "FORTS_OPTCOMMON"
#  ds_futcommon = DataStreamEvents.new conn, "FORTS_FUTCOMMON"
  ds_index = DataStreamEvents.new conn, "RTS_INDEX"

  server_address = conn.ResolveService("FORTS_SRV")

  puts "Press Ctrl-C to send message or interrupt program"
  message_factory = P2::MessageFactory.new :ini => MESSAGE_INI

  until $exit
    send_message(conn, server_address, message_factory) if $send
    conn.ProcessMessage2(1000)
  end
end
