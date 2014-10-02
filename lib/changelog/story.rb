module CapistranoChangelog
  Story = Struct.new(:uid, :history, :commits_collection) do
    def title
      history.cache.fetch(uid, nil) || history.cache.fetch(uid.to_s, nil)
    end

    def error
      'Story has no description'
    end

    def valid?
      history.cache.has_key?(uid) || history.cache.has_key?(uid.to_s)
    end

    def commits
      commits_collection.select do |commit|
        commit.comment =~ (/\##{uid}/)
      end
    end

    def url
      "https://www.pivotaltracker.com/story/show/#{uid}"
    end

    def to_s
      "#{uid}: #{title}"
    end
  end
end
