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

  s.files       = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  # we have that configured in our CI file
  s.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

  s.add_development_dependency 'voxpupuli-rubocop', '~> 2.4.0'
  s.add_runtime_dependency 'facter', '< 5.0.0'
  s.add_runtime_dependency 'jgrep'
end
