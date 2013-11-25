require "ptlog/version"
require "git"


module PTLog
  class GeneralError < StandardError; end

  module Pivotal
    class NetworkError < StandardError; end

    autoload :Story, "ptlog/pivotal/story"
    autoload :API, "ptlog/pivotal/api"
  end

  module Git
    autoload :Lib, "ptlog/git/lib"
  end

  module Wrappers
    autoload :ChangeLog,  "ptlog/wrappers/changelog"
    autoload :Release,    "ptlog/wrappers/release"
  end

  autoload :Release,    "ptlog/release"
  autoload :ChangeLog,  "ptlog/change_log"
  autoload :TagList,    "ptlog/git/tags_list"

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.templates
    File.join root, 'templates'
  end
end

Git::Lib.send :include, PTLog::Git::Lib

