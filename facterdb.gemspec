$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'facterdb/version'

Gem::Specification.new do |s|
  s.name        = 'facterdb'
  s.version     = FacterDB::Version::STRING
  s.authors     = ['Vox Pupuli']
  s.email       = ['voxpupuli@groups.io']
  s.homepage    = 'http://github.com/voxpupuli/facterdb'
  s.summary     = 'A Database of OS facts provided by Facter'
  s.description = 'Contains facts from many Facter version on many Operating Systems'
  s.licenses    = 'Apache-2.0'

  s.files       = `git ls-files`.split("\n") + Dir['database/*']
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  # we have that configured in our CI file
  s.required_ruby_version = Gem::Requirement.new('>= 3.2.0')

  s.add_development_dependency 'coveralls', '~> 0.8.23'
  s.add_development_dependency 'rake', '~> 13.2', '>= 13.2.1'
  s.add_development_dependency 'rspec', '~> 3.13'

  s.add_development_dependency 'voxpupuli-rubocop', '~> 3.1.0'
  s.add_dependency 'jgrep', '~> 1.5', '>= 1.5.4'
end
