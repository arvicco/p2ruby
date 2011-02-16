module P2Ruby
  # Represents P2 client application
  class Application

    def initialize opts = {}
      @opts = opts
      @ini_file = Pathname(opts[:ini] || opts[:ini_file] || "./P2ClientGate.ini")
      raise "Wrong ini file name" unless @ini_file.expand_path.exist?

      @ole = WIN32OLE.new (opts[:lib] || Library.default).full_class_name "P2Application"
      @ole.StartUp @ini_file.to_s
    end

    def method_missing *args
      @ole.send *args
    end
  end
end # module P2Ruby


