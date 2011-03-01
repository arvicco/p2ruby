#using System
#using System.IO
#using System.Text
#using System.Runtime.InteropServices
#using P2ClientGate
#using System.Threading

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

    def Start(args)
      begin

        # Объект "соединение" и параметры соединения с приложением P2MQRouter
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

        # создаем объект "входящий поток репликации" для потока агрегированых заявок
        @aggregates = P2::DataStream.new :DBConnString => "",
                                         :type => P2::RT_COMBINED_DYNAMIC,
                                         :name => @aggregates_id
#        @aggregates.TableSet = P2::TableSet.new
#        #       @aggregates.TableSet.InitFromIni2("orders_aggr.ini", "CustReplScheme")
#        @aggregates.TableSet.InitFromIni(@aggregates_ini, "")
#        @aggregates.TableSet.Rev["orders_aggr"] = @curr_rev + 1

        # создаем объект "входящий поток репликации" для потока агрегированых заявок
        @trades = P2::DataStream.new :DBConnString => "",
                                     :type => P2::RT_COMBINED_DYNAMIC,
                                     :name => @trades_id
#        @trades.TableSet = P2::TableSet.new
#        @aggregates.TableSet.InitFromIni(@trades_ini, "")
#        #        @trades.TableSet.InitFromIni2("forts_scheme.ini", "FutTrade")
#        @trades.TableSet.Rev["deal"] = @curr_rev_deal + 1

        # регистрируем интерфейсы обратного вызова для получения данных
        @aggregates.events.handler = self
        @trades.events.handler = self
      rescue => e
        raise e
        hRes = Marshal.GetHRForException(e)
        Console.WriteLine("Exception #{e.message}")
        LogWriteLine(e)
        if (hRes == -2147205116) # P2ERR_INI_FILE_NOT_FOUND
          string s = "Can't find one or both of ini file: P2ClientGate.ini, orders_aggr.ini"
          Console.WriteLine("#{s}")
          LogWriteLine("#{s}")
        end
        return (hRes)
      end
      return (0)
    end

    # ГЛАВНЫЙ ЦИКЛ
    def Run()
      while (!@stop)
        begin
          # создаем соединение с роутером
          @conn.Connect()
          begin
            while (!@stop)
              begin
                if @aggregates.State == P2::DS_STATE_ERROR ||
                    @aggregates.State == P2::DS_STATE_CLOSE

                  @aggregates.Close() if (@aggregates.State == P2::DS_STATE_ERROR)
                  # открываем поток репликации
#                  @aggregates.TableSet.Rev["orders_aggr"] = @curr_rev + 1
                  @aggregates.Open(@conn)
                end

                if @trades.State == P2::DS_STATE_ERROR ||
                    @trades.State == P2::DS_STATE_CLOSE

                  @trades.Close() if (@trades.State == P2::DS_STATE_ERROR)
                  # открываем поток репликации
#                  @trades.TableSet.Rev["deal"] = @curr_rev_deal + 1
                  @trades.Open(@conn)
                end
              rescue => e #(System.Runtime.InteropServices.COMException e)
                LogWriteLine(e)
              end
              # обрабатываем пришедшее сообщение. 
              # Обработка идет в интерфейсах обратного вызова
              @conn.ProcessMessage2(100)
            end
          rescue => e #(System.Runtime.InteropServices.COMException e)
            LogWriteLine(e)
          end

          if (@aggregates.State != P2::DS_STATE_CLOSE)
            begin
              @aggregates.Close()
            rescue => e #(System.Runtime.InteropServices.COMException e)
              LogWriteLine(e)
            end
          end

          if (@trades.State != P2::DS_STATE_CLOSE)
            begin
              @trades.Close()
            rescue => e #(System.Runtime.InteropServices.COMException e)
              LogWriteLine(e)
            end
          end

          @conn.Disconnect()
        rescue => e #(System.Runtime.InteropServices.COMException e)
          LogWriteLine(e)
        rescue => e #(System.Exception e)
          LogWriteLine(e)
        end
      end
    end

    # Обработка состояния соединения
    def onConnectionStatusChanged(conn, new_status)
      state = "MQ connection state " + @conn.status_text(new_status)

      if ((new_status & P2::CS_ROUTER_CONNECTED) != 0)
        # Когда соединились - запрашиваем адрес сервера-обработчика
      end
      LogWriteLine(state)
    end

    # Обработка состояния потока репликации
    def onStreamStateChanged(stream, new_state)
      state = "Stream " + stream.StreamName + " state: " + @trades.state_text(new_state)
      case new_state
        when P2::DS_STATE_CLOSE, P2::DS_STATE_ERROR
          # @opened = false
      end
      LogWriteLine(state)
    end

    # вставка записи
    def onStreamDataInserted(stream, table_name, rec)
      begin
        LogWriteLine("Insert " + table_name)

        # Пришел поток FORTS_FUTAGGR20_REPL
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

        # Пришел поток FORTS_FUTTRADE_REPL
        if (stream.StreamName == @trades_id)
          @curr_rev_deal = rec.GetValAsLongByIndex(1)
          fields = @trades.TableSet.FieldList[table_name] #"deal"]
          fields.split(',').each do |field|
            begin
              SaveDeal(field, rec.GetValAsString(field))
            rescue => e # (System.Exception e)
              LogWriteLine(e)
            end
          end
          @saveDealFile.puts("")
          @saveDealFile.flush()
        end

      rescue => e #(System.Exception e)
        LogWriteLine(e)
      end
    end

    # удаление записи
    def StreamDataDeleted(stream, table_name, id, rec)
      SaveRev(rec.GetValAsVariantByIndex(1))
      LogWriteLine("Delete " + table_name + " " + id)
    end

    def onStreamLifeNumChanged(stream, life_num)
      if (stream.StreamName == "FORTS_FUTAGGR20_REPL")
        @aggregates.TableSet.LifeNum = life_num
        @aggregates.TableSet.SetLifeNumToIni(@aggregates_ini)
      end
      if (stream.StreamName == "FORTS_FUTTRADE_REPL")
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
