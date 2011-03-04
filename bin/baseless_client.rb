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
      return unless closed? || error?
      self.Close() if error?
      revisions.each { |table, rev| self.TableSet.Rev[table.to_s] = rev } if self.TableSet
      self.Open(conn)
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

      # Tracking stream table revisions
      @aggr_rev = 0
      @deal_rev = 0
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

    def Start(args)
      begin

        # Объект "соединение" и параметры соединения с приложением P2MQRouter
        @conn = P2::Connection.new :ini => CLIENT_INI,
                                   :host => "localhost",
                                   :port => 4001,
                                   :AppName => "p2ruby_baseless"

        if File.exists? AGGR_PATH
          File.open(AGGR_PATH) do |file|
            @aggr_rev = file.readlines.last.chomp.to_i
          end
        end

        if File.exists? DEAL_PATH
          File.open(DEAL_PATH) do |file|
            line = file.readlines.select { |l| l =~ /^replRev/ }.last
            rev = line.split('=')[1] if line
            @deal_rev = rev.chomp.to_i if rev
          end
        end

        # создаем объект "входящий поток репликации" для потока агрегированых заявок
        @aggr_stream = P2::DataStream.new :DBConnString => "",
                                          :type => P2::RT_COMBINED_DYNAMIC,
                                          :name => AGGR_ID
        #noinspection RubyArgCount
        @aggr_stream.TableSet = P2::TableSet.new
#        #       @aggr_stream.TableSet.InitFromIni2("orders_aggr.ini", "CustReplScheme")
        @aggr_stream.TableSet.InitFromIni(AGGR_INI, "")
        @aggr_stream.TableSet.Rev["orders_aggr"] = @aggr_rev + 1

        # создаем объект "входящий поток репликации" для потока агрегированых заявок
        @deal_stream = P2::DataStream.new :DBConnString => "",
                                          :type => P2::RT_COMBINED_DYNAMIC,
                                          :name => DEAL_ID
#        @deal_stream.TableSet = P2::TableSet.new
#        @aggr_stream.TableSet.InitFromIni(DEAL_INI, "")
#        #        @deal_stream.TableSet.InitFromIni2("forts_scheme.ini", "FutTrade")
#        @deal_stream.TableSet.Rev["deal"] = @deal_rev + 1

        # Creating Stats objects for collecting event statistics
        @stats = {AGGR_ID => Stats.new(self),
                  DEAL_ID => Stats.new(self)}
        # Register event handlers for Connecyion and Data Stream events
        @conn.events.handler = self
        @aggr_stream.events.handler = @stats[AGGR_ID] # self
        @deal_stream.events.handler = @stats[DEAL_ID] # self
      rescue WIN32OLERuntimeError => e
        p2_error = P2.p2_error e #Marshal.GetHRForException(e)
        log.puts e
        if p2_error == P2::P2ERR_INI_PATH_NOT_FOUND
          log.puts "Can't find one or both of ini file: P2ClientGate.ini, orders_aggr.ini"
        end
        return p2_error
      rescue Exception => e #(System.Exception e)
        log.puts "Raising non-Win32Ole error in Start:", e
        raise e
      end
      return (0)
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
                @aggr_stream.keep_alive @conn, :orders_aggr => @aggr_rev + 1
                @deal_stream.keep_alive @conn, :deal => @deal_rev + 1
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
      try do
        log.puts "Stream #{stream.StreamName} inserts into #{table_name} "

        if stream.StreamName == AGGR_ID
          # Пришел поток FORTS_FUTAGGR20_REPL
          save_aggr_rev(rec)

        elsif stream.StreamName == DEAL_ID
          # Пришел поток FORTS_FUTTRADE_REPL
          save_deal_data(rec, table_name)
        end
      end
    end

    # Delete record
    def onStreamDataDeleted(stream, table_name, id, rec)
      save_aggr_rev(rec)
      log.puts "Stream #{stream.StreamName} deletes #{id} from #{table_name} "
    end

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

    def save_aggr_rev(rec)
      @aggr_file ||= File.new(AGGR_PATH, "w") # System.Text.Encoding.Unicode)
      @aggr_rev = rec.GetValAsLongByIndex(1)

      (0...rec.Count).each { |i| log.print(rec.GetValAsStringByIndex(i) + "; ") }
      log.puts ''

      @aggr_file.puts @aggr_rev.to_s
      @aggr_file.flush
    end

    def save_deal_data(rec, table_name)
      # Interrupt inside this method bubbles up instead of being caught... Why?
      @deal_file ||= File.new(DEAL_PATH, "w") # System.Text.Encoding.Unicode)
      @deal_rev = rec.GetValAsLongByIndex(1)

      fields = @deal_stream.TableSet.FieldList[table_name] #"deal"]
      fields.split(',').each do |field|
        @deal_file.puts(field + " = " + rec.GetValAsString(field))
      end

      @deal_file.puts ''
      @deal_file.flush
    end
  end
end

#/ The main entry point for the application.
router = start_router

begin
  client = P2BaselessClient::Client.new
  exit 1 unless client.Start(ARGV) == 0
  client.Run
rescue Exception => e
  puts "Caught in main loop: #{e.class}"
  raise e
ensure
  router.exit
end
