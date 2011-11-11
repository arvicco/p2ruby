#!/usr/bin/env ruby
# encoding: Windows-1251
require 'p2ruby'

# This script replicates P2AddOrderConsole.cpp functionality (but for async Send)

module Clients
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
  end # class ConnectionEvents

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
  end # class DataStreamEvents

end # module Clients

#####################################
#class CAsyncMessageEvent : Not used, Async Send event interfaces not implemented :(
#####################################
#class CAsyncSendEvent2 : Not used, Async Send event interfaces not implemented :(
