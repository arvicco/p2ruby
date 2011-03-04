module P2

  # Represents P2 replication Data Stream.
  # Основной интерфейс объекта используемый для организации получения репликационных данных.
  #
  class DataStream < Base
    CLSID = '{914893CB-0864-4FBB-856A-92C3A1D970F8}'
    PROGID = 'P2ClientGate.P2DataStream.1'

    def initialize opts = {}
      super opts
    end

    #  Connection and Router status in text format
    #
    def state_text state = self.State
      P2::DS_MESSAGES[state]
    end

    # Tests if replication stream is in error state
    #
    def error?
      self.State == P2::DS_STATE_ERROR
    end

    # Tests if replication stream is closed (or un-opened)
    #
    def closed?
      self.State == P2::DS_STATE_CLOSE
    end

    # Tests if replication stream is opened (please note, it may still be in error state!)
    #
    def opened?
      !closed?
    end

    alias open? opened?

    # Returns Win32OLE event wrapper for IP2DataStreamEvents event interface
    #
    def events(event_interface = 'IP2DataStreamEvents')
      @events ||= WIN32OLE_EVENT.new(@ole, event_interface)
    end

    # Auto-generated OLE methods:

    # property IP2TableSet TableSet
    #  - набор таблиц в схеме репликации. Свойство задается чтением клиентской схемы из
    #    ini-файла (см. описание COM-объекта TableSet) или автоматически при получении
    #    схемы от сервера репликации.
    def TableSet()
      table_set = @ole._getproperty(1, [], [])
      P2::TableSet.new :ole => table_set if table_set
    end

    # property BSTR StreamName — имя потока репликации.
    def StreamName()
      @ole._getproperty(2, [], [])
    end

    alias Name StreamName
    alias name StreamName

    # property BSTR DBConnString
    # — строка соединения с БД. Перечень параметров для соединения с БД зависит от того,
    #   какой драйвер используется для установки соединения: P2DBSQLite.dll или P2DBODBC.dll.
    #   Задание в данном параметре пустой строки позволяет реализовывать вариант
    #   безбазового клиента репликации. Такой клиент в БД ничего не пишет, а лишь
    #   получает данные от сервера репликации. В безбазовом клиенте нотификация
    #   IP2DataStreamEvents::StreamDataUpdated не вызывается.
    #
    #  Примеры строк:
    #  'P2DBSQLite.dll;dbTest.ini;С:\dbTest'
    #  'P2DBODBC.dll;crypto.ini;DRIVER={SQLServer};SERVER=TEST1;DATABASE=crypto;UID=autotest; PWD=autotest'
    #
    def DBConnString()
      @ole._getproperty(3, [], [])
    end

    # TRequestType type: property Type
    # — тип потока репликации. Тип потока определяет источник и способ получения данных
    #   (снэпшот/онлайн), а также метод хранения удаленных на сервере записей в локальной
    #   БД клиента.
    #
    def Type()
      @ole._getproperty(4, [], [])
    end

    # property TDataStreamState State — состояние потока репликации.
    def State()
      @ole._getproperty(5, [], [])
    end

    # property VOID TableSet - набор таблиц в схеме репликации
    def TableSet=(val)
      table = val.respond_to?(:ole) ? val.ole : val
      @ole._setproperty(1, [table], [VT_BYREF|VT_DISPATCH])
    end

    # property VOID StreamName — имя потока репликации.
    def StreamName=(val)
      @ole._setproperty(2, [val], [VT_BSTR])
    end

    alias Name= StreamName=
    alias name= StreamName=

    # property VOID DBConnString — строка соединения с БД. See DBConnString().
    def DBConnString=(val)
      @ole._setproperty(3, [val], [VT_BSTR])
    end

    # VOID type: property Type — тип потока репликации
    # ???????? Changed signature from Dispatch to Int manually, possible problems?
    # ???????? Also changed name from type to Type, reserved in OLE?
    #
    def Type=(val)
      @ole._setproperty(4, [val], [VT_I4]) #VT_DISPATCH])
    end

    # method VOID Open
    # Открытие потока репликационных данных.
    #   IP2Connection conn [IN] — указатель на интерфейс соединения.
    def Open(conn)
      conn = conn.respond_to?(:ole) ? conn.ole : conn
      @ole._invoke(6, [conn], [VT_BYREF|VT_DISPATCH])
    end

    # method VOID Close - закрытие потока репликационных данных.
    def Close()
      @ole._invoke(7, [], [])
    end

    # HRESULT GetScheme
    #   OLE_HANDLE p_val [OUT]
    def GetScheme(p_val)
      keep_lastargs @ole._invoke(1610678272, [p_val], [VT_BYREF|VT_BYREF|VT_DISPATCH])
    end

    # HRESULT LinkDataBuffer
    #   IP2DataStreamEvents data_buff [IN]
    def LinkDataBuffer(data_buff)
      @ole._invoke(1610678273, [data_buff], [VT_BYREF|VT_DISPATCH])
    end

    # method VOID StreamStateChanged - EVENT in IP2DataStreamEvents
    #   IP2DataStream stream [IN]
    #   TDataStreamState new_state [IN]
    def StreamStateChanged(stream, new_state)
      @ole._invoke(1, [stream, new_state], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
    end

    # method VOID StreamDataInserted - EVENT in IP2DataStreamEvents
    #   IP2DataStream stream [IN]
    #   BSTR table_name [IN]
    #   IP2Record rec [IN]
    def StreamDataInserted(stream, table_name, rec)
      @ole._invoke(2, [stream, table_name, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_BYREF|VT_DISPATCH])
    end

    # method VOID StreamDataUpdated - EVENT in IP2DataStreamEvents
    #   IP2DataStream stream [IN]
    #   BSTR table_name [IN]
    #   I8 id [IN]
    #   IP2Record rec [IN]
    def StreamDataUpdated(stream, table_name, id, rec)
      @ole._invoke(3, [stream, table_name, id, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
    end

    # method VOID StreamDataDeleted - EVENT in IP2DataStreamEvents
    #   IP2DataStream stream [IN]
    #   BSTR table_name [IN]
    #   I8 id [IN]
    #   IP2Record rec [IN]
    def StreamDataDeleted(stream, table_name, id, rec)
      @ole._invoke(4, [stream, table_name, id, rec], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8, VT_BYREF|VT_DISPATCH])
    end

    # method VOID StreamDatumDeleted - EVENT in IP2DataStreamEvents
    #   IP2DataStream stream [IN]
    #   BSTR table_name [IN]
    #   I8 rev [IN]
    def StreamDatumDeleted(stream, table_name, rev)
      @ole._invoke(5, [stream, table_name, rev], [VT_BYREF|VT_DISPATCH, VT_BSTR, VT_I8])
    end

    # method VOID StreamDBWillBeDeleted - EVENT in IP2DataStreamEvents
    #   IP2DataStream stream [IN]
    def StreamDBWillBeDeleted(stream)
      @ole._invoke(6, [stream], [VT_BYREF|VT_DISPATCH])
    end

    # method VOID StreamLifeNumChanged - EVENT in IP2DataStreamEvents
    #   IP2DataStream stream [IN]
    #   I4 life_num [IN]
    def StreamLifeNumChanged(stream, life_num)
      @ole._invoke(7, [stream, life_num], [VT_BYREF|VT_DISPATCH, VT_I4])
    end

    # method VOID StreamDataBegin - EVENT in IP2DataStreamEvents
    #   IP2DataStream stream [IN]
    def StreamDataBegin(stream)
      @ole._invoke(8, [stream], [VT_BYREF|VT_DISPATCH])
    end

    # method VOID StreamDataEnd - EVENT in IP2DataStreamEvents
    #   IP2DataStream stream [IN]
    def StreamDataEnd(stream)
      @ole._invoke(9, [stream], [VT_BYREF|VT_DISPATCH])
    end
  end
end # module P2


