require 'json'
require 'changelog/git'

module CapistranoChangelog
  class Version
    def self.generate
      JSON.dump({
        restart: ( ENV.fetch('RESTART', 'true') == 'true' ),
        version: CapistranoChangelog::Git.describe,
        ts: Time.now.to_i
      })
    end
  end
end
