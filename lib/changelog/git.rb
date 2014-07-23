require 'csv'

module Changelog
  module Git
    extend self

    CMD_VERSION       = "describe --always"
    CMD_FIRST_COMMIT  = "rev-list --max-parents=0 HEAD"

    CMD_TAGS          = "for-each-ref --sort='*authordate' --format='%(objectname)%09%(tag)%09%(*authordate:iso8601)' refs/tags"
    CMD_TAGS_HEADERS  = [ :commit, :title, :datetime ]



    def describe
      run(CMD_VERSION)
    end

    def first_commit
      run(CMD_FIRST_COMMIT)
    end

    def tags
      CSV.parse(run(CMD_TAGS), col_sep: "\t").to_a.map do |a|
        Hash[ CMD_TAGS_HEADERS.zip(a) ]
      end
    end

    def run(cmd)
      (`git #{cmd}`).strip
    end

  end
end
