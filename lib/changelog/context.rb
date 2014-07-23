module CapistranoChangelog
  class Context

    def initialize
      instance_variable_set('@changelog', self)
    end

    def get_binding
      binding
    end

    def date
      Time.new.utc.strftime('%I:%M%P %D UTC')
    end

    def releases
      Changelog::Git.tags.map { |tag| CapistranoChangelog::Release.new(tag) }
    end

  end
end
