require 'version'
require 'win32ole'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

# Namespace for loading P2ClientGate constants
module P2ClientGate
end

# Shorthand for P2ClientGate
P2 = P2ClientGate

require 'p2ruby/library'
require 'p2ruby/application'
require 'p2ruby/connection'
