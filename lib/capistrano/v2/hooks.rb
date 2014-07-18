require "capistrano/v2/recipes"

Capistrano::Configuration.instance(:must_exist).load do
  # Generate ChangeLog file
  before "deploy:finalize_update", "deploy:changelog"

  # Generage version.json file
  before "deploy:finalize_update", "deploy:version"
end
