module P2Ruby
  # Represents P2 client application
  #  Основной объект библиотеки P2ClientGate, предназначенный для ее инициализации.
  #  Он позволяет задавать параметры инициализации, отличные от параметров по умолчанию
  #  (пользовательский ini-файл), а также устанавливать тип парсера, используемого при
  #  отправке-приеме данных. Тип парсера — Plaza или Plaza-II (сообщения для различных
  #  платформ отличаются форматом поля Body).
  #  В пользовательском ini-файле можно задать путь к файлу журнала работы подсистемы
  #  Plaza-II в вашем приложении, а также путь к «trace-файлу» — файлу в котором указывается,
  #  какие сообщения писать в журнал работы, а какие – нет. Настраиваемые параметры подробно
  #  прокомментированы в примере пользовательского ini-файла, включенного в дистрибутив шлюза.
  #  Для того, чтобы задать параметры инициализации, отличные от параметров по умолчанию
  #  следует явно создать объект Application и в вызове метода StartUp указать имя
  #  пользовательского ini-файла и путь к нему. Тип парсера задается как свойство объекта
  #  и изменяется с помощью стандартных методов get и put.
  #  Делать это необходимо до начала работы с другими объектами библиотеки.
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
    def ParserType()
      @ole._getproperty(3, [], [])
    end

    # property VOID ParserType
    def ParserType=(val)
      @ole._setproperty(3, [val], [VT_UI4])
    end

    # method VOID StartUp
    #   BSTR ini_file_name [IN]
    def StartUp(ini_file_name)
      @ole._invoke(1, [ini_file_name], [VT_BSTR])
    end

    # method VOID CleanUp
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


