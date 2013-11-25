module PTLog::Wrappers
  class ChangeLog
    attr_reader :git, :tags

    def initialize
      @git ||= ::Git.open(Dir.getwd)
      @start = ENV['PTLOG_SINCE'] || git.lib.ordered_tags[-1]
      @tags = PTLog::TagList.new(@git, @start)
    end

    def title
      "Change Log @ #{Time.new.utc.strftime('%I:%M%P %D UTC')}"
    end

    def releases
      @tags.map do |tag|
        PTLog::Wrappers::Release.new(tag, self)
      end
    end
  end
end
