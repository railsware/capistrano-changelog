module CapistranoChangelog
  class GeneralError < StandardError; end

  module Trackers
    class Trackers::NetworkError < StandardError; end
    class Trackers::ConfigError < StandardError; end
    class Trackers::AccessDenied < StandardError; end
    class Trackers::BatchError < StandardError; end

    autoload :Pivotal,        "changelog/trackers/pivotal"
  end

  autoload :Version,          "changelog/version"
  autoload :Release,          "changelog/release"
  autoload :Story,            "changelog/story"
  autoload :History,          "changelog/history"
  autoload :Git,              "changelog/git"
  autoload :StoriesTracker,   "changelog/stories_tracker"

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.templates
    File.join root, 'templates'
  end

  def self.pivotal_tracker
    ENV['PIVOTAL_TOKEN'] or raise CapistranoChangelog::GeneralError, "Pivotal Tracker access token missed. Run $ export PIVOTAL_TOKEN='you-access-token'."
  end
end
