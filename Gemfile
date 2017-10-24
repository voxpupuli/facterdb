source ENV['GEM_SOURCE'] || "https://rubygems.org"

gemspec

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

group :development do
  # TODO: Use gem instead of git. Section mapping is merged into master, but not yet released
  gem 'github_changelog_generator', git: 'https://github.com/skywinder/github-changelog-generator.git', ref: '33f89614d47a4bca1a3ae02bdcc37edd0b012e86'
end
