path = File.expand_path("lib", File.dirname(__FILE__))
$:.unshift(path) unless $:.include?(path)
require 'compass/version'

Gem::Specification.new do |gemspec|
  gemspec.name = "compass-sass37"
  gemspec.version = Compass::VERSION # Update VERSION file to set this.
  gemspec.description = "Compass is a Sass-based Stylesheet Framework that streamlines the creation and maintenance of CSS. This fork maintains compatibility with Sass 3.7."
  gemspec.homepage = "https://github.com/VladimirIvanin/compass"
  gemspec.authors = ["Vladimir Ivanin", "Chris Eppstein", "Scott Davis", "Eric M. Suzanne", "Brandon Mathis", "Nico Hagenburger"]
  gemspec.email = "ivaninww@gmail.com"
  gemspec.executables = %w(compass)
  gemspec.require_paths = %w(lib)
  gemspec.rubygems_version = "1.3.5"
  gemspec.summary = %q{A Real Stylesheet Framework with Sass 3.7 support}

  gemspec.add_dependency 'sass', '>= 3.7', '< 3.8'
  gemspec.add_dependency 'compass-core-sass37', "~> #{File.read(File.join(File.dirname(__FILE__),"..","core","VERSION")).strip}"
  gemspec.add_dependency 'compass-import-once-sass37', "~> #{File.read(File.join(File.dirname(__FILE__),"..","import-once","VERSION")).strip}"
  gemspec.add_dependency 'chunky_png', '~> 1.2'
  gemspec.add_dependency 'rb-fsevent', '>= 0.9.3'
  gemspec.add_dependency 'rb-inotify', '>= 0.9'

  gemspec.post_install_message = <<-MESSAGE
    Compass-Sass37: A maintained fork of Compass with Sass 3.7 support.
    Original Compass is charityware. If you love it, please donate on our behalf at http://umdf.org/compass Thanks!
  MESSAGE

  gemspec.files = %w(LICENSE.markdown VERSION VERSION_NAME Rakefile)
  gemspec.files += Dir.glob("bin/*")
  gemspec.files += Dir.glob("data/**/*")
  gemspec.files += Dir.glob("frameworks/**/*")
  gemspec.files += Dir.glob("lib/**/*")
  gemspec.files += Dir.glob("test/**/*.*")
  gemspec.files -= Dir.glob("test/fixtures/stylesheets/*/saved/**/*.*")
  gemspec.test_files = Dir.glob("test/**/*.*")
  gemspec.test_files -= Dir.glob("test/fixtures/stylesheets/*/saved/**/*.*")
  gemspec.test_files += Dir.glob("features/**/*.*")
end

