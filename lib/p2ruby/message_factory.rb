module P2Ruby
  # Represents P2 Message Factory
  # Объект предназначен для создания сообщений. При этом он позволяет при создании сообщений
  # оперировать не только схемой сообщений по умолчанию (заданной в P2ClientGate.ini),
  # а реализовывать набор классов сообщений, создаваемых по различным схемам.
  # Если требуется использовать другие схемы сообщений, следует при инициализации объекта
  # указать пользовательский ini-файл, содержащий такие схемы.
  #
  class MessageFactory < P2Class
    CLSID = '{501786DA-CA02-45C1-B815-1C58C383265D}'
    PROGID = 'P2ClientGate.P2BLMessageFactory.1'

    def initialize opts = {}
      # First we need to obtain Application instance... Yes, it IS freaking weird.
      error "Connection/Application should be created first" unless P2Ruby::Application.instance

      @ini = Pathname(opts[:ini] || "./p2fortsgate_messages.ini")
      error "Wrong ini file name" unless @ini.expand_path.exist?

      super "P2BLMessageFactory", opts

      @ole.Init @ini.to_s, "Not used"
    end

    def message opts
      P2Ruby::Message.new opts.merge(:ole => CreateMessageByName(opts[:name]))
    end

    # Auto-generated OLE methods:

    # method VOID Init
    #   BSTR struct_file [IN]
    #   BSTR sign_file [IN]
    def Init(struct_file, sign_file)
      @ole._invoke(1, [struct_file, sign_file], [VT_BSTR, VT_BSTR])
    end

    # method IP2BLMessage CreateMessageByName
    #   BSTR msg_name [IN]
    def CreateMessageByName(msg_name)
      @ole._invoke(2, [msg_name], [VT_BSTR])
    end

    # method IP2BLMessage CreateMessageById
    #   UI4 msg_id [IN]
    def CreateMessageById(msg_id)
      @ole._invoke(3, [msg_id], [VT_UI4])
    end

  end
end # module P2Ruby
