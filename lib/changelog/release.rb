require 'time'

module CapistranoChangelog
  class Release
    attr_reader :commit, :name, :date

    def initialize(tag)
      @commit, @name = tag.values_at(:commit, :title)
      @date = Time.parse(tag[:datetime])
    end

    def stories
      []
    end
  end
end
