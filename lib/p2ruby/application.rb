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
      WIN32OLE.const_load(@ole, P2ClientGate)

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

  end
end # module P2Ruby


