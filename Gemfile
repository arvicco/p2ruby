# For more information on bundler, please visit http://gembundler.com
# Library dependencies in this Gemfile are managed through the gemspec.
# Development dependencies are managed here, don't add them to gemspec.
source :gemcutter
gemspec

group :cucumber do
  gem 'cucumber'
  gem 'rspec', '>=2.5.0', :require => ['rspec/expectations', 'rspec/stubs/cucumber']
end

group :test do # Group for testing code on Windows (win, win_gui)
  gem 'rspec', '>=2.5.0', :require => ['rspec', 'rspec/autorun']
end

