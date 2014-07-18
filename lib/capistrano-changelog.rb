require "capistrano-changelog/version"
require "git"


module CapistranoChangelog
  class GeneralError < StandardError; end

  module Pivotal
    class NetworkError < StandardError; end

    autoload :Story, "capistrano-changelog/pivotal/story"
    autoload :API, "capistrano-changelog/pivotal/api"
  end

  module Git
    autoload :Lib, "capistrano-changelog/git/lib"
  end

  module Wrappers
    autoload :ChangeLog,  "capistrano-changelog/wrappers/changelog"
    autoload :Release,    "capistrano-changelog/wrappers/release"
  end

  autoload :Release,    "capistrano-changelog/release"
  autoload :ChangeLog,  "capistrano-changelog/change_log"
  autoload :TagList,    "capistrano-changelog/git/tags_list"

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.templates
    File.join root, 'templates'
  end
end

Git::Lib.send :include, CapistranoChangelog::Git::Lib
