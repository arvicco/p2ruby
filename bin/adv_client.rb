require_relative 'script_helper'
require 'pp'

# Globals
######################################

# File path constants
LOG_PATH = 'log\baseless_client.log'
REV_PATH = 'log\Revisions.txt'

## Global functions:

# Normal log (delegates to client)
def log *args
  $client.log *args if $client
end

# Exception handling wrapper for Win32OLE exceptions.
# Catch/log Win32OLE exceptions, pass on all others...
def try
  begin
    yield
  rescue WIN32OLERuntimeError => e #(System.Runtime.InteropServices.COMException e)
    log "Ignoring caught Win32Ole runtime error:", e
  rescue Exception => e #(System.Exception e)
    $client.finalize if $client
    log "Raising non-Win32Ole error:", e
    raise e
  end
end

# Event processing classes
######################################

# Generic DataStream event handling code
# NOTES:
# 1) Please keep in mind, incoming args are raw OLE objects, not wrapped Ruby classes
# 2) Interrupt inside event hook bubbles up instead of being caught in main loop
#
module DataStreamEventHandlers

  # Handling replication Data Stream status change
  def onStreamStateChanged(stream, new_state)
    log "Stream #{stream.StreamName} state: #{state_text(new_state)}"
    case new_state
      when P2::DS_STATE_CLOSE, P2::DS_STATE_ERROR
        # @opened = false
    end
  end

  # Insert record
  def onStreamDataInserted(stream, table_name, rec)
    @fields[table_name] ||= stream.TableSet.FieldList(table_name).split(',')
    @revisions[table_name] = rec.GetValAsLongByIndex(1)
    log "Stream #{stream.StreamName} inserts into #{table_name} "
    try { process_record rec, @fields[table_name] }
  end

  # Delete record
  def onStreamDataDeleted(stream, table_name, id, rec)
    @revisions[table_name] = rec.GetValAsLongByIndex(1)
    log "Stream #{stream.StreamName} deletes #{id} from #{table_name} "
#    if stream.StreamName == AGGR_ID
##      save_aggr(rec, table_name, stream)
#    else
#      log "Unexpected onStreamDataDeleted for #{stream.StreamName}: deletes #{id} from #{table_name} "
#    end
  end

  # Stream LifeNum change
  # ����������� ��������� ������ ����� � ��������� ����� ����������.
  def onStreamLifeNumChanged(stream, life_num)
    log "Stream #{stream.StreamName} LifeNum changed to #{life_num} "
    self.TableSet.LifeNum = life_num
    self.TableSet.SetLifeNumToIni @ini
  end

  # Dummy events (just for statistics):

  #   ����������� �� ��������� ������ � ��. ��� ����������� ������� �� ��������.
  def onStreamDataUpdated(stream, table_name, id, rec)
    log "Stream #{stream.StreamName} updates #{id} in #{table_name} "
  end

  # ����������� �� �������� ���� ������� �� �� � ��������� ������ ������������ ����������.
  def onStreamDatumDeleted(stream, table_name, rev)
    log "Stream #{stream.StreamName} deletes Datum in #{table_name} with rev below #{rev}"
    # Arrives once per table, can be used to enumerate tables in DataStream!
  end

  # ����������� �� �������� ���� ������.
  def onStreamDBWillBeDeleted(stream)
    log "Stream #{stream.StreamName} DBWillBeDeleted"
  end

  # ����������� ������ ���������� �� ��������� ������ ������ �� ������� ����������.
  def onStreamDataBegin(stream)
    log "Stream #{stream.StreamName} Data begins"
  end

  # ����������� ������ ���������� �� ��������� ������ ������ �� ������� ����������.
  def onStreamDataEnd(stream)
    log "Stream #{stream.StreamName} Data ends"
  end

  # Helper methods:

  # Standard method to process received data record is to save it into @save_file
  # Classes that include DataStreamEventHandlers may redefine their own record handling
  def process_record rec, fields
    #noinspection RubyArgCount
    save_data @save_file, rec, fields
  end

  # Helper method to format record and output it to file
  def save_data file, rec, fields, divider = "\n", finalizer = ""
    file.puts fields.map { |f| "#{f}=#{rec.GetValAsString(f)}" }.join divider
    file.puts(finalizer) if finalizer
    file.flush
  end
end # module DataStreamEventHandlers

# Enhanced P2::DataStream class handling its own Events internally
class EventedDataStream < P2::DataStream

  include DataStreamEventHandlers

  attr_accessor :stats

  def initialize opts = {}
    @conn = opts.delete(:conn)
    @save_path = opts.delete(:save_path)
    @ini = opts.delete(:ini)

    super({:type => P2::RT_COMBINED_DYNAMIC}.merge(opts))

    # Memoized table field names and latest table revisions
    @fields = {}
    @revisions ||= Hash.new(0)

    # If data scheme ini file is given, initialize our TableSet
    # from given scheme and load latest table revisions
    if @ini
      #noinspection RubyArgCount
      self.TableSet = P2::TableSet.new :ini => @ini
      load_revisions
    end

    # Open file for writing received data
    @save_file = File.new(@save_path, "a")

    # Create Stats object that collects event statistics               2
    @stats = Stats.new(self)
    # Register event handlers for Data Stream events (@stats proxy for self)
    self.events.handler = @stats # self
  end

  # (Re)-opens stale DataStream, optionally resetting table revisions of its TableSet
  def keep_alive
    if closed? || error?
      self.Close if error?
      # TableSet is set by server upon Stream opening, unless initialized from scheme ini
      set_revisions if self.TableSet
      self.Open(@conn)
    end
  end

  def load_revisions
    if File.exists? REV_PATH
      pattern = Regexp.new "#{self.StreamName}: (.+) = (\\d+)"
      File.read(REV_PATH).scan(pattern).each { |table, rev| @revisions[table] = rev.to_i }
    end
  end

  def set_revisions
    @revisions.each { |table, rev| self.TableSet.Rev[table.to_s] = rev + 1 }
  end

  def save_revisions
    File.open(REV_PATH, "a") do |file|
      time = Time.now.strftime("%Y-%m-%d %H:%M:%S.%3N")
      @revisions.each do |table, rev|
        file.puts "#{time} #{self.StreamName}: #{table} = #{rev}"
      end
    end
  end
end # class EventedDataStream

# This is an event proxy that collects event statistics,
# and wraps all events in exception processing blocks
class Stats
  def initialize real_handler
    @real_handler = real_handler
    @stats = {}

    # Wrap all event processing methods of real event handler
    # in stats gathering and exception processing blocks
    @real_handler.methods.select { |m| m =~/^on/ }.each do |method|
      self.define_singleton_method(method) do |stream, *args|
        try do
          key = args.empty? ? stream.StreamName : args.first
          @stats[method] ||= Hash.new(0)
          @stats[method][key] += 1
          @real_handler.send method, stream, *args
        end
      end
    end
  end

  def inspect
    @stats
  end

  def to_s
    @stats
  end
end # class Stats

# Main class implementing business logics
class Client

  attr_accessor :streams

  def initialize app_name, router
    @app_name = app_name
    @router = router
    @stop = false

    begin
      # Create Connection object with P2MQRouter connectivity parameters
      @conn = P2::Connection.new :ini => CLIENT_INI,
                                 :host => "localhost",
                                 :port => 4001,
                                 :AppName => @app_name
      # Client will handle Connection's events by default
      @conn.events.handler = self

      @streams = {}
      @outputs = []
      # Run setup for client subclasses
      setup

      # Adding streams stats to outputs:
      @outputs += @streams.map { |id, stream| [id, stream.stats] }.flatten

    rescue WIN32OLERuntimeError => e
      log e
      if P2.p2_error(e) == P2::P2ERR_INI_PATH_NOT_FOUND #Marshal.GetHRForException(e)
        log "Can't find one or both of ini file: P2ClientGate.ini, orders_aggr.ini"
      end
      raise e
    rescue Exception => e #(System.Exception e)
      log "Raising non-Win32Ole error in initialize: #{e}"
      raise e
    end
  end

  # Override and set up @streams and @outputs here
  # (as well as other artifacts specific to your client)
  def setup
  end

  # Main event cycle
  def run
    until @stop
      try do
        # (Re)-connecting to Router
        @conn.Connect()
        try do
          until @stop
            # Check status for all streams, reopen as necessary
            try { @streams.each { |_, stream| stream.keep_alive } }

            # Actual processing of incoming messages happens in event callbacks
            # O����������� ��������� ��������� � ����������� ��������� ������
            @conn.ProcessMessage2(100)
          end
        end

        # Make sure streams are closed and disconnect before reconnecting
        try { @streams.each { |_, stream| stream.Close unless stream.closed? } }
        @conn.Disconnect()
      end
    end
  end

  # Client's cleanup actions
  def finalize
    # Make sure this finalizer runs only once
    unless @finalized
      @stop = true
      @streams.each do |_, stream|
        stream.Close unless stream.closed?
        stream.save_revisions
      end
      @conn.Disconnect()
      @router.exit

      @outputs.each { |out| pp out }
      @finalized = true
    end
  end

  # Handling Connection status change
  def onConnectionStatusChanged(conn, new_status)
    log "MQ connection state " + @conn.status_text(new_status)

    if ((new_status & P2::CS_ROUTER_CONNECTED) != 0)
      # ����� ����������� - ����������� ����� �������-����������� ?
    end
  end

  def log *args
    STDOUT.puts "#{Time.now.strftime('%Y-%m-%d %H:%M:%S.%3N')}: #{args}"
    #  @log_file ||= File.new(LOG_PATH, "w") # System.Text.Encoding.Unicode)
  end
end # class Client