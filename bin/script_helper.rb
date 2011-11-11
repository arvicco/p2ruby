#!/usr/bin/env ruby
require 'bundler'
Bundler.setup

require 'pathname'
require 'fileutils'

BASE_DIR = (Pathname.new(__FILE__).dirname + '..').realpath.to_s
#BASE_DIR = File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), '..'))
SOURCE_DIR = BASE_DIR + '/p2/'
TMP_DIR = BASE_DIR + '/tmp/'
TEST_DIR = BASE_DIR + '/tmp/p2/'
CONFIG_DIR = BASE_DIR + '/config/'
INI_DIR = BASE_DIR + '/config/ini/'
DATA_DIR = BASE_DIR + '/data/' # For saving incoming (replication) data
LIB_DIR = BASE_DIR + '/lib/'

$LOAD_PATH.unshift LIB_DIR unless $LOAD_PATH.include?(LIB_DIR)

CLIENT_INI = INI_DIR + 'P2ClientGate.ini'
MESSAGE_INI = INI_DIR + 'p2fortsgate_messages.ini'
TABLESET_INI = INI_DIR + 'rts_index.ini'
ROUTER_INI = INI_DIR + 'client_router.ini'
ROUTER_PATH = TEST_DIR + 'p2bin/P2MQRouter.exe'
ROUTER_TITLE = /P2MQRouter - /

def prepare_dirs
  # First we need to prepare clean copy of P2 stand by copying P2 files to /tmp
  FileUtils.rm_rf TMP_DIR
  FileUtils.cp_r SOURCE_DIR, TEST_DIR

  # Create temp dirs unless they aready exist
  FileUtils.mkdir DATA_DIR unless File.exist? DATA_DIR
end

# Starts Router, yields to given block (if any)
def start_router opts ={}
  # Make sure p2ruby gem WAS indeed required...
  require 'p2ruby' unless defined? P2

  # Find any working router if no opts given
  router = opts.empty? ? P2::Router.find : nil

  unless router # is already found
    prepare_dirs
    router = P2::Router.new :dir => opts[:dir] || TEST_DIR,
                            :path => opts[:path] || ROUTER_PATH,
                            :ini => opts[:ini] || ROUTER_INI,
                            :args => opts[:args], # usually, it's just /ini:,
                            :title => opts[:title] || ROUTER_TITLE,
                            :timeout => opts[:timeout] || 5

    puts "Router started at #{ROUTER_PATH}, establishing uplink..."
    sleep 0.7
  end

  if block_given?
    yield router
  else
    router
  end

rescue => e
  puts "Caught in start_router: #{e}"
  raise e
end
