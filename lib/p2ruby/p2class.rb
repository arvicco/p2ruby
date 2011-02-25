module P2

  # This is P2 Base class that defines common functionality.
  # All Ruby P2 classes serve as transparent proxy for OLE objects in P2ClientGate library.
  #
  class P2Class
    include P2
    include WIN32OLE::VARIANT

    attr_reader :opts, :ole, :lastargs

    def initialize opts = {}
      @opts = opts.dup

      # OLE object may be provided directly (Message)
      @ole = @opts[:ole]
      @ole ||= WIN32OLE.new clsid # (@opts[:lib] || Library.default).find name

      @opts.each do |key, val|
        # OLE object set properties may be given as options
        setter = "#{key.to_s.camel_case}="
        send(setter, val) if respond_to? setter

        # OLE object NAMED properties may be given as options (Message#Field)
        prop = key.to_s.camel_case
        if respond_to?(prop) && val.is_a?(Hash)
          val.each do |k, v|
            property = send prop
            property[k.to_s] = v
          end
        end
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
end # module P2
