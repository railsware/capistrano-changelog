require 'csv'

module CapistranoChangelog
  module Git
    extend self

    class Commit < OpenStruct
      def date
        Time.parse(self.datetime).utc
      rescue TypeError => e
        nil
      end

      def <=> (other)
        self.date <=> other.date
      end

      def short
        self.commit.slice(0,7)
      end

      def to_s
        self.comment
      end
    end

    CMD_VERSION       = "describe --always"
    CMD_FIRST_COMMIT  = "rev-list --max-parents=0 HEAD"

    CMD_TAGS          = "for-each-ref --sort='*authordate' --format='%(objectname)%09%(*authordate:iso8601)%09%(tag)' refs/tags"
    CMD_TAGS_HEADERS  = [ :commit, :datetime, :comment ]

    CMD_LOG           = "log --date=iso8601 --pretty=format:'%H%x09%cd%x09%s' --no-merges "
    CMD_LOG_HEADERS   = [ :commit, :datetime, :comment ]

    def describe
      run(CMD_VERSION)
    end

    def first_commit
      csv_to_commits(run(CMD_LOG + run(CMD_FIRST_COMMIT)), CMD_LOG_HEADERS).first
    end

    def last_commit
      csv_to_commits(run(CMD_LOG + 'HEAD^..HEAD'), CMD_LOG_HEADERS).first.tap{ |c| c.comment = 'HEAD' }
    end

    def releases
      csv_to_commits(run(CMD_TAGS), CMD_TAGS_HEADERS)
    end

    def tags
      releases.push(last_commit)
    end

    def commits(predecessor, successor)
      return Array.new if (successor <=> predecessor) < 1

      csv_to_commits run(CMD_LOG + " %s..%s" % [predecessor.commit, successor.commit]), CMD_LOG_HEADERS
    end

    def run(cmd)
      (`git #{cmd}`).strip
    end

    def csv_to_commits(csv, headers)
      CSV.parse(csv.gsub(/\"/, ''), col_sep: "\t").to_a.map do |a|
        Commit.new Hash[ headers.zip(a) ]
      end
    end
  end
end
