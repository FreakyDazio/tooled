# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tooled/version'

Gem::Specification.new do |spec|
  spec.name          = "tooled"
  spec.version       = Tooled::VERSION
  spec.authors       = ["Darren Coxall"]
  spec.email         = ["darren@darrencoxall.com"]
  spec.description   = %q{A simple collection of classes to help avoid over-using Hash}
  spec.summary       = %q{A simple collection of classes to help avoid over-using Hash}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
