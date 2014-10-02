require "capistrano/v2/recipes"

Capistrano::Configuration.instance(:must_exist).load do
  # Generate ChangeLog file
  after "deploy:create_symlink", "deploy:changelog"

  # Generage version.json file
  after "deploy:create_symlink", "deploy:changelog:version"

  before "deploy:changelog", "deploy:changelog:download_cache"
  after  "deploy:changelog", "deploy:changelog:upload_cache"
end
