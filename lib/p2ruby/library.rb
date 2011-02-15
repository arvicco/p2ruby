module P2Ruby
  # Represents P2ClientGate(MTA) OLE type library
  class Library < WIN32OLE_TYPELIB

    def self.default
      @library ||= new
    end

    def initialize type = :mta
      p2libs = WIN32OLE_TYPELIB.typelibs.select { |t| t.name =~ /P2ClientGate/ }
      raise "No libs registered, please register P2ClientGate[MTA].dll" if p2libs.empty?

      p2lib = p2libs.find { |t| type == :mta ? t.name =~ /MTA/ : t.name !~ /MTA/ }
      raise "No registered libs of #{type} type" unless p2lib

      super p2lib.name
    end

    def full_class_name name
      "P2ClientGate.#{name}"
    end

  end # class Library
end # module P2Ruby
