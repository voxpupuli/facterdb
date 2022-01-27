source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gemspec

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

group :development do
  gem 'github_changelog_generator', '>= 1.16.4'
  # provides the rubocop config and an awesome circular dependency to boot!
  gem 'voxpupuli-test', '~> 5.2'
end
