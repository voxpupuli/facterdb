source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gemspec

gem 'facter', ENV.fetch('FACTER_GEM_VERSION', nil), require: false

group :development do
  gem 'faraday-retry', require: false
  gem 'github_changelog_generator', '>= 1.16.4', require: false
end
