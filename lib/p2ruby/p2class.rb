module P2Ruby

  # This is P2 Base class that defines common functionality
  class P2Class
    include P2Ruby

    def initialize name, opts = {}
      @opts = opts
      @ole = WIN32OLE.new (@opts[:lib] || Library.default).find name
    end

    def method_missing *args
      @ole.send *args
    end
  end
end # module P2Ruby
