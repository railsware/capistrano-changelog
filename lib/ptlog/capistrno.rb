require 'ptlog'

Capistrano::Configuration.instance(:must_exist).load do
  namespace :ptlog do
    desc "Generates changelog"
    task :changes do
      put PTLog::ChangeLog.generate, "#{current_path}/public/changelog.html"
    end

    desc "Generates release file. RESTART=(true|false) option could be specified (by default is true)"
    task :release do
      put PTLog::Release.generate, "#{release_path}/version.json"
    end
  end
end
