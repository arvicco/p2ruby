require 'p2ruby'
require 'pathname'

require 'bundler'
Bundler.setup
Bundler.require :test

BASE_PATH = Pathname.new(__FILE__).dirname + '..'
p INI_PATH = (BASE_PATH + 'spec/files/P2ClientGate.ini').realpath

RSpec.configure do |config|
  # config.exclusion_filter = { :slow => true }
  # config.filter = { :focus => true }
  # config.include(UserExampleHelpers)
end