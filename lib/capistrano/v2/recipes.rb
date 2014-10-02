require 'capistrano-changelog'

Capistrano::Configuration.instance(:must_exist).load do
  # CapistranoChangelog.load_into(self)

  _cset(:changelog_tracker)           { :pivotal }
  _cset(:changelog_cache_local_file)  { 'tmp/changelog.json' }
  _cset(:changelog_cache_remote_file) { File.join(shared_path, 'changelog.json') }
  _cset(:changelog)                   { File.join(shared_path, 'changelog.html') }
  _cset(:changelog_version)           { File.join(shared_path, 'version.json') }
  _cset(:changelog_date_format)       { '%I:%M%P %D UTC' }

  namespace :deploy do
    namespace :changelog do
      task :download_cache, roles: :changelog, only: {cache: true}, on_no_matching_servers: :continue do
        begin
          get fetch(:changelog_cache_remote_file), fetch(:changelog_cache_local_file)
        rescue Capistrano::TransferError => e
          logger.info "Changelog cache file does not exists."
        end
      end

      task :upload_cache, roles: :changelog, only: {cache: true}, on_no_matching_servers: :continue do
        put IO.read(fetch(:changelog_cache_local_file)), fetch(:changelog_cache_remote_file)
      end

      desc "Generates changelog"
      task :default, roles: :changelog do
        begin
          history = CapistranoChangelog::History.new({
                      changelog_cache_local_file: fetch(:changelog_cache_local_file),
                      logger: logger
                    })
        rescue CapistranoChangelog::GeneralError => e
          logger.error e.message
        end

        put history.generate, fetch(:changelog)
      end

      desc "Generates version file. RESTART=(true|false) option could be specified (by default is true)"
      task :version, roles: :changelog, only: {version: true}, on_no_matching_servers: :continue do
        put CapistranoChangelog::Version.generate, fetch(:changelog_version), mkdir: true
      end
    end
  end
end
