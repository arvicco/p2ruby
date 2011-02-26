#using System
#using System.IO
#using System.Text
#using System.Runtime.InteropServices
#using P2ClientGate
#using System.Threading

require_relative 'script_helper'

module P2BaselessClient #P2SimpleGate2Client
  #/ The main entry point for the application.
  class Class1
    def Main
      # TODO: Add code to start application here
      cl = Client.new
      return unless cl.Start(ARGV) == 0
      cl.Run
    end
  end
  class Client

    def initialize
      @stop = false

#      @destAddr = ""
      @saveRev = "SaveRev.txt"
      @saveDeal = "SaveDeal.txt"
      @curr_rev = 0
      @curr_rev_deal = 0

      # Идентификаторы потоков
      @aggregatesID = "FORTS_FUTAGGR20_REPL"
      @tradesID = "FORTS_FUTTRADE_REPL"
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
                                         :name => @aggregatesID
#        @aggregates.TableSet = new CP2TableSetClass()
#        ## @aggregates.TableSet.InitFromIni2("orders_aggr.ini", "CustReplScheme")
#        @aggregates.TableSet.InitFromIni("orders_aggr.ini", "")
#        @aggregates.TableSet.set_rev("orders_aggr", @curr_rev + 1)

        # создаем объект "входящий поток репликации" для потока агрегированых заявок
        @trades = P2::DataStream.new :DBConnString => "",
                                     :type => P2::RT_COMBINED_DYNAMIC,
                                     :name => @tradesID
#        @trades.TableSet = new CP2TableSetClass()
#        @trades.TableSet.InitFromIni2("forts_scheme.ini", "FutTrade")
#        @trades.TableSet.set_rev("deal", @curr_rev_deal + 1)

        # регистрируем интерфейсы обратного вызова для получения данных
        @aggregates.events.handler = self
        @trades.events.handler = self
      rescue => e
        hRes = Marshal.GetHRForException(e)
        Console.WriteLine("Exception #{e.Message}")
        LogWriteLine("Exception #{e.Message}")
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
                if (@aggregates.State == P2::DS_STATE_ERROR || @aggregates.State == P2::DS_STATE_CLOSE)
                  @aggregates.Close() if (@aggregates.State == P2::DS_STATE_ERROR)
                  # открываем поток репликации
                  @aggregates.TableSet.set_rev("orders_aggr", @curr_rev + 1)
                  @aggregates.Open(@conn)
                end

                if (@trades.State == P2::DS_STATE_ERROR || @trades.State == P2::DS_STATE_CLOSE)
                  @trades.Close() if (@trades.State == P2::DS_STATE_ERROR)
                  # открываем поток репликации
                  @trades.TableSet.set_rev("deal", @curr_rev_deal + 1)
                  @trades.Open(@conn)
                end
              rescue (System.Runtime.InteropServices.COMException e)
                LogWriteLine("Exception {0} {1:X}", e.Message, e.ErrorCode)
              end
              # обрабатываем пришедшее сообщение. 
              # Обработка идет в интерфейсах обратного вызова
              @conn.ProcessMessage2(100)
            end
          rescue (System.Runtime.InteropServices.COMException e)
            LogWriteLine("Exception {0} {1:X}", e.Message, e.ErrorCode)
          end

          if (@aggregates.State != P2::DS_STATE_CLOSE)
            begin
              @aggregates.Close()
            rescue (System.Runtime.InteropServices.COMException e)
              LogWriteLine("Exception {0} {1:X}", e.Message, e.ErrorCode)
            end
          end

          if (@trades.State != P2::DS_STATE_CLOSE)
            begin
              @trades.Close()
            rescue (System.Runtime.InteropServices.COMException e)
              LogWriteLine("Exception {0} {1:X}", e.Message, e.ErrorCode)
            end
          end

          @conn.Disconnect()
        rescue (System.Runtime.InteropServices.COMException e)
          LogWriteLine("Exception {0} {1:X}", e.Message, e.ErrorCode)
        rescue (System.Exception e)
          LogWriteLine("System Exception {0} {1}", e.Message, e.Source)
        end
      end
    end

    # Обработка состояния соединения
    def onConnectionStatusChanged(conn, newStatus)
      state = "MQ connection state " + @conn.status_text(newStatus)

      if ((newStatus & P2::CS_ROUTER_CONNECTED) != 0)
        # Когда соединились - запрашиваем адрес сервера-обработчика
      end
      LogWriteLine(state)
    end

    # Обработка состояния потока репликации
    def onStreamStateChanged(stream, newState)
      state = "Stream " + stream.StreamName + " state: " + @trades.state_text(newState)
      case newState
        when P2::DS_STATE_CLOSE, P2::DS_STATE_ERROR
          # @opened = false
      end
      LogWriteLine(state)
    end

    # вставка записи
    def onStreamDataInserted(stream, tableName, rec)
      begin
        LogWriteLine("Insert " + tableName)

        # Пришел поток FORTS_FUTAGGR20_REPL
        if (stream.StreamName == @aggregatesID)
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
        if (stream.StreamName == @tradesID)
          @curr_rev_deal = rec.GetValAsLongByIndex(1)
          fields = @trades.TableSet.FieldList["deal"]
          fields.split(',').each do |field|
            begin
              SaveDeal(fields, rec.GetValAsString(field))
            rescue (System.Exception e)
            end
          end
          @saveDealFile.WriteLine("")
          @saveDealFile.Flush()
        end

      rescue (System.Exception e)
        LogWriteLine("!!!" + e.Message + "!!!" + e.Source)
      end
    end

    # удаление записи
    def StreamDataDeleted(stream, tableName, id, rec)
      SaveRev(rec.GetValAsVariantByIndex(1))
      LogWriteLine("Delete " + tableName + " " + id)
    end

    def onStreamLifeNumChanged(stream, lifeNum)
      if (stream.StreamName == "FORTS_FUTAGGR20_REPL")
        @aggregates.TableSet.LifeNum = lifeNum
        @aggregates.TableSet.SetLifeNumToIni("orders_aggr.ini")
      end
      if (stream.StreamName == "FORTS_FUTTRADE_REPL")
        @trades.TableSet.LifeNum = lifeNum
        @trades.TableSet.SetLifeNumToIni("forts_scheme.ini")
      end
    end

    def LogWriteLine(s, *args)
      if (@logFile == null)
        @logFile = new StreamWriter("P2SimpleGate2Client.log", false, System.Text.Encoding.Unicode)
      end
      @logFile.WriteLine(s, args)
      @logFile.Flush()
    end

    def LogWrite(s, *args)
      if (@logFile == null)
        @logFile = new StreamWriter("P2SimpleGate2Client.log", false, System.Text.Encoding.Unicode)
      end
      @logFile.Write(s, args)
      @logFile.Flush()
    end

    def SaveRev(rev)
      if (@saveRevFile == nil)
        @saveRevFile = new StreamWriter(@saveRev, false, System.Text.Encoding.Unicode)
      end
      @saveRevFile.WriteLine(rev.ToString())
      @saveRevFile.Flush()
    end

    def SaveDeal(field, value)
      if (@saveDealFile == nil)
        @saveDealFile = new StreamWriter(@saveDeal, false, System.Text.Encoding.Unicode)
      end
      @saveDealFile.WriteLine(field + " = " + value)
      @saveDealFile.Flush()
    end

  end
end
