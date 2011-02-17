module P2Ruby

  # Represents Connection to local P2 Router.
  # Several connections may exist per one Application.
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
    #  ?	0x00000001 (CS_CONNECTION_DISCONNECTED) � ���������� � �������� ��� �� �����������.
    #  ?	0x00000002 (CS_CONNECTION_CONNECTED) � ���������� � �������� �����������.
    #  ?	0x00000004 (CS_CONNECTION_INVALID) � ������� �������� ������ ����������, ����������
    #         ������ �������� ������ ����� ��������� ��������� ����������.
    #  ?	0x00000008 (CS_CONNECTION_BUSY) � ���������� �������� ������������� �������� ��������� ���������.
    #  ?	0x00010000 (CS_ROUTER_DISCONNECTED) � ������ �������, �� �� ����������� � ����.
    #         ������ �� ������� ��������� ��������� ����������, ����� �� �����, ���������
    #         ������ ��������� ����������, ��� ���� ��������� ���������� ����� �����������������
    #         ����� ����� ����������� �������.
    #  ?	0x00020000 (CS_ROUTER_RECONNECTING) � ������ ������� ������������������ ����������
    #         (��� � ������), �������� ���������� ��������� ����������, �� �� ���� ���������
    #         ���������� ��� �� �����������.
    #  ?	0x00040000 (CS_ROUTER_CONNECTED) � ������ ��������� �� ������� ���� ���� ���������
    #         ����������, ������������������ ���������� ������������.
    #  ?	0x00080000 (CS_ROUTER_LOGINFAILED) � �� ������� ���� ���� �� �������� ��������
    #         ������������������ ����������. � ���� ������ ������������������ ����������
    #         ���������� ����������������. ��� ����������� ������ ���������� ��������
    #         ���������������� ����� ������� Logout � Login.
    #  ?	0x00100000 (CS_ROUTER_NOCONNECT) � �� �������� ���������� ������� ������ �� ����
    #         ���������� �� ������ ���������� ����������, �� ������������������ ����������
    #         ������������. ������ ������ �� ����� �������� ���������� ��������� ����������.
    #         ��� ����������� ������ ���������� �������� ���������������� ����� ������� Logout � Login.
    def status_text
      @@status_messages.map{|k,v| (k & @ole.status).zero? ? nil : v}.compact.join(', ')
    end
  end
end # module P2Ruby


