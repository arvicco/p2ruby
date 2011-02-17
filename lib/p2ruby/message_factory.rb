module P2Ruby
  # Represents P2 client application
  class MessageFactory < P2Class

    def initialize opts = {}
      @ini_file = Pathname(opts[:ini] || opts[:ini_file] || "./p2fortsgate_messages.ini")
      error "Wrong ini file name" unless @ini_file.expand_path.exist?

      super "P2BLMessageFactory", opts

      @ole.Init @ini_file.to_s, "Not used"
    end
  end
end # module P2Ruby
