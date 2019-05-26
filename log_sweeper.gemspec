# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "log_sweeper/version"

Gem::Specification.new do |spec|
  spec.name    = "log_sweeper"
  spec.version = LogSweeper::VERSION
  spec.authors = ["Yuri Smirnov"]
  spec.email   = ["tycooon@yandex.ru", "oss@umbrellio.biz"]

  spec.summary     = "A simple module for cleaning up log directories."
  spec.description = "LogSweeper is a simple module for cleaning up log directories."
  spec.homepage    = "https://github.com/umbrellio/log_sweeper"
  spec.license     = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop-config-umbrellio"
  spec.add_development_dependency "simplecov"
end
