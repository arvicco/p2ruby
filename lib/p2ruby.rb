require 'version'
require 'win32ole'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

# Namespace for loading P2ClientGate constants
module P2ClientGate
  P2ERR_OK = P2MQ_ERRORCLASS_OK = P2ERR_COMMON_BEGIN = 0x0000
  P2MQ_ERRORCLASS_IS_USELESS = 0x0001
end

# Shorthand for P2ClientGate
P2 = P2ClientGate

module P2Ruby
  # Any P2Ruby-specific Error
  class Error < StandardError
  end

  # Allows extended manipulation of all P2Ruby-specific exceptions (Error aspect)
  def error *args
    if args.first.is_a? Exception
      raise args.first
    else
      raise P2Ruby::Error.new *args
    end
  end
end

require 'p2ruby/router'
require 'p2ruby/library'
require 'p2ruby/p2class'
require 'p2ruby/application'
require 'p2ruby/connection'
require 'p2ruby/message_factory'
