# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ptlog/version'

Gem::Specification.new do |spec|
  spec.name          = "ptlog"
  spec.version       = PTLog::VERSION
  spec.authors       = ["Dmitry Larkin"]
  spec.email         = ["dmitry.larkin@gmail.com"]
  spec.description   = %q{Generages changelog based on PivotalTracker stories and Git commits}
  spec.summary       = %q{Generages changelog based on PivotalTracker stories and Git commits}
  spec.homepage      = "https://github.com/dml/ptlog"
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
end
