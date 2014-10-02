module CapistranoChangelog
  class StoriesTracker
    attr_reader :stories

    def fetch(commits, cache, options)
      ids_to_fetch = ids(commits) - cache.keys

      return if ids_to_fetch.empty?

      log = ->(msg){ options[:logger].send(:info, msg) if options[:logger] }

      chunks = ids_to_fetch.each_slice(100).to_a.map do |chunk|
        begin
          log.call("Changelog: fetching chunk of stories: #{chunk.size}")
          source.export(chunk)
        rescue Trackers::BatchError => e
          log.call("Changelog: got an export error")
          log.call(e.message)

          chunk.map do |uid|
            log.call("Changelog: Fetching single story: #{uid}")
            source.get(uid)
          end
        end
      end

      cache.merge! Hash[chunks.inject(:+)]
    end

    def source
      @source ||= Trackers::Pivotal.new
    end

    def ids(commits)
      @ids ||= commits.map{ |commit| commit.comment.scan(Trackers::Pivotal::MATCHER) }.flatten.compact.map(&:to_i).uniq
    end

  end
end
