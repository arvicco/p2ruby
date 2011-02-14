require 'version'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

module P2ruby

  # Requires ruby source file(s), given as single filename/glob or Array of filenames/globs.
  # Accepts following options:
  # :*file*:: Lib(s) required relative to this file - defaults to __FILE__
  # :*dir*:: Required lib(s) located under this dir name - defaults to gem name
  #
  def self.require_libs( libs, opts={} )
    file = Pathname.new(opts[:file] || __FILE__)
    [libs].flatten.each do |lib|
      name = file.dirname + (opts[:dir] || file.basename('.*')) + lib.gsub(/(?<!.rb)$/, '.rb')
      Pathname.glob(name.to_s).sort.each {|rb| require rb}
    end
  end
end  # module P2ruby

# Require all ruby source files located under directory lib/p2ruby
# If you need files in specific order, you should specify it here before the glob
P2ruby.require_libs %W[**/*]

