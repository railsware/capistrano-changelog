require "ptlog/version"
require "ptlog/capistrano"

module PTLog
  autoload :Release, "ptlog/release"
  autoload :ChangeLog, "ptlog/change_log"
end
