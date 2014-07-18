require 'capistrano-changelog'

Capistrano::Configuration.instance(:must_exist).load do
  namespace :deploy do
    desc "Generates changelog"
    task :changelog do
      put CapistranoChangelog::ChangeLog.generate, "#{current_path}/public/changelog.html"
    end

    desc "Generates version file. RESTART=(true|false) option could be specified (by default is true)"
    task :version do
      put CapistranoChangelog::Release.generate, "#{release_path}/version.json"
    end
  end
end
