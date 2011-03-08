begin
  require 'rake'
rescue LoadError
  require 'rubygems'
  gem 'rake', '~> 0.8.3.1'
  require 'rake'
end

require 'pathname'

BASE_PATH = Pathname.new(__FILE__).dirname
LIB_PATH = BASE_PATH + 'lib'
PKG_PATH = BASE_PATH + 'pkg'
DOC_PATH = BASE_PATH + 'rdoc'
P2_PATH = BASE_PATH + 'p2'

$LOAD_PATH.unshift LIB_PATH.to_s
require 'version'

NAME = 'p2ruby'
CLASS_NAME = P2

# Load rakefile tasks
Dir['tasks/*.rake'].sort.each { |file| load file }

# Project-specific tasks

namespace :ole do
  desc "Regist  moter P2ClientGate.dll COM/OLE objects with Windows"
  task :register do
    cd P2_PATH
    system 'regsvr32 P2ClientGate.dll'
    cd BASE_PATH
  end

  desc "Generate OLE class stubs from typelib"
  task :generate do
    puts "Generate P2 OLE classes"
    filename = Time.now.strftime "ole%Y%m%d-%H%M%S"
    system "ruby bin/olegen.rb > lib/#{filename}.rb"
  end
end
