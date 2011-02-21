module P2Ruby
  # Represents P2 client application
  #  ќсновной объект библиотеки P2ClientGate, предназначенный дл€ ее инициализации.
  #  ќн позвол€ет задавать параметры инициализации, отличные от параметров по умолчанию
  #  (пользовательский ini-файл), а также устанавливать тип парсера, используемого при
  #  отправке-приеме данных. “ип парсера Ч Plaza или Plaza-II (сообщени€ дл€ различных
  #  платформ отличаютс€ форматом пол€ Body).
  #  ¬ пользовательском ini-файле можно задать путь к файлу журнала работы подсистемы
  #  Plaza-II в вашем приложении, а также путь к Ђtrace-файлуї Ч файлу в котором указываетс€,
  #  какие сообщени€ писать в журнал работы, а какие Ц нет. Ќастраиваемые параметры подробно
  #  прокомментированы в примере пользовательского ini-файла, включенного в дистрибутив шлюза.
  #  ƒл€ того, чтобы задать параметры инициализации, отличные от параметров по умолчанию
  #  следует €вно создать объект Application и в вызове метода StartUp указать им€
  #  пользовательского ini-файла и путь к нему. “ип парсера задаетс€ как свойство объекта
  #  и измен€етс€ с помощью стандартных методов get и put.
  #  ƒелать это необходимо до начала работы с другими объектами библиотеки.
  #
  class Application < P2Class
    CLSID = '{08A95064-05C2-4EF4-8B5D-D6211C2C9880}'
    PROGID = 'P2ClientGate.P2Application.1'

    attr_accessor :ini

    # Application should not be used directly in client code, Connection.new
    # tries to obtain/create Application instance implicitly.
    #
    def initialize ini
      @ini = Pathname(ini || "./P2ClientGate.ini").expand_path
      error "Wrong ini file #{@ini}" unless @ini.exist?

      super "P2Application", :ini => @ini

      # Application is created before any other P2 object,
      # need to load P2 constants (same for all P2 classes)
      WIN32OLE.const_load(@ole, P2ClientGate) unless defined? P2ClientGate::CONSTANTS

      @ole.StartUp @ini.to_s
    end

    # Application is a Resettable Singleton:
    # Normally, you use Application.instance to create/obtain its instance;
    # However, when Application.reset is called, this resets the instance.
    #
    def self.reset ini = nil
      @instance = new ini
    end

    # Returns Application instance unless explicitly given different ini file
    #
    def self.instance ini = nil
      if @instance && ini && @instance.ini != Pathname(ini).expand_path
        error "Attempt to obtain #{@instance} for different ini: #{ini}"
      end
      @instance ||= new ini
    end

    # Auto-generated OLE methods:

    # property UI4 ParserType
    #  Get Parser type: Х	1 Ч Plaza; Х	2 Ч Plaza-II (default)
    def ParserType()
      @ole._getproperty(3, [], [])
    end

    # property VOID ParserType
    #  Set Parser type: Х	1 Ч Plaza; Х	2 Ч Plaza-II (default)
    def ParserType=(val)
      @ole._setproperty(3, [val], [VT_UI4])
    end

    # method VOID StartUp
    # »нициализаци€ библиотеки P2ClientGate с параметрами, заданными в пользовательском ini-файле.
    #   BSTR ini_file_name [IN]
    def StartUp(ini_file_name)
      @ole._invoke(1, [ini_file_name], [VT_BSTR])
    end

    # method VOID CleanUp
    # ƒеинициализаци€ библиотеки P2ClientGate.
    def CleanUp()
      @ole._invoke(2, [], [])
    end

    # method IP2Connection CreateP2Connection
    def CreateP2Connection()
      @ole._invoke(4, [], [])
    end

    # method IP2BLMessage CreateP2BLMessage
    def CreateP2BLMessage()
      @ole._invoke(5, [], [])
    end

    # method IP2BLMessageFactory CreateP2BLMessageFactory
    def CreateP2BLMessageFactory()
      @ole._invoke(6, [], [])
    end

    # method IP2DataBuffer CreateP2DataBuffer
    def CreateP2DataBuffer()
      @ole._invoke(7, [], [])
    end

    # method IP2DataStream CreateP2DataStream
    def CreateP2DataStream()
      @ole._invoke(8, [], [])
    end

    # method IP2TableSet CreateP2TableSet
    def CreateP2TableSet()
      @ole._invoke(9, [], [])
    end

  end
end # module P2Ruby


