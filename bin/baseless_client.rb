require_relative 'script_helper'

module P2BaselessClient #P2SimpleGate2Client
  class Client

    def initialize
      @stop = false
      # @destAddr = ""

      # Tracking files
      @log = 'log\baseless_client.log'
      @saveRev = 'log\SaveRev.txt'
      @saveDeal = 'log\SaveDeal.txt'
      @curr_rev = 0
      @curr_rev_deal = 0

      # Replication Streams
      @aggregates_ini = 'spec\files\orders_aggr.ini'
      @trades_ini = 'spec\files\fut_trades.ini'
      @aggregates_id = 'FORTS_FUTAGGR20_REPL'
      @trades_id = 'FORTS_FUTTRADE_REPL'
    end

    # Exception handling wrapper for better readability
    def try
      begin
        yield
      rescue => e #(System.Runtime.InteropServices.COMException e)
        LogWriteLine(e)
      rescue => e #(System.Exception e)
        LogWriteLine(e)
      end
    end

    def Start(args)
      begin

        # ������ "����������" � ��������� ���������� � ����������� P2MQRouter
        @conn = P2::Connection.new :ini => CLIENT_INI,
                                   :host => "localhost",
                                   :port => 4001,
                                   :AppName => "p2ruby_baseless"

        @conn.events.handler = self

        if File.exists? @saveRev
          File.open(@saveRev) do |file|
            p @curr_rev = file.readlines.last.chomp.to_i
          end
        end

        if File.exists? @saveDeal
          File.open(@saveDeal) do |file|
            line = file.readlines.select { |l| l =~ /^replRev/ }.last
            p @curr_rev_deal = line.split('=')[1].chomp.to_i
          end
        end

        # ������� ������ "�������� ����� ����������" ��� ������ ������������� ������
        @aggregates = P2::DataStream.new :DBConnString => "",
                                         :type => P2::RT_COMBINED_DYNAMIC,
                                         :name => @aggregates_id
#        @aggregates.TableSet = P2::TableSet.new
#        #       @aggregates.TableSet.InitFromIni2("orders_aggr.ini", "CustReplScheme")
#        @aggregates.TableSet.InitFromIni(@aggregates_ini, "")
#        @aggregates.TableSet.Rev["orders_aggr"] = @curr_rev + 1

        # ������� ������ "�������� ����� ����������" ��� ������ ������������� ������
        @trades = P2::DataStream.new :DBConnString => "",
                                     :type => P2::RT_COMBINED_DYNAMIC,
                                     :name => @trades_id
#        @trades.TableSet = P2::TableSet.new
#        @aggregates.TableSet.InitFromIni(@trades_ini, "")
#        #        @trades.TableSet.InitFromIni2("forts_scheme.ini", "FutTrade")
#        @trades.TableSet.Rev["deal"] = @curr_rev_deal + 1

        # ������������ ���������� ��������� ������ ��� ��������� ������
        @aggregates.events.handler = self
        @trades.events.handler = self
      rescue => e
        raise e
        hRes = Marshal.GetHRForException(e)
        Console.WriteLine("Exception #{e.message}")
        LogWriteLine(e)
        if (hRes == -2147205116) # P2ERR_INI_FILE_NOT_FOUND
          string s = "Can't find one or both of ini file: P2ClientGate.ini, orders_aggr.ini"
          puts s
          LogWriteLine s
        end
        return (hRes)
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
                @aggregates.keep_alive @conn, :orders_aggr => @curr_rev + 1
                @trades.keep_alive @conn, :deal => @curr_rev_deal + 1
              end
              # Actual processing of incoming messages happens in event callbacks
              # O����������� ��������� ��������� � ����������� ��������� ������
              @conn.ProcessMessage2(100)
            end
          end

          try { @aggregates.Close() } if (@aggregates.State != P2::DS_STATE_CLOSE)
          try { @trades.Close() } if (@trades.State != P2::DS_STATE_CLOSE)

          @conn.Disconnect()
        end
      end
    end

    # ��������� ��������� ����������
    def onConnectionStatusChanged(conn, new_status)
      state = "MQ connection state " + @conn.status_text(new_status)

      if ((new_status & P2::CS_ROUTER_CONNECTED) != 0)
        # ����� ����������� - ����������� ����� �������-�����������
      end
      LogWriteLine(state)
    end

    # ��������� ��������� ������ ����������
    def onStreamStateChanged(stream, new_state)
      state = "Stream #{stream.StreamName} state: #{@trades.state_text(new_state)}"
      case new_state
        when P2::DS_STATE_CLOSE, P2::DS_STATE_ERROR
          # @opened = false
      end
      LogWriteLine(state)
    end

    # Insert record
    def onStreamDataInserted(stream, table_name, rec)
      begin
        LogWriteLine "Stream #{stream.StreamName} inserts into #{table_name} "

        # ������ ����� FORTS_FUTAGGR20_REPL
        if (stream.StreamName == @aggregates_id)
          SaveRev(rec.GetValAsVariantByIndex(1))
          @curr_rev = rec.GetValAsLongByIndex(1)
          count = rec.Count
          (0...count).each do |i|
            if (i != count - 1)
              LogWrite(rec.GetValAsStringByIndex(i) + ";")
            else
              LogWriteLine(rec.GetValAsStringByIndex(i))
            end
          end
        end

        # ������ ����� FORTS_FUTTRADE_REPL
        if (stream.StreamName == @trades_id)
          @curr_rev_deal = rec.GetValAsLongByIndex(1)
          fields = @trades.TableSet.FieldList[table_name] #"deal"]
          fields.split(',').each do |field|
            try { SaveDeal(field, rec.GetValAsString(field)) }
          end
          @saveDealFile.puts("")
          @saveDealFile.flush()
        end

      rescue => e #(System.Exception e)
        LogWriteLine(e)
      end
    end

    # Delete record
    def onStreamDataDeleted(stream, table_name, id, rec)
      SaveRev(rec.GetValAsVariantByIndex(1))
      LogWriteLine "Stream #{stream.StreamName} deletes #{id} from #{table_name} "
    end

    def onStreamLifeNumChanged(stream, life_num)
      if (stream.StreamName == @aggregates_id)
        @aggregates.TableSet.LifeNum = life_num
        @aggregates.TableSet.SetLifeNumToIni(@aggregates_ini)
      end
      if (stream.StreamName == @trades_id)
        @trades.TableSet.LifeNum = life_num
        @trades.TableSet.SetLifeNumToIni(@trades_ini)
      end
    end

    def LogWriteLine(*args)
      LogWrite(*args, "\n")
    end

    def LogWrite(*args)
      if (@logFile == nil)
        @logFile = File.new(@log, "w") # System.Text.Encoding.Unicode)
      end
#      @logFile.print(*args)
      print(*args)
      raise args.first if args.first.is_a? Exception
    end

    def SaveRev(rev)
      if (@saveRevFile == nil)
        @saveRevFile = File.new(@saveRev, "w") # System.Text.Encoding.Unicode)
      end
      @saveRevFile.puts(rev.to_s)
    end

    def SaveDeal(field, value)
      if (@saveDealFile == nil)
        @saveDealFile = File.new(@saveDeal, "w") # System.Text.Encoding.Unicode)
      end
      @saveDealFile.puts(field + " = " + value)
    end
  end
end

#/ The main entry point for the application.
start_router do
  client = P2BaselessClient::Client.new
  exit 1 unless client.Start(ARGV) == 0
  client.Run
end
