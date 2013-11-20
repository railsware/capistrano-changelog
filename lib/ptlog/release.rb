require 'git'

module PTLog
  class Release
    def self.generate
      JSON.dump({
        restart: ( ENV.fetch('RESTART', 'true') == 'true' ),
        version: (`git describe --always`).strip,
        ts: Time.now.to_i
      })
    end
  end
end
