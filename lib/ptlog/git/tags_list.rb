module PTLog
  class TagList
    include Enumerable

    def initialize(git, since)
      @list = git.lib.ordered_tags + ['HEAD']
      @since = since
      @first_commit = git.lib.first_commit
    end

    def each(options = {})
      list_after_item = @list[@list.index(@since), @list.size]

      if block_given?
        list_after_item.reverse.each { |e| yield(e) }
      else
        Enumerator.new(list_after_item.reverse, :each)
      end
    end

    def next_to(name)
      @list[@list.index(name) + 1] || 'HEAD'
    end

    def prev_to(name)
      0 < @list.index(name) && @list[@list.index(name) - 1] or @first_commit
    end
  end
end
