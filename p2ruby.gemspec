# Gemspecs should not be generated, but edited directly.
# Refer to: http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended/

Gem::Specification.new do |gem|
  gem.name = "p2ruby"
  gem.version = File.open('VERSION').read.strip # = ::P2::VERSION # - conflicts with Bundler
  gem.summary = "Ruby bindings for P2ClientGate"
  gem.description = "Ruby bindings and wrapper classes for P2ClientGate"
  gem.authors = ["arvicco"]
  gem.email = "arvitallian@gmail.com"
  gem.homepage = "http://github.com/arvicco/p2ruby"
  gem.platform = Gem::Platform::RUBY
  gem.date = Time.now.strftime "%Y-%m-%d"

  # Files setup
  versioned = `git ls-files -z`.split("\0")
  gem.files = Dir['{bin,lib,man,spec,features,tasks}/**/*', 'Rakefile', 'README*', 'LICENSE*',
                  'VERSION*', 'CHANGELOG*', 'HISTORY*', 'ROADMAP*', '.gitignore'] & versioned
  gem.executables = (Dir['bin/**/*'] & versioned).map { |file| File.basename(file) }
  gem.test_files = Dir['spec/**/*'] & versioned
  gem.require_paths = ["lib"]

  # RDoc setup
  gem.has_rdoc = true
  gem.rdoc_options.concat %W{--charset UTF-8 --main README.rdoc --title p2ruby}
  gem.extra_rdoc_files = ["LICENSE", "HISTORY", "README.rdoc"]

  # Dependencies (dev dependencies managed in Gemfile)
  gem.add_dependency("bundler", [">= 1.0.0"])
  gem.add_dependency("win_gui", [">=0.2.21"])
end
