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
    end
  end
end # module P2Ruby


