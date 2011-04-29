#  View of /branches/ruby_1_9_2/ext/win32ole/sample/olegen.rb
#
#  Parent Directory Parent Directory | Revision Log Revision Log
#  Revision 27657 - (download) (annotate)
#  Fri May 7 09:08:53 2010 UTC (9 months, 1 week ago) by yugui
#  File size: 8428 byte(s)
#
#  branches ruby_1_9_2 from r27656 on the trunk for release process of Ruby 1.9.2.
#
#-----------------------------
# olegen.rb
#-----------------------------

require 'win32ole'

class String
  # returns snake_case representation of string
  def snake_case
    gsub(/([a-z])([A-Z0-9])/, '\1_\2').downcase
  end
end

class WIN32COMGen
  def initialize(typelib)
    @typelib = typelib
    @reciever = ""
  end

  attr_reader :typelib

  def ole_classes(typelib)
    begin
      @ole = WIN32OLE.new(typelib)
      [@ole.ole_obj_help]
    rescue
      WIN32OLE_TYPE.ole_classes(typelib)
    end
  end

  def generate_args(method)
    args = []
    if method.size_opt_params >= 0
      size_required_params = method.size_params - method.size_opt_params
    else
      size_required_params = method.size_params - 1
    end
    size_required_params.times do |i|
      if method.params[i]
        param = method.params[i].name.snake_case || "arg#{i}"
        param += "=nil" if method.params[i].optional?
        args.push param
      end
    end
    if method.size_opt_params >= 0
      method.size_opt_params.times do |i|
        if method.params[i]
          param = method.params[i].name.snake_case || "arg#{i}" + "=nil"
        else
          param = "arg#{i + size_required_params}=nil"
        end
        args.push param
      end
    else
      args.push "*args"
    end
    args.push "val" if method.invoke_kind == 'PROPERTYPUT'
    args.join(", ")
  end

  def generate_argtype(typedetails)
    ts = ''
    typedetails.each do |t|
      case t
        when 'CARRAY', 'VOID', 'UINT', 'RESULT', 'DECIMAL' #, 'I8', 'UI8'
          ts << "\"??? NOT SUPPORTED TYPE:`#{t}'\""
        when 'USERDEFINED', 'Unknown Type 9'
          ts << 'VT_DISPATCH'
          break;
        when 'SAFEARRAY'
          ts << 'VT_ARRAY|'
        when 'PTR'
          ts << 'VT_BYREF|'
        when 'INT'
          ts << 'VT_I4'
        else
          if String === t
            ts << 'VT_' + t
          end
      end
    end
    if ts.empty?
      ts = 'VT_VARIANT'
    elsif ts[-1] == ?|
      ts += 'VT_VARIANT'
    end
    ts
  end

  def generate_argtypes(method, proptypes)
    types = method.params.collect { |param|
      generate_argtype(param.ole_type_detail)
    }.join(", ")
    if proptypes
      types += ", " if types.size > 0
      types += generate_argtype(proptypes)
    end
    types
  end

  def generate_method_body(method, disptype, types=nil)
    # Check if we need to keep WIN32OLE::ARGV to access OUT args...
    args = generate_method_args_help(method)
    (args && args['OUT'] ? "    keep_lastargs " : "    ") +
        "#{@reciever}#{disptype}(#{method.dispid}, " +
        "[#{generate_args(method).gsub('=nil', '')}], " +
        "[#{generate_argtypes(method, types)}])"
  end

  def generate_method_help(method, type = nil)
    str = "  # "
    typed_name = "#{type || method.return_type} #{method.name}"
    if method.helpstring && method.helpstring != ""
      if method.helpstring[method.name]
        str += method.helpstring.sub(method.name, typed_name)
      else
        str += typed_name + ': ' + method.helpstring
      end
    else
      str += typed_name
    end
    str += " - EVENT in #{method.event_interface}" if method.event?
    args_help = generate_method_args_help(method)
    str += "\n#{args_help}" if args_help
    str
  end

  def generate_method_args_help(method)
    args = []
    method.params.each_with_index { |param, i|
      h = "  #   #{param.ole_type} #{param.name.snake_case}"
      inout = []
      inout.push "IN" if param.input?
      inout.push "OUT" if param.output?
      h += " [#{inout.join('/')}]"
      h += " ( = #{param.default})" if param.default
      args.push h
    }
    if args.size > 0
      args.join("\n")
    else
      nil
    end
  end

  def generate_method(method, disptype, io = STDOUT, types = nil)
    io.puts "\n"
    io.puts generate_method_help(method)
    if method.invoke_kind == 'PROPERTYPUT'
      io.print "  def #{method.name}=("
    else
      io.print "  def #{method.name}("
    end
    io.print generate_args(method)
    io.puts ")"
    io.puts generate_method_body(method, disptype, types)
    io.puts "  end"
  end

  def generate_propputref_methods(klass, io = STDOUT)
    klass.ole_methods.select { |method|
      method.invoke_kind == 'PROPERTYPUTREF' && method.visible?
    }.each do |method|
      generate_method(method, io)
    end
  end

  def generate_properties_with_args(klass, io = STDOUT)
    klass.ole_methods.select { |method|
      method.invoke_kind == 'PROPERTYGET' &&
          method.visible? &&
          method.size_params > 0
    }.each do |method|
      types = method.return_type_detail
      io.puts "\n"
      io.puts generate_method_help(method, types[0])
      io.puts "  def #{method.name}"
      if klass.ole_type == "Class"
        io.print "    @_#{method.name} ||= OLEProperty.new(@ole, #{method.dispid}, ["
      else
        io.print "    @_#{method.name} ||= OLEProperty.new(self, #{method.dispid}, ["
      end
      io.print generate_argtypes(method, nil)
      io.print "], ["
      io.print generate_argtypes(method, types)
      io.puts "])"
      io.puts "  end"
    end
  end

  def generate_propput_methods(klass, io = STDOUT)
    klass.ole_methods.select { |method|
      method.invoke_kind == 'PROPERTYPUT' && method.visible? &&
          method.size_params == 1
    }.each do |method|
      ms = klass.ole_methods.select { |m|
        m.invoke_kind == 'PROPERTYGET' &&
            m.dispid == method.dispid
      }
      types = []
      if ms.size == 1
        types = ms[0].return_type_detail
      end
      generate_method(method, '_setproperty', io, types)
    end
  end

  def generate_propget_methods(klass, io = STDOUT)
    klass.ole_methods.select { |method|
      method.invoke_kind == 'PROPERTYGET' && method.visible? &&
          method.size_params == 0
    }.each do |method|
      generate_method(method, '_getproperty', io)
    end
  end

  def generate_func_methods(klass, io = STDOUT)
    klass.ole_methods.select { |method|
      method.invoke_kind == "FUNC" && method.visible?
    }.each do |method|
      generate_method(method, '_invoke', io)
    end
  end

  def generate_methods(klass, io = STDOUT)
    generate_propget_methods(klass, io)
    generate_propput_methods(klass, io)
    generate_properties_with_args(klass, io)
    generate_func_methods(klass, io)
#   generate_propputref_methods(klass, io)
  end

  def generate_constants(klass, io = STDOUT)
    klass.variables.select { |v|
      v.visible? && v.variable_kind == 'CONSTANT'
    }.each do |v|
      io.print "  "
      io.print v.name.sub(/^./) { $&.upcase }
      io.print " = "
      io.puts v.value
    end
  end

  def class_name(klass)
    klass_name = klass.name
    if klass.ole_type == "Class" &&
        klass.guid &&
        klass.progid
      klass_name = klass.progid.gsub(/\./, '_')
    end
    if /^[A-Z]/ !~ klass_name || Module.constants.include?(klass_name)
      klass_name = 'OLE' + klass_name
    end
    klass_name
  end

  def define_initialize(klass)
    <<STR

  def initialize opts = {}
    super PROGID, opts
  end
STR
  end

  def define_include
    "  include WIN32OLE::VARIANT"
  end

  def define_instance_variables
    "  attr_reader :lastargs"
  end

  def define_common_methods
    <<STR

  def method_missing(cmd, *args)
    @ole.method_missing(cmd, *args)
  end

  def keep_lastargs(return_value)
    @lastargs = WIN32OLE::ARGV
    return_value
  end

  def clsid
    CLSID
  end

  def progid
    PROGID
  end
STR
  end

  def define_class(klass, io = STDOUT)
    io.puts "class #{klass.name} < Base # #{class_name(klass)}"
    io.puts "  CLSID = '#{klass.guid}'"
    io.puts "  PROGID = '#{klass.progid}'"
    io.puts define_include
    io.puts define_instance_variables
    io.puts "  attr_reader :ole"
    io.puts define_initialize(klass)
    io.puts define_common_methods
  end

  def define_module(klass, io = STDOUT)
    io.puts "module #{class_name(klass)}"
    io.puts define_include
    io.puts define_instance_variables
  end

  def generate_class(klass, io = STDOUT)
    io.puts "\n# #{klass.helpstring}"
    if klass.ole_type == "Class" &&
        klass.guid &&
        klass.progid
      @reciever = "@ole."
      define_class(klass, io)
    else
      @reciever = ""
      define_module(klass, io)
    end
    generate_constants(klass, io)
    generate_methods(klass, io)
    io.puts "end"
  end

  def generate(io = STDOUT)
    io.puts "require 'win32ole'"
    io.puts "require 'win32ole/property'"

    ole_classes(typelib).select { |klass|
      klass.visible? &&
          (klass.ole_type == "Class" ||
              klass.ole_type == "Interface" ||
              klass.ole_type == "Dispatch" ||
              klass.ole_type == "Enum")
    }.each do |klass|
      generate_class(klass, io)
    end
    begin
      @ole.quit if @ole
    rescue
    end
  end
end

if __FILE__ == $0
#  if ARGV.size == 0
#    $stderr.puts "usage: #{$0} Type Library [...]"
#    exit 1
#  end
#  ARGV.each do |typelib|
  typelib = WIN32OLE_TYPELIB.typelibs.find { |t| t.name =~ /P2ClientGate / }
  comgen = WIN32COMGen.new(typelib.guid)
  comgen.generate
#  end
end
