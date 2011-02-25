#!/usr/bin/env ruby
# encoding: Windows-1251

require_relative 'start_script'

# This script replicates SimpleSend.js functionality

start_router do

  # Resetting Application with correct ini file

  P2::Application.reset CLIENT_INI
  conn = P2::Connection.new :app_name => 'DSTest',
                            :host => "127.0.0.1", :port => 4001
  conn.Connect

  @ds = P2::DataStream.new :stream_name => 'RTS_INDEX_REPL', :type => P2::RT_COMBINED_DYNAMIC

  @ds.events.on_event do |event_name, ole, state|
    p "EVENT: #{event_name}, #{ole}, #{state}"
  end

  @ds.Open(conn)

  puts "Entering message loop"
  conn.ProcessMessage2(1000) until $exit
end
