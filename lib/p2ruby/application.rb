module P2Ruby
  # Represents P2 client application
  class Application

    def initialize opts = {}
      @opts = opts
      @ini_file = Pathname(opts[:ini] || opts[:ini_file] || "./P2ClientGate.ini")
      raise "Wrong ini file name" unless @ini_file.expand_path.exist?

      @ole = WIN32OLE.new (opts[:lib] || Library.default).find "P2Application"

      # Application is created before any other P2 object,
      # need to load P2 constants (same for all P2 classes)
      WIN32OLE.const_load(@ole, P2ClientGate)

      @ole.StartUp @ini_file.to_s
    end

    def method_missing *args
      @ole.send *args
    end
  end
end # module P2Ruby


