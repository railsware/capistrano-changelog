require "ptlog/version"

module PTLog
  class GeneralError < StandardError; end

  module Pivotal
    class NetworkError < StandardError; end

    autoload :Story, "ptlog/pivotal/story"
    autoload :API, "ptlog/pivotal/api"
  end

  autoload :Release, "ptlog/release"
  autoload :ChangeLog, "ptlog/change_log"
end
