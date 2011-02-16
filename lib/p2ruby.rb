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

require 'p2ruby/library'
require 'p2ruby/p2class'
require 'p2ruby/application'
require 'p2ruby/connection'
