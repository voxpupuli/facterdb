source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gemspec

group :release, optional: true do
  gem 'faraday-retry', '~> 2.1', require: false
  gem 'github_changelog_generator', '~> 1.18', require: false
end

# required to generate the github pages
gem 'yard', '~> 0.9.43'
