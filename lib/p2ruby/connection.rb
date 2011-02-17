module P2Ruby

  # Represents Connection to local P2 Router.
  # Several connections may exist per one Application.
  #
  class Connection < P2Class
    #    •	AppName [in/out] BSTR — имя приложения, для которого необходимо установить соединение.
    #       Имя приложения должно быть уникальным в рамках одного роутера.
    #    •	NodeName [out] BSTR — имя роутера.
    #    •	Host [in/out] BSTR — IP-адрес узла либо UNC-имя.
    #    •	Port [in/out] ULONG — номер порта TCP/IP.
    #    •	Password [in] BSTR — пароль для локального соединения.
    #    •	Timeout [in/out] ULONG — таймаут, в течение которого ожидается установка локального соединения.
    #    •	LoginStr [in/out] BSTR — строка с аутентификационной информацией роутера (логии/пароль).
    #       Формат строки: USERNAME=;PASSWORD=. Например, USERNAME=3@ivanov;PASSWORD=qwerty.
    #
    #    Свойства AppName, NodeName, Host, Port, Password и Timeout должны быть заданы до
    #    момента вызова метода Connect. В случае изменения данных свойств для того, чтобы
    #    изменения вступили в силу необходимо провести последовательный вызов методов Disconnect и Connect.
    #    Параметры аутентификации роутера (LoginStr) должны быть заданы до момента вызова метода Login.
    #
    def initialize opts = {}
      # app_name, node_name, host, port, password, timeout, login_str, lib = Library.default
      super "P2Connection", opts
      @ole.appName = @opts[:app_name] if @opts[:app_name]
      @ole.host = @opts[:host] if @opts[:host]
      @ole.port = @opts[:port] if @opts[:port]
      @ole.password = @opts[:password] if @opts[:password]
      @ole.loginStr = @opts[:login_str] if @opts[:login_str]
      @ole.timeout = @opts[:timeout] if @opts[:timeout]

      @@status_messages ||= {P2::CS_CONNECTION_DISCONNECTED => 'Connection Disconnected',
                             P2::CS_CONNECTION_CONNECTED => 'Connection Connected',
                             P2::CS_CONNECTION_INVALID => 'Connection Invalid',
                             P2::CS_CONNECTION_BUSY => 'Connection Busy',
                             P2::CS_ROUTER_DISCONNECTED => 'Router Disconnected',
                             P2::CS_ROUTER_RECONNECTING => 'Router Reconnecting',
                             P2::CS_ROUTER_CONNECTED => 'Router Connected',
                             P2::CS_ROUTER_LOGINFAILED => 'Router Login Failed',
                             P2::CS_ROUTER_NOCONNECT => 'Router No Connect'}
    end

    def connected?
      @ole.status == P2::CS_CONNECTION_CONNECTED | P2::CS_ROUTER_CONNECTED
    end

    #  Connection and Router status in text format
    #  ?	0x00000001 (CS_CONNECTION_DISCONNECTED) — соединение с роутером еще не установлено.
    #  ?	0x00000002 (CS_CONNECTION_CONNECTED) — соединение с роутером установлено.
    #  ?	0x00000004 (CS_CONNECTION_INVALID) — нарушен протокол работы соединения, дальнейшая
    #         работа возможна только после повторной установки соединения.
    #  ?	0x00000008 (CS_CONNECTION_BUSY) — соединение временно заблокировано функцией получения сообщения.
    #  ?	0x00010000 (CS_ROUTER_DISCONNECTED) — роутер запущен, но не присоединен к сети.
    #         Роутер не создает удаленных исходящих соединений, имени не имеет, принимает
    #         только локальные соединения, при этом локальные приложения могут взаимодействовать
    #         между собой посредством роутера.
    #  ?	0x00020000 (CS_ROUTER_RECONNECTING) — роутер получил аутентификационную информацию
    #         (имя и пароль), пытается установить исходящее соединение, но ни одно исходящее
    #         соединение еще не установлено.
    #  ?	0x00040000 (CS_ROUTER_CONNECTED) — роутер установил по крайней мере одно исходящее
    #         соединение, аутентификационная информация подтверждена.
    #  ?	0x00080000 (CS_ROUTER_LOGINFAILED) — по крайней мере один из сервисов отклонил
    #         аутентификационную информацию. В этом случае аутентификационная информация
    #         становится недействительной. Для продолжения работы необходимо провести
    #         последовательный вызов методов Logout и Login.
    #  ?	0x00100000 (CS_ROUTER_NOCONNECT) — за заданное количество попыток роутер не смог
    #         установить ни одного исходящего соединения, но аутентификационная информация
    #         подтверждена. Роутер больше не будет пытаться установить исходящие соединения.
    #         Для продолжения работы необходимо провести последовательный вызов методов Logout и Login.
    def status_text
      @@status_messages.map{|k,v| (k & @ole.status).zero? ? nil : v}.compact.join(', ')
    end
  end
end # module P2Ruby


