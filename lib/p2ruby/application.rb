module P2Ruby
  # Represents P2 client application
  class Application < P2Class

    def initialize opts = {}
      @ini_file = Pathname(opts[:ini] || opts[:ini_file] || "./P2ClientGate.ini")
      error "Wrong ini file name" unless @ini_file.expand_path.exist?

      super "P2Application", opts

      # Application is created before any other P2 object,
      # need to load P2 constants (same for all P2 classes)
      WIN32OLE.const_load(@ole, P2ClientGate)

      @ole.StartUp @ini_file.to_s
    end
  end
end # module P2Ruby


