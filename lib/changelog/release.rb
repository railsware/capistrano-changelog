require 'time'

module CapistranoChangelog
  class Release
    attr_reader :tag

    def initialize(tag)
      @tag = tag
    end

    def <=> (other)
      self.date <=> other.date
    end

    def method_missing(meth, *args)
      if tag.respond_to?(meth)
        tag.send(meth, *args)
      else
        super
      end
    end

    def stories(history)
      commits = CapistranoChangelog::Git.commits history.prev_to(self), self

      CapistranoChangelog::StoriesTracker.new.ids(commits).map do |uid|
        CapistranoChangelog::Story.new(uid, history, commits)
      end
    end

    def unreconized(history)
      CapistranoChangelog::Git.commits(history.prev_to(self), self).select do |commit|
        commit.comment !~ Trackers::Pivotal::MATCHER
      end
    end

    def unreconized?(history)
      unreconized(history).size > 0
    end

    def self.all
      CapistranoChangelog::Git.tags.map do |tag|
        CapistranoChangelog::Release.new(tag)
      end
    end
  end
end
