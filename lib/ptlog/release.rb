require 'git'

module PTLog
  class Release
    def self.generate
      JSON.dump({ :restart => ( ENV['RESTART'] || false ), :version => (`git describe --always`).strip })
    end
  end
end
