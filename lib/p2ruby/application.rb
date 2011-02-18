module P2Ruby
  # Represents P2 client application
  #  �������� ������ ���������� P2ClientGate, ��������������� ��� �� �������������.
  #  �� ��������� �������� ��������� �������������, �������� �� ���������� �� ���������
  #  (���������������� ini-����), � ����� ������������� ��� �������, ������������� ���
  #  ��������-������ ������. ��� ������� � Plaza ��� Plaza-II (��������� ��� ���������
  #  �������� ���������� �������� ���� Body).
  #  � ���������������� ini-����� ����� ������ ���� � ����� ������� ������ ����������
  #  Plaza-II � ����� ����������, � ����� ���� � �trace-����� � ����� � ������� �����������,
  #  ����� ��������� ������ � ������ ������, � ����� � ���. ������������� ��������� ��������
  #  ����������������� � ������� ����������������� ini-�����, ����������� � ����������� �����.
  #  ��� ����, ����� ������ ��������� �������������, �������� �� ���������� �� ���������
  #  ������� ���� ������� ������ Application � � ������ ������ StartUp ������� ���
  #  ����������������� ini-����� � ���� � ����. ��� ������� �������� ��� �������� �������
  #  � ���������� � ������� ����������� ������� get � put.
  #  ������ ��� ���������� �� ������ ������ � ������� ��������� ����������.
  #
  class Application < P2Class

    attr_accessor :ini

    # Application should not be used directly in client code, Connection.new
    # tries to obtain/create Application instance implicitly.
    #
    def initialize ini
      @ini = Pathname(ini || "./P2ClientGate.ini").expand_path
      error "Wrong ini file #{@ini}" unless @ini.exist?

      super "P2Application", :ini => @ini

      # Application is created before any other P2 object,
      # need to load P2 constants (same for all P2 classes)
      WIN32OLE.const_load(@ole, P2ClientGate)

      @ole.StartUp @ini.to_s
    end

    # Application is a Resettable Singleton:
    # Normally, you use Application.instance to create/obtain its instance;
    # However, when Application.reset is called, this resets the instance.
    #
    def self.reset ini = nil
      @instance = new ini
    end

    # Returns Application instance unless explicitly given different ini file
    #
    def self.instance ini = nil
      if @instance && ini && @instance.ini != Pathname(ini).expand_path
        error "Attempt to obtain #{@instance} for different ini: #{ini}"
      end
      @instance ||= new ini
    end

  end
end # module P2Ruby


