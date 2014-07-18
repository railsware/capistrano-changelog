module Changelog::Wrappers
  class Release
    def initialize(tag, changelog)
      @tag = tag
      @initial_commit = changelog.tags.prev_to(tag)
      @git = changelog.git
      @commit = @git.gcommit(tag)
    end

    def title
      @tag
    end

    def date
      @commit.date.utc.strftime('%I:%M%P %D UTC')
    end

    def stories
      ids = @git.log.between(@initial_commit, @tag).map do |commit|
        commit.message.scan(/\#(\d+)/)
      end
      ids.flatten.uniq.map{ |num| Changelog::Pivotal::Story.get(num) }
    end

    def commits(num)
      @git.log.between(@initial_commit, @tag).select do |commit|
        commit.message =~ (/\##{num}/)
      end
    end

    def get_binding
      binding
    end
  end
end
