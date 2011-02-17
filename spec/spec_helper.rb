require 'p2ruby'
require 'pathname'

require 'bundler'
Bundler.setup
Bundler.require :test

BASE_PATH = Pathname.new(__FILE__).dirname + '..'
INI_PATH = (BASE_PATH + 'spec/files/P2ClientGate.ini').realpath

RSpec.configure do |config|
  # config.exclusion_filter = { :slow => true }
  # config.filter = { :focus => true }
  # config.include(UserExampleHelpers)
end

def show_ole
  print 'Implemented OLE types: '; p subject.ole_type.implemented_ole_types
  print 'Source OLE types: '; p subject.ole_type.source_ole_types
  print 'OLE methods: '
  p subject.ole_methods.map { |m| "#{m.invoke_kind} #{m.name}(#{m.params.join ', '})" }.sort
end

# Start test Router service if it is currently down
ROUTER_ID = 'FORTS_FZ36001_bezvv'
ROUTER_TITLE = Regexp.new('P2MQRouter .+' + ROUTER_ID)
unless WinGui::Window.find :title => ROUTER_TITLE
  WinGui::App.launch(:dir => 'p2', :path => 'start_router.cmd', :title => ROUTER_TITLE, :timeout => 5)
# start ./p2bin/P2MQRouter.exe /ini:CLIENT_router.ini
end
