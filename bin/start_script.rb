#!/usr/bin/env ruby
# encoding: Windows-1251
require 'pathname'
require 'fileutils'

require 'pathname'
lib = (Pathname.new(__FILE__).dirname + '../lib').expand_path.to_s
$:.unshift lib unless $:.include?(lib)
require 'p2ruby'

BASE_DIR = (Pathname.new(__FILE__).dirname + '..').realpath
SOURCE_DIR = BASE_DIR + 'p2/'
TMP_DIR = BASE_DIR + 'tmp/'
TEST_DIR = BASE_DIR + 'tmp/p2/'

CLIENT_INI = BASE_DIR + 'spec/files/P2ClientGate.ini'
MESSAGE_INI = BASE_DIR + 'spec/files/p2fortsgate_messages.ini'
ROUTER_INI = BASE_DIR + 'spec/files/client_router.ini'
ROUTER_PATH = TEST_DIR + 'p2bin/P2MQRouter.exe'
ROUTER_ARGS = "/ini:#{ROUTER_INI}"
ROUTER_TITLE = Regexp.new('P2MQRouter - ') # + ROUTER_LOGIN)

# First we need to prepares clean copy of P2 stand by copying P2 files to /tmp
FileUtils.rm_rf TMP_DIR
FileUtils.cp_r SOURCE_DIR, TEST_DIR

# Start Router, yield to given block (if any)
def start_router opts ={}
  title = opts[:title] || ROUTER_TITLE
  path = opts[:path] || ROUTER_PATH
  dir = opts[:dir] || TEST_DIR
  args = opts[:args] || ROUTER_ARGS
  timeout = opts[:timeout] || 5

  router = WinGui::App.launch(:dir => dir, :path => path, :args => args,
                              :title => title, :timeout => timeout)
#  router = P2Ruby::Router.new :path => ROUTER_PATH, :ini => ROUTER_INI

  sleep 0.3
  puts "Router started at #{ROUTER_PATH}..."

  if block_given?
    begin
      yield
    rescue => e
      raise e
    ensure
      router.exit
    end
  else
    router
  end
end
