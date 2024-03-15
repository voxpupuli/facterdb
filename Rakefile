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
    config.exclude_labels = %w[duplicate question invalid wontfix maintenance github_actions]
    config.user = 'voxpupuli'
    config.project = 'facterdb'
    config.release_url = 'https://rubygems.org/gems/facterdb/versions/%s'
    config.since_tag = '0.3.11'
  end
rescue LoadError
  desc 'Install github_changelog_generator to get access to automatic changelog generation'
  task :changelog do
    raise 'Install github_changelog_generator to get access to automatic changelog generation'
  end
end

# Generate a human-friendly OS label based on a given factset
def factset_to_os_label(fs)
  os_rel  = '???'
  os_name = '????'
  if fs.key?(:os) && fs[:os].key?('release') && (fs[:os]['release']['major'] =~ /\d/)
    os_name = fs[:os]['name']
    fail    = {}
    os      = fs[:os]
    distro = os.fetch('lsb', os.fetch('distro', fail))
    os_id = if distro.key?('id')
              distro['id']
            elsif distro.key?('distid')
              distro['distid']
            else
              '@@@@@@@@@@'
            end
    os_rel  = fs[:os]['release']['major']
    os__rel = fs[:os]['release']['full']
  elsif fs.key? :operatingsystem
    os_name  = fs[:operatingsystem]
    os_id    = fs.fetch(:lsbdistid, '@@@@@@@@@@')
    os_rel   = fs.fetch(:operatingsystemmajrelease, fs.fetch(:lsbmajdistrelease, nil))
    os__rel  = fs.fetch(:lsbdistrelease, fs.fetch(:operatingsystemrelease, '@@@'))
  else
    pp fs
    raise('ERROR: unrecognized facterset format')
  end
  # Sanitize OS names to match the formats used in the facterdb README
  label = "#{os_name} #{os_rel}"
  if /^(Archlinux|Gentoo)$/.match?(os_name)
    label = os_name
  elsif os_name =~ /^(SLES|FreeBSD|OpenSuSE)$/ ||
        (os_name =~ /^(RedHat|Scientific|OracleLinux|CentOS|AlmaLinux)/ && os_rel.nil?)
    label = "#{os_name} #{os__rel.split('.').first}"
  elsif /^(OpenBSD|Ubuntu|Fedora)$/.match?(os_name)
    label = "#{os_name} #{os__rel}"
  elsif /^(Solaris)/.match?(os_name)
    label = if fs.key?(:os) && fs[:os].key?('release') && (fs[:os]['release']['major'] =~ /\d/)
              "#{os_name} #{os_rel}"
            elsif fs.key?(:operatingsystemmajrelease)
              "#{os_name} #{os_rel}"
            else
              "#{os_name} #{os__rel.split('.')[1]}"
            end
  elsif /sles-15-/.match?(fs[:_facterdb_filename])
    label = 'SLES 15'
  elsif os_name.start_with?('Debian') && os_id == 'LinuxMint'
    label = "#{os_id} #{fs[:lsbmajdistrelease]}"
  elsif os_name.start_with?('Debian') && os_id == 'Raspbian'
    label = "#{os_id} #{os_rel}"
  elsif /^windows$/.match?(os_name)
    db_filename = fs[:_facterdb_filename] || 'there_is_no_filename'
    label = if /windows-10-/.match?(db_filename)
              'Windows 10'
            elsif /windows-7-/.match?(db_filename)
              'Windows 7'
            elsif /windows-8[\d.]*-/.match?(db_filename)
              "Windows #{os__rel.sub('6.2.9200', '8').sub('6.3.9600', '8.1')}"
            elsif /windows-.+-core-/.match?(db_filename)
              "Windows Server #{os__rel.sub('6.3.9600', '2012 R2')} Core"
            elsif db_filename =~ /windows-2008/ || db_filename =~ /windows-2012/ || db_filename =~ /windows-2016/
              "Windows Server #{os__rel.sub('6.1.7600', '2008 R2').sub('6.3.9600', '2012 R2').sub('10.0.14393',
                                                                                                  '2016')}"
            elsif /windows-2019/.match?(db_filename)
              'Windows Server 2019'
            else
              "#{os_name} #{os__rel}"
            end
  end

  label
end

desc 'generate a markdown table of Facter/OS coverage (for the README)'
task :table do
  require_relative 'lib/facterdb'
  # Turn on the source injection
  old_env = ENV.fetch('FACTERDB_INJECT_SOURCE', nil)
  ENV['FACTERDB_INJECT_SOURCE'] = 'true'
  factsets = FacterDB.get_facts
  # Restore the source injection
  ENV['FACTERDB_INJECT_SOURCE'] = old_env

  facter_versions = factsets.map do |x|
    Gem::Version.new(x[:facterversion].split('.')[0..1].join('.'))
  end.uniq.sort.map(&:to_s)
  os_facter_matrix = {}

  # Process the facts and create a hash of all the OS and facter combinations
  factsets.each do |facts|
    fv = facts[:facterversion].split('.')[0..1].join('.')
    label = factset_to_os_label(facts)
    os_facter_matrix[label] ||= {}
    os_facter_matrix[label][fv] ||= 0
    os_facter_matrix[label][fv] += 1
  end
  # Extract the OS list
  os_versions = os_facter_matrix.keys.uniq.sort_by do |label|
    string_pieces = label.split(/\d+/)
    number_pieces = label.split(/\D+/).map(&:to_i)
    number_pieces.shift
    string_pieces.zip(number_pieces).flatten.compact
  end

  readme_path = File.expand_path(File.join(__dir__, 'README.md'))
  readme = File.read(readme_path).split("\n")
  new_readme = readme[0..readme.index { |r| r.start_with?('| ') } - 1]

  # Write out a nice table
  os_version_width = (os_versions.map { |x| x.size } + [17]).max
  new_readme << "| #{'operating system'.center(os_version_width)} |#{facter_versions.map { |x| " #{x} |" }.join}"
  new_readme << "| #{'-' * os_version_width} |#{facter_versions.map { |_x| ' --- |' }.join}"
  os_versions.each do |label|
    fvs = facter_versions.map { |facter_version| os_facter_matrix[label][facter_version] || 0 }
    row = "| #{label.ljust(os_version_width)} |"
    fvs.each { |fv| row += ((fv > 0) ? " #{fv.to_s.center(3)} |" : '     |') }
    new_readme << row
  end

  File.open(readme_path, 'w') do |fd|
    fd.puts (new_readme + readme[readme.rindex { |r| r.start_with?('| ') } + 1..-1]).join("\n")
  end
end

begin
  require 'voxpupuli/rubocop/rake'
rescue LoadError
  # the voxpupuli-rubocop gem is optional
end

task default: 'spec'
