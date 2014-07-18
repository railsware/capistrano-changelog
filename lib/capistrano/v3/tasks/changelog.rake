namespace :deploy do
  desc "Generates changelog"
  task :changelog do
    raise 'Capistrano 3.x does not supported yet'
  end

  desc "Generates version file. RESTART=(true|false) option could be specified (by default is true)"
  task :version do
    raise 'Capistrano 3.x does not supported yet'
  end

  before "deploy:finalize_update", "deploy:changelog"
  before "deploy:finalize_update", "deploy:version"
end

namespace :load do
  task :defaults do
    set(:changelog_tracker)         ->{ :pivotal }
    set(:changelog_options)         ->{ {} }
    set(:changelog_cache)           ->{ false }
    set(:changelog_output)          ->{ File.join(release_path, 'public', 'changelog.html') }
    set(:changelog_pivotal_token)   ->{ fetch(:pivotal_token) }
  end
end
