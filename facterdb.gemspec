# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "facterdb/version"

Gem::Specification.new do |s|
  s.name        = "facterdb"
  s.version     = FacterDB::Version::STRING
  s.authors     = ["Mickaël Canévet"]
  s.email       = ["mickael.canevet@camptocamp.com"]
  s.homepage    = "http://github.com/camptocamp/facterdb"
  s.summary     = "A Database of OS facts provided by Facter"
  s.description = "Contains facts from many Facter version on many Operating Systems"
  s.licenses    = 'Apache-2.0'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'github_changelog_generator', '~> 1.10', '< 1.10.4'
  s.add_runtime_dependency 'facter', '< 4.0.0'
  s.add_runtime_dependency 'jgrep'
end
