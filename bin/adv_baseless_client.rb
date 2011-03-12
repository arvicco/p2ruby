require_relative 'adv_client'

# Replication Stream parameters
AGGR_ID = 'FORTS_FUTAGGR20_REPL'
AGGR_INI = 'spec\files\orders_aggr.ini'
AGGR_PATH = 'log\SaveAggrRev.txt'

DEAL_ID = 'FORTS_FUTTRADE_REPL'
DEAL_INI = 'spec\files\fut_trades.ini'
DEAL_PATH = 'log\SaveDeal.txt'

COMMON_ID = 'FORTS_FUTCOMMON_REPL'
COMMON_INI = 'spec\files\fut_common.ini'
COMMON_PATH = 'log\SaveCommon.txt'

### Global functions:
#
## Normal log (STDOUT)
#def log
#  STDOUT
##  @log_file ||= File.new(LOG_PATH, "w") # System.Text.Encoding.Unicode)
#end
#
## Error log (for unexpected events/exceptions)
#def error_log
#  @error_log_file ||= File.new(LOG_PATH, "w") # System.Text.Encoding.Unicode)
#end
#
## Exception handling wrapper for Win32OLE exceptions.
## Catch/log Win32OLE exceptions, pass on all others...
#def try
#  begin
#    yield
#  rescue WIN32OLERuntimeError => e #(System.Runtime.InteropServices.COMException e)
#    log.puts "Ignoring caught Win32Ole runtime error:", e
#  rescue Exception => e #(System.Exception e)
#    $client.streams.each do |_, stream|
#      puts "#{stream.StreamName}:"
#      pp stream.stats
#      stream.save_revisions
#    end
#    log.puts "Raising non-Win32Ole error:", e
#    raise e
#  end
#end
#
## Event processing classes
#######################################
#
## Generic DataStream event handling code
## NOTES:
## 1) Please keep in mind, incoming args are raw OLE objects, not wrapped Ruby classes
## 2) Interrupt inside event hook bubbles up instead of being caught in main loop
##
#module DataStreamEventHandlers
#
#  # Handling replication Data Stream status change
#  def onStreamStateChanged(stream, new_state)
#    log.puts "Stream #{stream.StreamName} state: #{state_text(new_state)}"
#    case new_state
#      when P2::DS_STATE_CLOSE, P2::DS_STATE_ERROR
#        # @opened = false
#    end
#  end
#
#  # Insert record
#  def onStreamDataInserted(stream, table_name, rec)
#    @fields[table_name] ||= stream.TableSet.FieldList(table_name).split(',')
#    @revisions[table_name] = rec.GetValAsLongByIndex(1)
#    log.puts "Stream #{stream.StreamName} inserts into #{table_name} "
#    try { process_record rec, @fields[table_name] }
#  end
#
#  # Delete record
#  def onStreamDataDeleted(stream, table_name, id, rec)
#    @revisions[table_name] = rec.GetValAsLongByIndex(1)
#    log.puts "Stream #{stream.StreamName} deletes #{id} from #{table_name} "
#    if stream.StreamName == AGGR_ID
##      save_aggr(rec, table_name, stream)
#    else
#      error_log.puts "Unexpected onStreamDataDeleted for #{stream.StreamName}: deletes #{id} from #{table_name} "
#      error_log.flush
#    end
#  end
#
#  # Stream LifeNum change
#  # Нотификация изменения номера жизни в серверной схеме репликации.
#  def onStreamLifeNumChanged(stream, life_num)
#    log.puts "Stream #{stream.StreamName} LifeNum changed to #{life_num} "
#    self.TableSet.LifeNum = life_num
#    self.TableSet.SetLifeNumToIni @ini
#  end
#
#  # Dummy events (just for statistics):
#
#  #   Нотификация об изменении записи в БД. Для безбазового клиента не приходит.
#  def onStreamDataUpdated(stream, table_name, id, rec)
#  end
#
#  # Нотификация об удалении всех записей из БД с ревижином меньше минимального серверного.
#  def onStreamDatumDeleted(stream, table_name, rev)
#    # Arrives once per table, can be used to enumerate tables in DataStream!
#  end
#
#  # Нотификация об удалении базы данных.
#  def onStreamDBWillBeDeleted(stream)
#  end
#
#  # Нотификация начала транзакции по обработке пакета данных от сервера репликации.
#  def onStreamDataBegin(stream)
#  end
#
#  # Нотификация начала транзакции по обработке пакета данных от сервера репликации.
#  def onStreamDataEnd(stream)
#  end
#
#  # Helper methods:
#
#  # Standard method to process received data record is to save it into @save_file
#  # Classes that include DataStreamEventHandlers may redefine their own record handling
#  def process_record rec, fields
#    #noinspection RubyArgCount
#    save_data @save_file, rec, fields
#  end
#
#  # Helper method to format record and output it to file
#  def save_data file, rec, fields, divider = "\n", finalizer = ""
#    file.puts fields.map { |f| "#{f}=#{rec.GetValAsString(f)}" }.join divider
#    file.puts(finalizer) if finalizer
#    file.flush
#  end
#end
#
## Enhanced P2::DataStream class handling its own Events internally
#class EventedDataStream < P2::DataStream
#
#  include DataStreamEventHandlers
#
#  attr_accessor :stats
#
#  def initialize opts = {}
#    @conn = opts.delete(:conn)
#    @save_path = opts.delete(:save_path)
#    @ini = opts.delete(:ini)
#
#    super opts
#
#    # Initialize data streams TableSet with given scheme and load latest table revisions
#    #noinspection RubyArgCount
#    self.TableSet = P2::TableSet.new :ini => @ini
#    set_revisions
#
#    # Open file for writing received data
#    @save_file = File.new(@save_path, "a")
#
#    # Memoized table field names
#    @fields = {}
#
#    # Create Stats object that collects event statistics
#    @stats = Stats.new(self)
#    # Register event handlers for Data Stream events (@stats proxy for self)
#    self.events.handler = @stats # self
#  end
#
#  # (Re)-opens stale data stream, optionally resetting table revisions of its TableSet
#  def keep_alive
#    if closed? || error?
#      self.Close if error?
#      set_revisions if self.TableSet
#      self.Open(@conn)
#    end
#  end
#
#  def load_revisions
#    @revisions ||= Hash.new(0)
#    if File.exists? REV_PATH
#      pattern = Regexp.new "#{self.StreamName}: (.+) = (\\d+)"
#      File.read(REV_PATH).scan(pattern).each { |table, rev| @revisions[table] = rev.to_i }
#    end
#  end
#
#  def set_revisions
#    load_revisions unless @revisions
#    @revisions.each { |table, rev| self.TableSet.Rev[table.to_s] = rev + 1 }
#  end
#
#  def save_revisions
#    File.open(REV_PATH, "a") do |file|
#      time = Time.now.strftime("%Y-%m-%d %H:%M:%S.%3N")
#      @revisions.each do |table, rev|
#        file.puts "#{time} #{self.StreamName}: #{table} = #{rev}"
#      end
#    end
#  end
#end
#
## This is an event proxy that just collects event statistics
#class Stats
#  def initialize real_handler
#    @real_handler = real_handler
#    @stats = {}
#
#    # Mock all event processing methods of real event handler
#    @real_handler.methods.select { |m| m =~/^on/ }.each do |method|
#      self.define_singleton_method(method) do |stream, *args|
#        key = args.empty? ? stream.StreamName : args.first
#        @stats[method] ||= Hash.new(0)
#        @stats[method][key] += 1
#        @real_handler.send method, stream, *args
#      end
#    end
#  end
#
#  def inspect
#    @stats
#  end
#
#  def to_s
#    @stats
#  end
#end
#

# Main class implementing business logics
class BaselessClient < Client

  attr_accessor :stats, :streams

  def setup
      # Create replication objects for interesting data streams
      @streams =
          {:common => EventedDataStream.new(:type => P2::RT_COMBINED_DYNAMIC,
                                            :name => COMMON_ID,
                                            :ini => COMMON_INI,
                                            :save_path => COMMON_PATH,
                                            :conn => @conn),

           :orders => EventedDataStream.new(:type => P2::RT_COMBINED_DYNAMIC,
                                            :name => AGGR_ID,
                                            :ini => AGGR_INI,
                                            :save_path => AGGR_PATH,
                                            :conn => @conn),

           :deals => EventedDataStream.new(:type => P2::RT_COMBINED_DYNAMIC,
                                           :name => DEAL_ID,
                                           :ini => DEAL_INI,
                                           :save_path => DEAL_PATH,
                                           :conn => @conn)}

      # TODO: tweak #process_record method for @stream[:orders]
  end

#  # Insert record
#  def onStreamDataInserted(stream, table_name, rec)
#    # Interrupt inside event hook bubbles up instead of being caught in main loop...
#    try do
#      log.puts "Stream #{stream.StreamName} inserts into #{table_name} "
#
#      if stream.StreamName == AGGR_ID
#        # This is FORTS_FUTAGGR20_REPL stream event
#        save_aggr(rec, table_name, stream)
#
#      elsif stream.StreamName == DEAL_ID && table_name == 'deal'
#        # This is FORTS_FUTTRADE_REPL stream event
#        # !!!! Saving only records from 'deal' table, not heartbeat or multileg_deal
#        save_data(rec, table_name, @deal_file, stream, "\n", '')
#      end
#    end
#  end
#
#  # Save/log aggregate orders record
#  def save_aggr(rec, table_name, stream)
#    save_data(rec, table_name, log, stream)
#    @aggr_file.puts "replRev=#{@revisions['orders_aggr']}"
#    @aggr_file.flush
#  end
#
#  # Save/log given record data
#  def save_data(rec, table_name, file, stream, divider = '; ', finalizer = nil)
#    @revisions[table_name] = rec.GetValAsLongByIndex(1)
#
#    fields = stream.TableSet.FieldList(table_name) #"deal"]
#    file.puts fields.split(',').map { |f| "#{f}=#{rec.GetValAsString(f)}" }.join divider
#    file.puts(finalizer) if finalizer
#    file.flush
#  end
end

# The main entry point for the application.
router = start_router

begin
  $client = BaselessClient.new 'Adv_baseless', router
  $client.run
rescue Exception => e
  puts "Caught in main loop: #{e.class}"
  raise e
end
