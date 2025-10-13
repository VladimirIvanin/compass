# coding: utf-8
lib = File.expand_path('lib', File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'compass/core/version'

Gem::Specification.new do |spec|
  spec.name          = "compass-core-sass37"
  spec.version       = Compass::Core::VERSION
  spec.authors       = ["Vladimir Ivanin", "Chris Eppstein", "Scott Davis", "Eric M. Suzanne", "Brandon Mathis"]
  spec.email         = ["ivaninww@gmail.com"]
  spec.description   = %q{The Compass core stylesheet library with Sass 3.7 support. This library can be used stand-alone without the compass ruby configuration file or compass command line tools. Forked from the original Compass project to maintain compatibility with Sass 3.7.}
  spec.summary       = %q{The Compass core stylesheet library with Sass 3.7 support}
  spec.homepage      = "https://github.com/VladimirIvanin/compass"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).select {|f| File.exist?(f) && f =~ %r{^(data|lib|stylesheets|templates)/} }
  spec.files         += %w(
    VERSION
    LICENSE.txt
  )
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sass", ">= 3.7", "< 3.8"
  spec.add_dependency 'multi_json', '~> 1.0'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
