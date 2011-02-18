module P2Ruby
  # Represents P2 Message
  # ������ ������������ ��� �������� ���������. ��� ���� �� ��������� ��� �������� ���������
  # ����������� �� ������ ������ ��������� �� ��������� (�������� � P2ClientGate.ini),
  # � ������������� ����� ������� ���������, ����������� �� ��������� ������.
  # ���� ��������� ������������ ������ ����� ���������, ������� ��� ������������� �������
  # ������� ���������������� ini-����, ���������� ����� �����.
  #
  class Message < P2Class
    include WIN32OLE::VARIANT
    attr_reader :lastargs

    def initialize opts = {}
      # First we need to obtain Application instance... Yes, it IS freaking weird.
      error "Connection/Application should be created first" unless P2Ruby::Application.instance

      super "P2BLMessage", opts

      @ole.appName = @opts[:app_name] if @opts[:app_name]
      @ole.host = @opts[:host] if @opts[:host]
      @ole.port = @opts[:port] if @opts[:port]
      @ole.password = @opts[:password] if @opts[:password]
      @ole.loginStr = @opts[:login_str] if @opts[:login_str]
      @ole.timeout = @opts[:timeout] if @opts[:timeout]


    end

    # VARIANT Field
    # property Field
    #   BSTR arg0 --- Name [IN]
    def Field
      @field ||= OLEProperty.new(@ole, 5, [VT_BSTR], [VT_BSTR, VT_VARIANT])
    end

  end
end # module P2Ruby
