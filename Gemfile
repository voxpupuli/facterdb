source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gemspec

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

group :development do
  gem 'github_changelog_generator', '>= 1.16.4'
  gem 'yard'
  gem 'redcarpet'
end
