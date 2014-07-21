require 'changelog/version'

Capistrano::Configuration.instance(:must_exist).load do
  # CapistranoChangelog.load_into(self)

  _cset(:changelog_tracker)         { :pivotal }
  _cset(:changelog_options)         { {:roles => fetch(:changelog_roles)} }
  _cset(:changelog_cache)           { false }
  _cset(:changelog_output)          { File.join(release_path, 'public', 'changelog.html') }
  _cset(:changelog_pivotal_token)   { fetch(:pivotal_token) }

  namespace :deploy do
    desc "Generates changelog"
    task :changelog do
      # put Changelog::Changelog.generate, "#{current_path}/public/changelog.html"
      put "test", "#{current_path}/public/changelog.html"
    end

    desc "Generates version file. RESTART=(true|false) option could be specified (by default is true)"
    task :version do
      put CapistranoChangelog::Version.generate, "#{release_path}/version.json"
    end
  end
end
