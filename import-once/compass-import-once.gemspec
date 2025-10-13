# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'compass/import-once/version'

Gem::Specification.new do |spec|
  spec.name          = "compass-import-once-sass37"
  spec.version       = Compass::ImportOnce::VERSION
  spec.authors       = ["Vladimir Ivanin", "Chris Eppstein"]
  spec.email         = ["ivaninww@gmail.com"]
  spec.description   = %q{Changes the behavior of Sass's @import directive to only import a file once. Updated for Sass 3.7 compatibility.}
  spec.summary       = %q{Speed up your Sass compilation by making @import only import each file once (Sass 3.7 compatible)}
  spec.homepage      = "https://github.com/VladimirIvanin/compass"
  spec.license       = "MIT"

  spec.files         = `git ls-files #{File.dirname(__FILE__)}`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sass", ">= 3.7", "< 3.8"
  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "diff-lcs"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sass-globbing"
end
