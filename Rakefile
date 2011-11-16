begin
  require 'rake'
rescue LoadError
  require 'rubygems'
  gem 'rake', '~> 0.8.3.1'
  require 'rake'
end

require 'pathname'

BASE_PATH = Pathname.new(__FILE__).dirname
LIB_PATH = BASE_PATH + 'lib'
PKG_PATH = BASE_PATH + 'pkg'
DOC_PATH = BASE_PATH + 'rdoc'
P2_PATH = BASE_PATH + 'p2'

$LOAD_PATH.unshift LIB_PATH.to_s
require 'version'

NAME = 'p2ruby'
CLASS_NAME = P2

# Load rakefile tasks
Dir['tasks/*.rake'].sort.each { |file| load file }

# Project-specific tasks

namespace :p2 do
  desc "Update p2 (P2ClientGate) submodule to latest Github version"
  task :update do
    cd P2_PATH
    raise 'Submodule p2 dirty!' unless `git status` =~ /nothing to commit .working directory clean/
    sh 'git fetch'
    sh 'git checkout master'
    sh 'git merge origin/master'
    cd BASE_PATH
    sh 'git add p2'
    sh 'git commit -m "SUBMODULE UPDATE: p2"'
    puts 'Check your project ini/schema files: update may be needed!'
  end

  desc "Register P2ClientGate.dll COM/OLE objects with Windows"
  task :register do
    cd P2_PATH
    sh 'regsvr32 P2ClientGate.dll'
    cd BASE_PATH
  end
end
