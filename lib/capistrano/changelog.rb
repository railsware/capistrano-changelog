require 'capistrano/version'

if defined?(Capistrano::VERSION) && Gem::Version.new(Capistrano::VERSION).release >= Gem::Version.new('3.0.0')
  load File.expand_path("../tasks/changelog.rake", __FILE__)
else
  require 'capistrano/v2/hooks'
end
