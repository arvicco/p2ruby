module P2Ruby

  # Represents P2 replication Data Stream.
  # Основной интерфейс объекта используемый для организации получения репликационных данных.
  #
  class DataStream < P2Class
    CLSID = '{914893CB-0864-4FBB-856A-92C3A1D970F8}'
    PROGID = 'P2ClientGate.P2DataStream.1'

    def initialize opts = {}
      super opts
    end

    #  DataS tream state in text format
    #
    def state_text
      P2::CS_MESSAGES.map { |k, v| (k & @ole.status).zero? ? nil : v }.compact.join(', ')
    end

#    # Tests if connection to local Router exists
#    #
#    def connected?
#      @ole.status & P2::CS_CONNECTION_CONNECTED != 0
#    end
#
#    # Tests if local Router is authenticated with RTS server
#    #
#    def logged?
#      @ole.status & P2::CS_ROUTER_CONNECTED != 0
#    end

#    # Returns Win32OLE event wrapper for IP2ConnectionEvent event interface
#    #
#    def events(event_interface = 'IP2ConnectionEvent')
#      @events ||= WIN32OLE_EVENT.new(@ole, event_interface)
#    end

    # Auto-generated OLE methods:

    # property IP2TableSet TableSet
    def TableSet()
      @ole._getproperty(1, [], [])
    end

    # property BSTR StreamName
    def StreamName()
      @ole._getproperty(2, [], [])
    end

    # property BSTR DBConnString
    def DBConnString()
      @ole._getproperty(3, [], [])
    end

    # TRequestType type: property Type
    def Type()
      @ole._getproperty(4, [], [])
    end

    # property TDataStreamState State
    def State()
      @ole._getproperty(5, [], [])
    end

    # property VOID TableSet
    def TableSet=(val)
      @ole._setproperty(1, [val], [VT_BYREF|VT_DISPATCH])
    end

    # property VOID StreamName
    def StreamName=(val)
      @ole._setproperty(2, [val], [VT_BSTR])
    end

    # property VOID DBConnString
    def DBConnString=(val)
      @ole._setproperty(3, [val], [VT_BSTR])
    end

    # VOID type: property Type
    # ???????? Changed signature from Dispatch to Int manually, possible problems?
    # ???????? Also changed name from type to Type, reserved in OLE?
    def Type=(val)
      @ole._setproperty(4, [val], [VT_I4]) #][VT_DISPATCH])
    end

    # method VOID Open
    #   IP2Connection conn [IN]
    def Open(conn)
      @ole._invoke(6, [conn], [VT_BYREF|VT_DISPATCH])
    end

    # method VOID Close
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
end # module P2Ruby


