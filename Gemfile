source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gemspec

gem 'facter', ENV.fetch('FACTER_GEM_VERSION', nil), require: false

group :test do
  gem 'json_schemer'
end

group :development do
  gem 'faraday-retry', require: false
  gem 'github_changelog_generator', '>= 1.16.4', require: false
  gem 'redcarpet'
  gem 'yard'
end
