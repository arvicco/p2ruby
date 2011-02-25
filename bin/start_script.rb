#!/usr/bin/env ruby
# encoding: Windows-1251

require 'pathname'
lib = (Pathname.new(__FILE__).dirname + '../lib').expand_path.to_s
$:.unshift lib unless $:.include?(lib)
require 'p2ruby'

ROUTER_INI = Dir["../../spec/**/client_router.ini"].first
ROUTER_PATH = Dir["**/P2MQRouter.exe"].first

# First we need to cd into p2 main dir ??

# Start Router, yield to given block (if any)
def start_router
  router = P2Ruby::Router.new :path => ROUTER_PATH, :ini => ROUTER_INI

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
