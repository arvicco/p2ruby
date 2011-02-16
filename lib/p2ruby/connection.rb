module P2Ruby

  # Represents Connection to local P2 Router.
  # Several connections may exist per one Application.
  #
  class Connection < P2Class
    #    Х	AppName [in/out] BSTR Ч им€ приложени€, дл€ которого необходимо установить соединение.
    #       »м€ приложени€ должно быть уникальным в рамках одного роутера.
    #    Х	NodeName [out] BSTR Ч им€ роутера.
    #    Х	Host [in/out] BSTR Ч IP-адрес узла либо UNC-им€.
    #    Х	Port [in/out] ULONG Ч номер порта TCP/IP.
    #    Х	Password [in] BSTR Ч пароль дл€ локального соединени€.
    #    Х	Timeout [in/out] ULONG Ч таймаут, в течение которого ожидаетс€ установка локального соединени€.
    #    Х	LoginStr [in/out] BSTR Ч строка с аутентификационной информацией роутера (логии/пароль).
    #       ‘ормат строки: USERNAME=;PASSWORD=. Ќапример, USERNAME=3@ivanov;PASSWORD=qwerty.
    #
    #    —войства AppName, NodeName, Host, Port, Password и Timeout должны быть заданы до
    #    момента вызова метода Connect. ¬ случае изменени€ данных свойств дл€ того, чтобы
    #    изменени€ вступили в силу необходимо провести последовательный вызов методов Disconnect и Connect.
    #    ѕараметры аутентификации роутера (LoginStr) должны быть заданы до момента вызова метода Login.
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
    end
  end
end # module P2Ruby


