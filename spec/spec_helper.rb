require 'p2ruby'
require 'pathname'
require 'fileutils'

require 'bundler'
Bundler.setup
Bundler.require :test

BASE_DIR = (Pathname.new(__FILE__).dirname + '..').realpath
SOURCE_DIR = BASE_DIR + 'p2/'
TMP_DIR = BASE_DIR + 'tmp/'
TEST_DIR = BASE_DIR + 'tmp/p2/'

CLIENT_INI = BASE_DIR + 'spec/files/P2ClientGate.ini'
CLIENT_INI1 = BASE_DIR + 'spec/files/P2ClientGate1.ini'
MESSAGE_INI = BASE_DIR + 'spec/files/p2fortsgate_messages.ini'
# start ./p2bin/P2MQRouter.exe /ini:CLIENT_router.ini
ROUTER_INI = BASE_DIR + 'spec/files/client_router.ini'
ROUTER_PATH = TEST_DIR + 'p2bin/P2MQRouter.exe'
ROUTER_ARGS = "/ini:#{ROUTER_INI}"
ROUTER_LOGIN = 'FORTS_FZ36001_bezvv' # My login to RTS test server
ROUTER_TITLE = Regexp.new('P2MQRouter - ') # + ROUTER_LOGIN)

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

# Closes any open Router application
def stop_router
  while router_app = WinGui::App.find(:title => ROUTER_TITLE)
    router_app.exit(timeout=10)
  end
end

# Starts new Router application. Options:
# :force - force Router to start, even if it's already running (default *false*)
# :title - look for specific Router title
# :dir - cd to this dir before starting router
# :path - start Router at specific path
# :args - start Router with specific command line args
# :timeout - wait for timeout seconds for Router to start (default *5*)
#
def start_router opts ={}
  title = opts[:title] || ROUTER_TITLE
  path = opts[:path] || ROUTER_PATH
  dir = opts[:dir] || TEST_DIR
  args = opts[:args] || ROUTER_ARGS
  timeout = opts[:timeout] || 5
  if not WinGui::Window.find(:title => title) or opts[:force]
    WinGui::App.launch(:dir => dir, :path => path, :args => args,
                       :title => title, :timeout => timeout)
  end
  sleep 0.5
end

def restart_router
  stop_router
  start_router :force => true
end

# Prepares test stand by copying P2 files to /tmp
def prepare_test_stand
  FileUtils.rm_rf TMP_DIR
  FileUtils.cp_r SOURCE_DIR, TEST_DIR #TMP_DIR
end

prepare_test_stand
#FileUtils.cd "#{TEST_DIR}"
