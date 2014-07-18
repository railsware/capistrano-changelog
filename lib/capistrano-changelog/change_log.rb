require 'erb'

module CapistranoChangelog
  class Controller
    def initialize
      @changelog = CapistranoChangelog::Wrappers::ChangeLog.new
    end
    def get_binding
      binding
    end
  end

  class ChangeLog
    def self.generate
      raise GeneralError, "You have to specify Pivotal token with export PIVOTAL_TOKEN=xyz" unless ENV.has_key?('PIVOTAL_TOKEN')

      controller = CapistranoChangelog::Controller.new
      template = ERB.new IO.read(File.join(CapistranoChangelog.templates, 'changelog.erb'))
      template.result(controller.get_binding)
    end
  end
end
