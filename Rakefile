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
    config.project = 'facterdb'
    config.release_url = "https://rubygems.org/gems/facterdb/versions/%s"
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
  if fs.key?(:os)  && (fs[:os]['release']['major'] =~ /\d/)
    os_name = fs[:os]['name']
    os_rel  = fs[:os]['release']['major']
    os__rel = fs[:os]['release']['full']
  elsif fs.key? :operatingsystem
    os_name  = fs[:operatingsystem]
    os_rel   = fs.fetch(:operatingsystemmajrelease, fs.fetch(:lsbmajdistrelease, nil))
    os__rel  = fs.fetch(:lsbdistrelease, fs.fetch(:operatingsystemrelease, '@@@'))
  else
    require 'pp'
    pp fs
    fail( 'ERROR: unrecognized facterset format' )
  end

  # Sanitize OS names to match the formats used in the facterdb README
  label = "#{os_name} #{os_rel}"
  if os_name =~ /^(Archlinux|Gentoo)$/
    label = os_name
  elsif os_name =~ /^(SLES|FreeBSD|OpenSuSE)$/ ||
        (os_name =~ /^(RedHat|Scientific|OracleLinux|CentOS)/  && os_rel.nil?)
    label = "#{os_name} #{os__rel.split('.').first}"
  elsif os_name =~ /^(OpenBSD|Ubuntu|Fedora)$/
    label = "#{os_name} #{os__rel}"
  elsif os_name =~ /^(Solaris)/
    label = "#{os_name} #{os__rel.split('.')[1]}"
  elsif os_name.start_with?('Debian') && fs[:lsbdistid] == 'LinuxMint'
    label = "#{fs[:lsbdistid]} #{fs[:lsbmajdistrelease]}"
  elsif os_name =~ /^windows$/
    db_filename = fs[:_facterdb_filename] || 'there_is_no_filename'
    if db_filename =~ /windows-10-/
      label = "Windows #{os__rel}"
    elsif db_filename =~ /windows-7-/
      label = "Windows 7"
    elsif db_filename =~ /windows-8[\d.]*-/
      label = "Windows #{os__rel.sub('6.2.9200','8').sub('6.3.9600','8.1')}"
    elsif db_filename =~ /windows-.+-core-/
      label = "Windows Server #{os__rel.sub('6.3.9600','2012 R2')} Core"
    elsif db_filename =~ /windows-2008/ || db_filename =~ /windows-2012/ || db_filename =~ /windows-2016/
      label = "Windows Server #{os__rel.sub('6.1.7600','2008 R2').sub('6.3.9600','2012 R2')}"
    else
      label = "#{os_name} #{os__rel}"
    end
  end

  label
end

desc 'generate a markdown table of Facter/OS coverage (for the README)'
task :table do
  require_relative 'lib/facterdb'
  # Turn on the source injection
  old_env = ENV['FACTERDB_INJECT_SOURCE']
  ENV['FACTERDB_INJECT_SOURCE'] = 'true'
  factsets = FacterDB.get_facts()
  # Restore the source injection
  ENV['FACTERDB_INJECT_SOURCE'] = old_env

  facter_versions = factsets.map { |x|
    Gem::Version.new(x[:facterversion].split('.')[0..1].join('.'))
  }.uniq.sort.map(&:to_s)
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
  os_versions = os_facter_matrix.keys.uniq.sort

  # Write out a nice table
  os_version_width = (os_versions.map{|x| x.size } + [17]).max
  puts "| #{'operating system'.center(os_version_width)} |#{facter_versions.map{|x| " #{x} |" }.join}"
  puts "| #{'-' * (os_version_width)} |#{facter_versions.map{|x| " --- |" }.join}"
  os_versions.each do |label|
    fvs = facter_versions.map{ |facter_version| os_facter_matrix[label][facter_version] || 0 }
    row = "| #{label.ljust(os_version_width)} |"
    fvs.each { |fv| row += (fv > 0?  " #{fv.to_s.center(3)} |" : "     |" ) }
    puts row
  end
end
