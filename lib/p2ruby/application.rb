module P2Ruby
  # Represents P2 client application
  class Application
    def initialize ini_file, lib = Library.default
      @ini_file = Pathname(ini_file)
      raise "Wrong ini file name" unless @ini_file.expand_path.exist?
      @ole = lib.build "P2Application"
    end

    def method_missing metod, *args
      if @ole.respond_to? metod
        @ole.send metod, *args
      else
        super metod, *args
      end
    end
  end
end # module P2Ruby


