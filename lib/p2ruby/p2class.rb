module P2Ruby

  # This is P2 Base class that defines common functionality.
  # All Ruby P2 classes serve as transparent proxy for OLE objects in P2ClientGate library.
  #
  class P2Class
    include P2Ruby
    include WIN32OLE::VARIANT

    attr_reader :opts, :ole, :lastargs

    def initialize name, opts = {}
      @opts = opts.dup

      # OLE object may be provided directly (Message)
      @ole = @opts[:ole]
      @ole ||= WIN32OLE.new (@opts[:lib] || Library.default).find name

      # OLE object set properties may be given as options
      @opts.each do |key, val|
        method = "#{key.to_s.camel_case}="
        send(method, val) if respond_to? method
      end
    end

    # All unknown methods are routed to composed OLE object
    #
    def method_missing *args
      @ole.send *args
    end

    # Keeps [OUT] args sent by reference into OLE method
    # s
    def keep_lastargs(return_value)
      @lastargs = WIN32OLE::ARGV
      return_value
    end

    def clsid
      self.class::CLSID
    end

    def progid
      self.class::PROGID
    end
  end
end # module P2Ruby
