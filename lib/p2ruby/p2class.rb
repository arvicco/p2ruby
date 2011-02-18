module P2Ruby

  # This is P2 Base class that defines common functionality.
  # All Ruby P2 classes serve as transparent proxy for OLE objects in P2ClientGate library.
  #
  class P2Class
    include P2Ruby

    attr_reader :opts, :ole

    def initialize name, opts = {}
      @opts = opts.dup
      @ole = @opts[:ole] # OLE object may be provided directly (Message)
      @ole ||= WIN32OLE.new (@opts[:lib] || Library.default).find name
    end

    # All unknown methods are routed to composed OLE object
    #
    def method_missing *args
      @ole.send *args
    end

  end
end # module P2Ruby
