module P2Ruby
  # Represents P2 Message
  # Объект предназначен для создания сообщений. При этом он позволяет при создании сообщений
  # оперировать не только схемой сообщений по умолчанию (заданной в P2ClientGate.ini),
  # а реализовывать набор классов сообщений, создаваемых по различным схемам.
  # Если требуется использовать другие схемы сообщений, следует при инициализации объекта
  # указать пользовательский ini-файл, содержащий такие схемы.
  #
  class Message < P2Class
    CLSID = '{A9A6C936-5A12-4518-9A92-90D75B41AF18}'
    PROGID = 'P2ClientGate.P2BLMessage.1'

    def initialize opts = {}
      # First we need to obtain Application instance... Yes, it IS freaking weird.
      error "Connection/Application should be created first" unless P2Ruby::Application.instance

      super "P2BLMessage", opts
    end

    # Auto-generated OLE methods:

    # property BSTR Name
    def Name()
      @ole._getproperty(1, [], [])
    end

    # property UI4 Id
    def Id()
      @ole._getproperty(2, [], [])
    end

    # property BSTR Version
    def Version()
      @ole._getproperty(3, [], [])
    end

    # property BSTR DestAddr
    def DestAddr()
      @ole._getproperty(4, [], [])
    end

    # property VOID DestAddr
    def DestAddr=(val)
      @ole._setproperty(4, [val], [VT_BSTR])
    end

    # property VARIANT Field
    #   BSTR name [IN]
    def Field
      @_Field ||= OLEProperty.new(@ole, 5, [VT_BSTR], [VT_BSTR, VT_VARIANT])
    end

    # I8 FieldAsLONGLONG: property FieldAsULONGLONG
    #   BSTR name [IN]
    def FieldAsLONGLONG
      @_FieldAsLONGLONG ||= OLEProperty.new(@ole, 10, [VT_BSTR], [VT_BSTR, VT_I8])
    end

    # method IP2BLMessage Send
    #   IP2Connection conn [IN]
    #   UI4 timeout [IN]
    def Send(conn, timeout)
      @ole._invoke(6, [conn, timeout], [VT_BYREF|VT_DISPATCH, VT_UI4])
    end

    # method VOID Post
    #   IP2Connection conn [IN]
    def Post(conn)
      @ole._invoke(7, [conn], [VT_BYREF|VT_DISPATCH])
    end

    # method VOID SendAsync
    #   IP2Connection conn [IN]
    #   UI4 timeout [IN]
    #   DISPATCH event [IN]
    def SendAsync(conn, timeout, event)
      @ole._invoke(8, [conn, timeout, event], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH])
    end

    # method VOID SendAsync2
    #   IP2Connection conn [IN]
    #   UI4 timeout [IN]
    #   DISPATCH event [IN]
    #   I8 event_param [IN]
    def SendAsync2(conn, timeout, event, event_param)
      @ole._invoke(9, [conn, timeout, event, event_param], [VT_BYREF|VT_DISPATCH, VT_UI4, VT_DISPATCH, VT_I8])
    end
  end
end # module P2Ruby

