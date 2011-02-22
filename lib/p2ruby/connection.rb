module P2Ruby

  # Represents Connection to local P2 Router.
  # Several connections may exist per one Application.
  # �������� ��������� �������, ������� ������������ ����������� ��� �������� � ������
  # � ������������, � ����� ������ � ��������� ���������.
  #
  # Notes: �������� AppName, NodeName, Host, Port, Password � Timeout ������ ���� ������ ��
  # ������� ������ ������ Connect. � ������ ��������� ������ ������� ��� ����, �����
  # ��������� �������� � ���� ���������� �������� ���������������� ����� �������
  # Disconnect � Connect. ��������� �������������� ������� (LoginStr) ������ ����
  # ������ �� ������� ������ ������ Login.
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


