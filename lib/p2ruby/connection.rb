module P2Ruby

  # Represents Connection to local P2 Router.
  # Several connections may exist per one Application.
  # Основной интерфейс объекта, который используется приложением для создания и работы
  # с соединениями, а также приема и обработки сообщений.
  #
  # Notes: Свойства AppName, NodeName, Host, Port, Password и Timeout должны быть заданы до
  # момента вызова метода Connect. В случае изменения данных свойств для того, чтобы
  # изменения вступили в силу необходимо провести последовательный вызов методов
  # Disconnect и Connect. Параметры аутентификации роутера (LoginStr) должны быть
  # заданы до момента вызова метода Login.
  #
  class Connection < P2Class
    CLSID = '{CCD42082-33E0-49EA-AED3-9FE39978EB56}'
    PROGID = 'P2ClientGate.P2Connection.1'

    def initialize opts = {}

      # First we need to obtain Application singleton (for a given ini file)...
      # Yes, it IS weird - ini file used by Connection is manipulated in Application.
      @app = P2Ruby::Application.instance opts[:ini]

      super opts
    end

    #  Connection and Router status in text format
    #
    def status_text
      P2::CS_MESSAGES.map { |k, v| (k & @ole.status).zero? ? nil : v }.compact.join(', ')
    end

    # Tests if connection to local Router exists
    #
    def connected?
      @ole.status & P2::CS_CONNECTION_CONNECTED != 0
    end

    # Tests if local Router is authenticated with RTS server
    #
    def logged?
      @ole.status & P2::CS_ROUTER_CONNECTED != 0
    end

    # Returns Win32OLE event wrapper for IP2ConnectionEvent event interface
    #
    def events(event_interface = 'IP2ConnectionEvent')
      @events ||= WIN32OLE_EVENT.new(@ole, event_interface)
    end

    # Auto-generated OLE methods:

    # property I4 Status
    #   Код состояния соединения или роутера.
    def Status()
      @ole._getproperty(1, [], [])
    end

    # property BSTR AppName
    #   имя приложения, для которого необходимо установить соединение. Имя приложения
    #   должно быть уникальным в рамках одного роутера.
    def AppName()
      @ole._getproperty(2, [], [])
    end

    # property BSTR NodeName
    #   имя роутера
    def NodeName()
      @ole._getproperty(3, [], [])
    end

    # property BSTR Host
    #   IP-адрес узла либо UNC-имя.
    def Host()
      @ole._getproperty(4, [], [])
    end

    # property UI4 Port
    #   номер порта TCP/IP.
    def Port()
      @ole._getproperty(5, [], [])
    end

    # property UI4 Timeout
    #   таймаут, в течение которого ожидается установка локального соединения.
    def Timeout()
      @ole._getproperty(7, [], [])
    end

    # property BSTR LoginStr
    #   строка с аутентификационной информацией роутера (логии/пароль).
    #   Формат строки: USERNAME=;PASSWORD=. Например, USERNAME=3@ivanov;PASSWORD=qwerty.
    def LoginStr()
      @ole._getproperty(8, [], [])
    end

    # property VOID AppName
    #   имя приложения, для которого необходимо установить соединение. Имя приложения
    #   должно быть уникальным в рамках одного роутера.
    def AppName=(val)
      @ole._setproperty(2, [val], [VT_BSTR])
    end

    # property VOID Host
    #   IP-адрес узла либо UNC-имя.
    def Host=(val)
      @ole._setproperty(4, [val], [VT_BSTR])
    end

    # property VOID Port
    #   номер порта TCP/IP.
    def Port=(val)
      @ole._setproperty(5, [val], [VT_UI4])
    end

    # property VOID Password
    #  пароль для локального соединения.
    def Password=(val)
      @ole._setproperty(6, [val], [VT_VARIANT])
    end

    # property VOID Timeout
    # таймаут, в течение которого ожидается установка локального соединения.
    def Timeout=(val)
      @ole._setproperty(7, [val], [VT_UI4])
    end

    # property VOID LoginStr
    #    строка с аутентификационной информацией роутера (логии/пароль).
    #    Формат строки: USERNAME=;PASSWORD=. Например, USERNAME=3@ivanov;PASSWORD=qwerty.
    def LoginStr=(val)
      @ole._setproperty(8, [val], [VT_BSTR])
    end

    # method UI4 Connect ([out, retval] ULONG* errClass);
    #  Создание локального соединения приложения с роутером.
    #  errClass — класс ошибки в том случае, если функция вернет результат отличный от P2ERR_OK.
    #  Используются следующие классы ошибок:
    #  •	0 (константа P2MQ_ERRORCLASS_OK) — имеет смысл повторно попытаться установить
    #       соединение с теми же параметрами (возможно, имеются временные перебои в работе
    #       локальной сети и т.п.).
    #  •	1 (константа P2MQ_ERRORCLASS_IS_USELESS) — вероятно повторная попытка установить
    #       соединение приведет к тем же результатом, необходимо изменить параметры функции.
    def Connect()
      @ole._invoke(9, [], [])
    end

    # method UI4 Connect2
    #  Создание локального соединения приложения с роутером. Выпущен в дополнение к методу Connection#Connect.
    #   BSTR conn_str [IN]
    def Connect2(conn_str)
      @ole._invoke(18, [conn_str], [VT_BSTR])
    end

    # method VOID DisconnecT
    #  Разрыв локального соединения
    def Disconnect()
      @ole._invoke(10, [], [])
    end

    # method VOID Login
    #  Инициирование входа роутера в сеть. Роутер создает исходящее удаленное соединение
    #  с вышестоящим роутером и аутентифицируется в сети. Параметры аутентификации
    #  (USERNAME=;PASSWORD=) задаются свойством LoginStr..
    def Login()
      @ole._invoke(11, [], [])
    end

    # method VOID Logout
    #   Разрыв всех удаленных соединений роутера.
    def Logout()
      @ole._invoke(12, [], [])
    end

    # method VOID ProcessMessage
    #  Прием и обработка сообщений, в том числе и репликационных.
    #   UI4 cookie [OUT] — таймаут в миллисекундах, в течение которого ожидается получение сообщения;
    #   UI4 poll_timeout [IN] — уникальный идентификатор подписчика.
    def ProcessMessage(cookie, poll_timeout)
      keep_lastargs @ole._invoke(13, [cookie, poll_timeout], [VT_BYREF|VT_UI4, VT_UI4])
    end

    # method UI4 ProcessMessage2 ( [in] ULONG pollTimeout, [out, retval] ULONG* cookie);
    #  Прием и обработка сообщений. Выпущен в дополнение к методу Connection.ProcessMessage,
    #  так как тот не позволял в интерпретированных языках (JScript) получить результат работы функции (cookie).
    #   UI4 poll_timeout [IN]
    #   [out, retval] ULONG* cookie);???????????????????????
    def ProcessMessage2(poll_timeout)
      @ole._invoke(17, [poll_timeout], [VT_UI4])
    end

    # method UI4 ProcessMessage3
    #   ???
    #   UI4 poll_timeout [IN]
    def ProcessMessage3(poll_timeout)
      @ole._invoke(19, [poll_timeout], [VT_UI4])
    end

    # method UI4 RegisterReceiver ( [in] IP2MessageReceiver* newReceiver, [out,retval] ULONG* cookie);
    #  Регистрация подписчика.
    #  •	cookie — уникальный идентификатор подписчика. Используется для того, чтобы можно
    #     было отменить подписку, а также именно по нему в методе Connection.ProcessMessage
    #     определяется получатель сообщения.
    #   IP2MessageReceiver new_receiver [IN] — указатель на интерфейс обратного вызова;
    def RegisterReceiver(new_receiver)
      @ole._invoke(14, [new_receiver], [VT_BYREF|VT_DISPATCH])
    end

    # method VOID UnRegisterReceiver ([in] ULONG cookie);
    #  Отмена регистрации подписчика по идентификатору (cookie).
    #   UI4 cookie [IN]
    def UnRegisterReceiver(cookie)
      @ole._invoke(15, [cookie], [VT_UI4])
    end

    # method BSTR ResolveService ( [in] BSTR service, [out,retval] BSTR* address);
    #  Получение полного адреса приложения по имени сервиса, который оно предоставляет.
    #   BSTR service [IN] - — имя сервиса;
    def ResolveService(service)
      @ole._invoke(16, [service], [VT_BSTR])
    end

    # HRESULT GetConn
    #   OLE_HANDLE p_val [OUT]
    def GetConn(p_val)
      keep_lastargs @ole._invoke(1610678272, [p_val], [VT_BYREF|VT_BYREF|VT_DISPATCH])
    end

    # HRESULT GetConnPtr
    #   OLE_HANDLE p_val [OUT]
    def GetConnPtr(p_val)
      keep_lastargs @ole._invoke(1610678273, [p_val], [VT_BYREF|VT_BYREF|VT_DISPATCH])
    end

    # method VOID ConnectionStatusChanged - EVENT in IP2ConnectionEvent
    #   IP2Connection conn [IN]
    #   TConnectionStatus new_status [IN]
    def ConnectionStatusChanged(conn, new_status)
      @ole._invoke(1, [conn, new_status], [VT_BYREF|VT_DISPATCH, VT_DISPATCH])
    end
  end
end # module P2Ruby


