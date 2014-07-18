# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'changelog/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-changelog"
  spec.version       = Changelog::VERSION
  spec.authors       = ["Dmitry Larkin"]
  spec.email         = ["dmitry.larkin@gmail.com"]
  spec.description   = %q{Uses git commits to recognize tracker stories and generates ChangeLog.}
  spec.summary       = %q{Uses git commits to recognize tracker stories and generates ChangeLog.}
  spec.homepage      = "https://github.com/dml/capistrano-changelog"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency     "git", "~> 1.2.6"
  spec.add_runtime_dependency     "capistrano", "~> 2.0"
  spec.add_runtime_dependency     "faraday", "~> 0.8"
  spec.add_runtime_dependency     "faraday_middleware", "~> 0.9"
  spec.add_runtime_dependency     "capistrano", "< 3.0"
end
