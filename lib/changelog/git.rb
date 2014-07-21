module Changelog
  class Git
    def self.describe
      (`git describe --always`).strip
    end
  end
end