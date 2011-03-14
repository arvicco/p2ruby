#!/usr/bin/env ruby
require 'pathname'
require 'fileutils'
require 'win/time'

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
ROUTER_TITLE = /P2MQRouter - /

ADD_ORDER_OPTS = {:name => "FutAddOrder",
                  :field => {
                      "P2_Category" => "FORTS_MSG",
                      "P2_Type" => 1,
                      "isin" => "RTS-3.11",
                      :price => "185500",
                      :amount => 1,
                      "client_code" => "001",
                      "type" => 1,
                      "dir" => 1}}

# First we need to prepares clean copy of P2 stand by copying P2 files to /tmp
FileUtils.rm_rf TMP_DIR
FileUtils.cp_r SOURCE_DIR, TEST_DIR

# Starts Router, yields to given block (if any)
def start_router opts ={}
  timeout = opts[:timeout] || 5
  title = opts[:title] || ROUTER_TITLE
  path = opts[:path] || ROUTER_PATH
  dir = opts[:dir] || TEST_DIR
  ini = opts[:ini] || ROUTER_INI
  args = opts[:args] # usually, it's just /ini:

  router = P2::Router.new(:dir => dir, :path => path, :ini => ini, :args => args,
                          :title => title, :timeout => timeout)
  sleep 0.3
  puts "Router started at #{ROUTER_PATH}..."

  if block_given?
    begin
      yield router
    rescue => e
      raise e
    ensure
      router.exit
    end
  else
    router
  end
end
