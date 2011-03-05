require_relative 'script_helper'
require 'pp'

# Constants
LOG_PATH = 'log\baseless_client.log'
AGGR_PATH = 'log\SaveAggrRev.txt'
DEAL_PATH = 'log\SaveDeal.txt'

# Replication Streams
AGGR_INI = 'spec\files\orders_aggr.ini'
DEAL_INI = 'spec\files\fut_trades.ini'
AGGR_ID = 'FORTS_FUTAGGR20_REPL'
DEAL_ID = 'FORTS_FUTTRADE_REPL'

# Extensions
module P2
  # Reopening P2::DataStream class to hack in #keep_alive method.
  class DataStream < Base
    # (Re)-opens stale data stream, optionally resetting table revisions of its TableSet
    def keep_alive(conn, revisions={})
      if closed? || error?
        self.Close() if error?
        revisions.each { |table, rev| self.TableSet.Rev[table.to_s] = rev } if self.TableSet
        self.Open(conn)
      end
    end
  end
end

# Global functions
def log
  STDOUT
#  @log_file ||= File.new(LOG_PATH, "w") # System.Text.Encoding.Unicode)
end

module P2BaselessClient #P2SimpleGate2Client

  # This is an event proxy that just collects event statistics
  class Stats
    def initialize real_handler
      @real_handler = real_handler
      @stats = {}

      # Mock all event processing methods of real event handler
      @real_handler.methods.select { |m| m =~/^on/ }.each do |method|
        self.define_singleton_method(method) do |stream, key, *args|
          @stats[method] ||= Hash.new(0)
          @stats[method][key] += 1
          @real_handler.send method, stream, key, *args
        end
      end
    end

    def inspect
      @stats
    end

    def to_s
      @stats
    end
  end

  # Main class implementing business logics
  class Client

    attr_accessor :stats

    def initialize
      @stop = false

      begin
        # Объект "соединение" и параметры соединения с приложением P2MQRouter
        @conn = P2::Connection.new :ini => CLIENT_INI,
                                   :host => "localhost",
                                   :port => 4001,
                                   :AppName => "p2ruby_baseless"

        # Load previous table revisions of data streams
        @current_rev = {"orders_aggr" => load_rev(AGGR_PATH),
                        "deal" => load_rev(DEAL_PATH)}

        # Open files for writing received data (and tracking table revisions)
        @aggr_file ||= File.new(AGGR_PATH, "w") # System.Text.Encoding.Unicode)
        @deal_file ||= File.new(DEAL_PATH, "w") # System.Text.Encoding.Unicode)

        # Initialize TableSets with scheme and revision data
        deal_tables = P2::TableSet.new :ini => DEAL_INI,
                                       :rev => {"deal" => @current_rev["deal"] + 1}
        aggr_tables = P2::TableSet.new :ini => AGGR_INI,
                                       :rev => {"orders_aggr" =>
                                                    @current_rev["orders_aggr"] + 1}

        # Create "replication data stream" object for aggregated orders info
        @aggr_stream = P2::DataStream.new :type => P2::RT_COMBINED_DYNAMIC,
                                          :name => AGGR_ID,
                                          :TableSet => aggr_tables

        # Create "replication data stream" object for incoming trades/deals info
        @deal_stream = P2::DataStream.new :type => P2::RT_COMBINED_DYNAMIC,
                                          :name => DEAL_ID,
                                          :TableSet => deal_tables
        #        @deal_stream.TableSet.InitFromIni2("forts_scheme.ini", "FutTrade")

        # Create Stats objects  collect event statistics
        @stats = {AGGR_ID => Stats.new(self),
                  DEAL_ID => Stats.new(self)}

        # Register event handlers for Connection and Data Stream events
        @conn.events.handler = self
        @aggr_stream.events.handler = @stats[AGGR_ID] # self
        @deal_stream.events.handler = @stats[DEAL_ID] # self

      rescue WIN32OLERuntimeError => e
        log.puts e
        if P2.p2_error(e) == P2::P2ERR_INI_PATH_NOT_FOUND #Marshal.GetHRForException(e)
          log.puts "Can't find one or both of ini file: P2ClientGate.ini, orders_aggr.ini"
        end
        raise e
      rescue Exception => e #(System.Exception e)
        log.puts "Raising non-Win32Ole error in initialize:", e
        raise e
      end
    end

    # Exception handling wrapper for Win32OLE exceptions.
    # Catch/log Win32OLE exceptions, pass on all others...
    def try
      begin
        yield
      rescue WIN32OLERuntimeError => e #(System.Runtime.InteropServices.COMException e)
        log.puts "Ignoring caught Win32Ole runtime error:", e
      rescue Exception => e #(System.Exception e)
        pp @stats
        log.puts "Raising non-Win32Ole error:", e
        raise e
      end
    end

    # Main event cycle
    def Run()
      until @stop
        try do
          # (Re)-connecting to Router
          @conn.Connect()
          try do
            until @stop
              try do
                @aggr_stream.keep_alive @conn, :orders_aggr => @current_rev["orders_aggr"] + 1
                @deal_stream.keep_alive @conn, :deal => @current_rev["deal"] + 1
              end
              # Actual processing of incoming messages happens in event callbacks
              # Oбрабатываем пришедшее сообщение в интерфейсах обратного вызова
              @conn.ProcessMessage2(100)
            end
          end

          try { @aggr_stream.Close() } if (@aggr_stream.State != P2::DS_STATE_CLOSE)
          try { @deal_stream.Close() } if (@deal_stream.State != P2::DS_STATE_CLOSE)

          @conn.Disconnect()
        end
      end
    end

    # Обработка состояния соединения
    def onConnectionStatusChanged(conn, new_status)
      state = "MQ connection state " + @conn.status_text(new_status)

      if ((new_status & P2::CS_ROUTER_CONNECTED) != 0)
        # Когда соединились - запрашиваем адрес сервера-обработчика
      end
      log.puts(state)
    end

    # Обработка состояния потока репликации
    def onStreamStateChanged(stream, new_state)
      state = "Stream #{stream.StreamName} state: #{@deal_stream.state_text(new_state)}"
      case new_state
        when P2::DS_STATE_CLOSE, P2::DS_STATE_ERROR
          # @opened = false
      end
      log.puts(state)
    end

    # Insert record
    def onStreamDataInserted(stream, table_name, rec)
      # Interrupt inside event hook bubbles up instead of being caught in main loop...
      try do
        log.puts "Stream #{stream.StreamName} inserts into #{table_name} "

        if stream.StreamName == AGGR_ID
          # Пришел поток FORTS_FUTAGGR20_REPL
#          save_data(rec, table_name, @aggr_file, stream)
          save_aggr_rev(rec, table_name)

        elsif stream.StreamName == DEAL_ID
          # Пришел поток FORTS_FUTTRADE_REPL
          # !!!! Saves records from ALL tables for now, while we need only 'deal'
#          save_data(rec, table_name, @deal_file, stream, '\n', '')
          save_deal_data(rec, table_name)
        end
      end
    end

    # Delete record
    def onStreamDataDeleted(stream, table_name, id, rec)
#      save_data(rec, table_name, @aggr_file, stream)
      save_aggr_rev(rec, table_name)
      log.puts "Stream #{stream.StreamName} deletes #{id} from #{table_name} "
    end

    # Stream LifeNum chang
    def onStreamLifeNumChanged(stream, life_num)
      if (stream.StreamName == AGGR_ID)
        @aggr_stream.TableSet.LifeNum = life_num
        @aggr_stream.TableSet.SetLifeNumToIni(AGGR_INI)
      end
      if (stream.StreamName == DEAL_ID)
        @deal_stream.TableSet.LifeNum = life_num
        @deal_stream.TableSet.SetLifeNumToIni(DEAL_INI)
      end
    end

    # Load latest revision from file with given path,
    # return 0 if no file or saved revision available
    def load_rev file_path
      if File.exists? file_path
        File.open(file_path) do |file|
          line = file.readlines.select { |l| l =~ /^replRev/ }.last
          rev = line ? line.split('=')[1] : nil
          rev.chomp.to_i if rev
        end
      end || 0
    end

    def save_aggr_rev(rec, table_name)
      @aggr_file ||= File.new(AGGR_PATH, "w") # System.Text.Encoding.Unicode)
      @current_rev['orders_aggr'] = rec.GetValAsLongByIndex(1)

      fields = @aggr_stream.TableSet.FieldList[table_name] #"orders_aggr"]
      log.puts fields.split(',').map { |f| "#{f}=#{rec.GetValAsString(f)}" }.join "; "

      @aggr_file.puts "replRev=#{@current_rev['orders_aggr']}"
      @aggr_file.flush
    end

    def save_deal_data(rec, table_name)
      @deal_file ||= File.new(DEAL_PATH, "w") # System.Text.Encoding.Unicode)
      @current_rev['deal'] = rec.GetValAsLongByIndex(1)

      fields = @deal_stream.TableSet.FieldList[table_name] #"deal"]
      @deal_file.puts fields.split(',').map { |f| "#{f}=#{rec.GetValAsString(f)}" }.join "\n"
      @deal_file.puts ''

      @deal_file.flush
    end

    def save_data(rec, table_name, file, stream, divider = '; ', finalizer = nil)
      @current_rev[table_name] = rec.GetValAsLongByIndex(1)

      fields = stream.TableSet.FieldList[table_name] #"deal"]
      file.puts fields.split(',').map { |f| "#{f}=#{rec.GetValAsString(f)}" }.join divider
      file.puts(finalizer) if finalizer

      file.flush
    end
  end
end

# The main entry point for the application.
router = start_router

begin
  client = P2BaselessClient::Client.new
  client.Run
rescue Exception => e
  puts "Caught in main loop: #{e.class}"
  raise e
ensure
  router.exit
end
