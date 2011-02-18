module P2Ruby
  # Represents P2 Message Factory
  # Объект предназначен для создания сообщений. При этом он позволяет при создании сообщений
  # оперировать не только схемой сообщений по умолчанию (заданной в P2ClientGate.ini),
  # а реализовывать набор классов сообщений, создаваемых по различным схемам.
  # Если требуется использовать другие схемы сообщений, следует при инициализации объекта
  # указать пользовательский ini-файл, содержащий такие схемы.
  #
  class MessageFactory < P2Class

    def initialize opts = {}
      # First we need to obtain Application instance... Yes, it IS freaking weird.
      error "Connection/Application should be created first" unless P2Ruby::Application.instance

      @ini = Pathname(opts[:ini] || "./p2fortsgate_messages.ini")
      error "Wrong ini file name" unless @ini.expand_path.exist?

      super "P2BLMessageFactory", opts

      @ole.Init @ini.to_s, "Not used"
    end
  end
end # module P2Ruby
