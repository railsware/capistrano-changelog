require "git"

module CapistranoChangelog
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
    autoload :Changelog,  "changelog/wrappers/changelog"
    autoload :Release,    "changelog/wrappers/release"
  end

  autoload :Release,    "changelog/release"
  autoload :Changelog,  "changelog/changelog"
  autoload :TagList,    "changelog/git/tags_list"

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.templates
    File.join root, 'templates'
  end
end

# Git::Lib.send :include, Changelog::Git::Lib
