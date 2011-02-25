module P2
  # Represents P2ClientGate OLE type library.
  # Only works with STA version ( Ruby WIN32OLE limitation ).
  class Library < WIN32OLE_TYPELIB
    include P2

    # Returns default lib if not explicitely instantiated
    #
    def self.default
      @library ||= new
    end

    def initialize
      p2lib = WIN32OLE_TYPELIB.typelibs.find { |t| t.name =~ /P2ClientGate / }
      error "No registered STA P2ClientGate, please register P2ClientGate.dll" unless p2lib
      super p2lib.name
    end

    def find name
      self.ole_types.map(&:progid).compact.find { |progid| progid[name] }
    end

  end # class Library
end # module P2
