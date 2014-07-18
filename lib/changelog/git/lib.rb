module Changelog::Git
  module Lib
    def ordered_tags
      command_lines("for-each-ref --sort='*authordate' --format='%(tag)' refs/tags")
    end
    def first_commit
      command("rev-list --max-parents=0 HEAD")
    end
  end
end
