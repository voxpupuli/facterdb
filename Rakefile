begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

require 'github_changelog_generator/task'
require 'facterdb/version'
GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.future_release = FacterDB::Version::STRING
  config.release_url = "https://rubygems.org/gems/facterdb/versions/%s"
end
