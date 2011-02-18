module P2Ruby

  # Represents Connection to local P2 Router.
  # Several connections may exist per one Application.
  # �������� ��������� �������, ������� ������������ ����������� ��� �������� � ������
  # � ������������, � ����� ������ � ��������� ���������.
  #
  class Connection < P2Class
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
      @ole.appName = @opts[:app_name] if @opts[:app_name]
      @ole.host = @opts[:host] if @opts[:host]
      @ole.port = @opts[:port] if @opts[:port]
      @ole.password = @opts[:password] if @opts[:password]
      @ole.loginStr = @opts[:login_str] if @opts[:login_str]
      @ole.timeout = @opts[:timeout] if @opts[:timeout]

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

  end
end # module P2Ruby


