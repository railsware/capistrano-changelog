require "bundler/gem_tasks"
require 'bundler'
require "rspec/core/rake_task"

Bundler::GemHelper.install_tasks

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.ruby_opts = %w[-w]
end

task :default => [:spec]
