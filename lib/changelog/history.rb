require 'erb'
require 'ostruct'

module CapistranoChangelog
  class History
    def self.generate
      context = CapistranoChangelog::Context.new
      template = ERB.new IO.read(File.join(CapistranoChangelog.templates, 'changelog.erb'))
      template.result(context.get_binding)
    end
  end
end
