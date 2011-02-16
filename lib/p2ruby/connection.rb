module P2Ruby

  # Represents Connection to local P2 Router.
  # Several connections may exist per one Application.
  #
  class Connection
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
      @opts = opts
      # app_name, node_name, host, port, password, timeout, login_str, lib = Library.default
      @ole = WIN32OLE.new (@opts[:lib] || Library.default).full_class_name "P2Connection"
      @ole.appName = @opts[:app_name] || "APP-#{rand(10000)}"
      p @ole.appName
    end

    def method_missing *args
      @ole.send *args
    end
  end
end # module P2Ruby


