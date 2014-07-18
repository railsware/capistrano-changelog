require "changelog/version"
require "git"

module Changelog
  class GeneralError < StandardError; end

  module Pivotal
    class NetworkError < StandardError; end

    autoload :Story, "changelog/pivotal/story"
    autoload :API, "changelog/pivotal/api"
  end

  module Git
    autoload :Lib, "changelog/git/lib"
  end

  module Wrappers
    autoload :ChangeLog,  "changelog/wrappers/changelog"
    autoload :Release,    "changelog/wrappers/release"
  end

  autoload :Release,    "changelog/release"
  autoload :ChangeLog,  "changelog/change_log"
  autoload :TagList,    "changelog/git/tags_list"

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.templates
    File.join root, 'templates'
  end
end

Git::Lib.send :include, Changelog::Git::Lib

if defined?(Capistrano::VERSION) && Gem::Version.new(Capistrano::VERSION).release >= Gem::Version.new('3.0.0')
  load File.expand_path("../tasks/changelog.rake", __FILE__)
else
  require 'capistrano/v2/hooks'
end
