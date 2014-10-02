require 'erb'
require 'ostruct'
require 'oj'
require 'fileutils'

module CapistranoChangelog
  class Context < OpenStruct
    def format(dt)
      dt.strftime('%I:%M%P %D UTC') if dt.kind_of?(Time)
    end
  end

  class History
    attr_reader :releases, :cache, :options

    def initialize(params = {})
      @first_commit = CapistranoChangelog::Git.first_commit
      @last_commit  = CapistranoChangelog::Git.last_commit
      @releases     = CapistranoChangelog::Release.all
      @tracker      = CapistranoChangelog::StoriesTracker.new
      @cache        = {}
      @options = {
        changelog_cache_local_file: nil,
        changelog_cache: false,
        logger: false
      }.merge(params)
    end

    def store_cache(filename)
      return unless filename

      dir = File.dirname(filename)
      FileUtils.mkdir_p(dir) unless File.exists?(dir)
      File.open(filename, 'w+') do |f|
        f << Oj.dump(cache)
      end
    end

    def read_cache(filename)
      return unless filename and File.exists?(filename)

      @cache = ( Oj.load(IO.read(filename)) || {} ) if File.exists?(filename)
    rescue Oj::ParseError => e
      File.unlink(filename) if File.exists?(filename)

      return {}
    end

    def udpate_cache
      read_cache options.fetch(:changelog_cache_local_file)

      @tracker.fetch CapistranoChangelog::Git.commits(@first_commit, @last_commit), cache, options

      store_cache options.fetch(:changelog_cache_local_file)
    end

    def next_to(release)
      if idx = releases.index(release) and releases[idx + 1]
        releases[idx + 1]
      else
        @last_commit
      end
    end

    def prev_to(release)
      if idx = releases.index(release) and idx > 0 and releases[idx - 1]
        releases[idx - 1]
      else
        @first_commit
      end
    end

    def generate
      udpate_cache

      context = Context.new({
        date: Time.new.utc,
        history: self,
        releases: releases.reverse
      })

      template = ERB.new IO.read(File.join(CapistranoChangelog.templates, 'changelog.erb'))
      template.result context.instance_eval { binding }
    end
  end
end
