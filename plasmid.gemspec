# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plasmid/version'

Gem::Specification.new do |spec|
  spec.name          = "plasmid"
  spec.version       = Plasmid::VERSION
  spec.authors       = ["Ben Merritt"]
  spec.email         = ["blm768@gmail.com"]

  spec.summary       = %q{A simple CM system}
  spec.description   = %q{A configuration management system designed for simplicity and modularity}
  spec.homepage      = "https://github.com/blm768/plasmid"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sequel", "~> 4.37.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
