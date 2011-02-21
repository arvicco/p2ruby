module P2Ruby

  # Represents Connection to local P2 Router.
  # Several connections may exist per one Application.
  # �������� ��������� �������, ������� ������������ ����������� ��� �������� � ������
  # � ������������, � ����� ������ � ��������� ���������.
  #
  class Connection < P2Class
    CLSID = '{CCD42082-33E0-49EA-AED3-9FE39978EB56}'
    PROGID = 'P2ClientGate.P2Connection.1'
    #    �	AppName [in/out] BSTR � ��� ����������, ��� �������� ���������� ���������� ����������.
    #       ��� ���������� ������ ���� ���������� � ������ ������ �������.
    #    �	NodeName [out] BSTR � ��� �������.
    #    �	Host [in/out] BSTR � IP-����� ���� ���� UNC-���.
    #    �	Port [in/out] ULONG � ����� ����� TCP/IP.
    #    �	Password [in] BSTR � ������ ��� ���������� ����������.
    #    �	Timeout [in/out] ULONG � �������, � ������� �������� ��������� ��������� ���������� ����������.
    #    �	LoginStr [in/out] BSTR � ������ � ������������������ ����������� ������� (�����/������).
    #       ������ ������: USERNAME=;PASSWORD=. ��������, USERNAME=3@ivanov;PASSWORD=qwerty.
    #
    #    �������� AppName, NodeName, Host, Port, Password � Timeout ������ ���� ������ ��
    #    ������� ������ ������ Connect. � ������ ��������� ������ ������� ��� ����, �����
    #    ��������� �������� � ���� ���������� �������� ���������������� ����� ������� Disconnect � Connect.
    #    ��������� �������������� ������� (LoginStr) ������ ���� ������ �� ������� ������ ������ Login.
    #
    def initialize opts = {}

      # First we need to obtain Application singleton (for a given ini file)... Yes, it IS weird.
      @app = P2Ruby::Application.instance opts[:ini]

      # app_name, node_name, host, port, password, timeout, login_str, lib = Library.default
      super "P2Connection", opts

      # This is class var, not constant... since P2 constants are only loaded by Application instance...
      @@status_messages ||= {P2::CS_CONNECTION_DISCONNECTED => 'Connection Disconnected',
                             #  �	0x00000001 � ���������� � �������� ��� �� �����������.
                             P2::CS_CONNECTION_CONNECTED => 'Connection Connected',
                             #  �	0x00000002 � ���������� � �������� �����������.
                             P2::CS_CONNECTION_INVALID => 'Connection Invalid',
                             #  �	0x00000004 - ������� �������� ������ ����������, ����������
                             #    ������ �������� ������ ����� ��������� ��������� ����������.
                             P2::CS_CONNECTION_BUSY => 'Connection Busy',
                             #  �	0x00000008 � ���������� �������� ������������� �������� ��������� ���������.
                             P2::CS_ROUTER_DISCONNECTED => 'Router Disconnected',
                             #  �	0x00010000  � ������ �������, �� �� ����������� � ����.
                             #    ������ �� ������� ��������� ��������� ����������, �����
                             #    �� �����, ��������� ������ ��������� ����������, ��� ����
                             #    ��������� ���������� ����� ����������������� ����� ����� ����� ������.
                             P2::CS_ROUTER_RECONNECTING => 'Router Reconnecting',
                             #  �	0x00020000 � ������ ������� ������������������ ����������
                             #    (��� � ������), �������� ���������� ��������� ����������,
                             #    �� �� ���� ��������� ���������� ��� �� �����������.
                             P2::CS_ROUTER_CONNECTED => 'Router Connected',
                             #  �	0x00040000 � ������ ��������� �� ������� ���� ���� ���������
                             #    ����������, ������������������ ���������� ������������.
                             P2::CS_ROUTER_LOGINFAILED => 'Router Login Failed',
                             #  �	0x00080000 � �� ������� ���� ���� �� �������� ��������
                             #    ������������������ ����������. � ���� ������ ������������������
                             #    ���������� ���������� ����������������. ��� ����������� ������
                             #    ���������� �������� ���������������� ����� ������� Logout � Login.
                             P2::CS_ROUTER_NOCONNECT => 'Router No Connect'
                             #  �	0x00100000 � �� �������� ���������� ������� ������ �� ����
                             #    ���������� �� ������ ���������� ����������, �� ������������������
                             #    ���������� ������������. ������ ������ �� ����� ��������
                             #    ���������� ��������� ����������. ��� ����������� ������
                             #    ���������� �������� ���������������� ����� ������� Logout � Login.
      }
    end

    #  Connection and Router status in text format
    #
    def status_text
      @@status_messages.map { |k, v| (k & @ole.status).zero? ? nil : v }.compact.join(', ')
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

    # Auto-generated OLE methods:

    # property I4 Status
    #   ��� ��������� ���������� ��� �������.
    def Status()
      @ole._getproperty(1, [], [])
    end

    # property BSTR AppName
    #   ��� ����������, ��� �������� ���������� ���������� ����������. ��� ����������
    #   ������ ���� ���������� � ������ ������ �������.
    def AppName()
      @ole._getproperty(2, [], [])
    end

    # property BSTR NodeName
    #   ��� �������
    def NodeName()
      @ole._getproperty(3, [], [])
    end

    # property BSTR Host
    #   IP-����� ���� ���� UNC-���.
    def Host()
      @ole._getproperty(4, [], [])
    end

    # property UI4 Port
    #   ����� ����� TCP/IP.
    def Port()
      @ole._getproperty(5, [], [])
    end

    # property UI4 Timeout
    #   �������, � ������� �������� ��������� ��������� ���������� ����������.
    def Timeout()
      @ole._getproperty(7, [], [])
    end

    # property BSTR LoginStr
    #   ������ � ������������������ ����������� ������� (�����/������).
    #   ������ ������: USERNAME=;PASSWORD=. ��������, USERNAME=3@ivanov;PASSWORD=qwerty.
    def LoginStr()
      @ole._getproperty(8, [], [])
    end

    # property VOID AppName
    #   ��� ����������, ��� �������� ���������� ���������� ����������. ��� ����������
    #   ������ ���� ���������� � ������ ������ �������.
    def AppName=(val)
      @ole._setproperty(2, [val], [VT_BSTR])
    end

    # property VOID Host
    #   IP-����� ���� ���� UNC-���.
    def Host=(val)
      @ole._setproperty(4, [val], [VT_BSTR])
    end

    # property VOID Port
    #   ����� ����� TCP/IP.
    def Port=(val)
      @ole._setproperty(5, [val], [VT_UI4])
    end

    # property VOID Password
    #  ������ ��� ���������� ����������.
    def Password=(val)
      @ole._setproperty(6, [val], [VT_VARIANT])
    end

    # property VOID Timeout
    # �������, � ������� �������� ��������� ��������� ���������� ����������.
    def Timeout=(val)
      @ole._setproperty(7, [val], [VT_UI4])
    end

    # property VOID LoginStr
    #    ������ � ������������������ ����������� ������� (�����/������).
    #    ������ ������: USERNAME=;PASSWORD=. ��������, USERNAME=3@ivanov;PASSWORD=qwerty.
    def LoginStr=(val)
      @ole._setproperty(8, [val], [VT_BSTR])
    end

    # method UI4 Connect ([out, retval] ULONG* errClass);
    #  �������� ���������� ���������� ���������� � ��������.
    #  errClass � ����� ������ � ��� ������, ���� ������� ������ ��������� �������� �� P2ERR_OK.
    #  ������������ ��������� ������ ������:
    #  �	0 (��������� P2MQ_ERRORCLASS_OK) � ����� ����� �������� ���������� ����������
    #       ���������� � ���� �� ����������� (��������, ������� ��������� ������� � ������
    #       ��������� ���� � �.�.).
    #  �	1 (��������� P2MQ_ERRORCLASS_IS_USELESS) � �������� ��������� ������� ����������
    #       ���������� �������� � ��� �� �����������, ���������� �������� ��������� �������.
    def Connect()
      @ole._invoke(9, [], [])
    end

    # method UI4 Connect2
    #  �������� ���������� ���������� ���������� � ��������. ������� � ���������� � ������ Connection#Connect.
    #   BSTR conn_str [IN]
    def Connect2(conn_str)
      @ole._invoke(18, [conn_str], [VT_BSTR])
    end

    # method VOID DisconnecT
    #  ������ ���������� ����������
    def Disconnect()
      @ole._invoke(10, [], [])
    end

    # method VOID Login
    #  ������������� ����� ������� � ����. ������ ������� ��������� ��������� ����������
    #  � ����������� �������� � ����������������� � ����. ��������� ��������������
    #  (USERNAME=;PASSWORD=) �������� ��������� LoginStr..
    def Login()
      @ole._invoke(11, [], [])
    end

    # method VOID Logout
    #   ������ ���� ��������� ���������� �������.
    def Logout()
      @ole._invoke(12, [], [])
    end

    # method VOID ProcessMessage
    #  ����� � ��������� ���������, � ��� ����� � ��������������.
    #   UI4 cookie [OUT] � ������� � �������������, � ������� �������� ��������� ��������� ���������;
    #   UI4 poll_timeout [IN] � ���������� ������������� ����������.
    def ProcessMessage(cookie, poll_timeout)
      keep_lastargs @ole._invoke(13, [cookie, poll_timeout], [VT_BYREF|VT_UI4, VT_UI4])
    end

    # method UI4 ProcessMessage2 ( [in] ULONG pollTimeout, [out, retval] ULONG* cookie);
    #  ����� � ��������� ���������. ������� � ���������� � ������ Connection.ProcessMessage,
    #  ��� ��� ��� �� �������� � ������������������ ������ (JScript) �������� ��������� ������ ������� (cookie).
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
    #  ����������� ����������.
    #  �	cookie � ���������� ������������� ����������. ������������ ��� ����, ����� �����
    #     ���� �������� ��������, � ����� ������ �� ���� � ������ Connection.ProcessMessage
    #     ������������ ���������� ���������.
    #   IP2MessageReceiver new_receiver [IN] � ��������� �� ��������� ��������� ������;
    def RegisterReceiver(new_receiver)
      @ole._invoke(14, [new_receiver], [VT_BYREF|VT_DISPATCH])
    end

    # method VOID UnRegisterReceiver ([in] ULONG cookie);
    #  ������ ����������� ���������� �� �������������� (cookie).
    #   UI4 cookie [IN]
    def UnRegisterReceiver(cookie)
      @ole._invoke(15, [cookie], [VT_UI4])
    end

    # method BSTR ResolveService ( [in] BSTR service, [out,retval] BSTR* address);
    #  ��������� ������� ������ ���������� �� ����� �������, ������� ��� �������������.
    #   BSTR service [IN] - � ��� �������;
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


