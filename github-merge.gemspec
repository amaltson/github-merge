# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_merge'

Gem::Specification.new do |spec|
  spec.name          = "github-merge"
  spec.version       = Merge::VERSION
  spec.authors       = ["Arthur Maltson"]
  spec.email         = ["arthur.kalm@gmail.com"]
  spec.description   = %q{Script that merges multiple GitHub repositories into a new, single repository.}
  spec.summary       = %q{Split your project into lots of small Git repos and finding yourself creating cross repo Pull Requests? This is the gem for you.}
  spec.homepage      = "https://github.com/amaltson/github-merge"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "github_api", "~>0.9.4"
  spec.add_dependency "thor", "~>0.18.1"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
