require 'facterdb/version'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

begin
  require 'github_changelog_generator/task'
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.future_release = FacterDB::Version::STRING
    config.include_labels = %w[enhancement bug]
    config.user = 'camptocamp'
    config.release_url = "https://rubygems.org/gems/facterdb/versions/%s"
    config.since_tag = '0.3.11'
  end
rescue LoadError
  desc 'Install github_changelog_generator to get access to automatic changelog generation'
  task :changelog do
    raise 'Install github_changelog_generator to get access to automatic changelog generation'
  end
end
