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
  elsif os_name =~ /^windows$/
    label = "#{os_name} #{os__rel.sub('6.3.9600','2012 R2').sub('6.1.7600','2008 R2')}"
  end

  label
end

desc 'generate a markdown table of Facter/OS coverage (for the README)'
task :table do
  require_relative 'lib/facterdb'
  factsets = FacterDB.get_facts()
  facter_versions = factsets.map{|x| x[:facterversion][0..2] }.uniq.sort
  os_versions = factsets.map do |x|
    p = factset_to_os_label(x)


  end.uniq.sort
  facter_os_matrix = {}
  os_facter_matrix = {}
  factsets.each do |facts|
    fv = facts[:facterversion][0..2]
    label = factset_to_os_label(facts)
    facter_os_matrix[fv] ||= {}
    os_facter_matrix[label] ||= {}
    os_facter_matrix[label][fv] ||= []
    os_facter_matrix[label][fv] << facts
  end

  _w = (os_versions.map{|x| x.size } + [17]).max
  puts "| #{'operating system'.center(_w)} |#{facter_versions.map{|x| " #{x} |" }.join}"
  puts "| #{'-' * (_w)} |#{facter_versions.map{|x| " --- |" }.join}"
  os_versions.each do |label|
    fvs = facter_versions.map{ |x| os_facter_matrix[label].fetch(x,[]).size }
    row = "| #{label.ljust(_w)} |"
    fvs.each { |fv| row += (fv > 0?  " #{fv.to_s.center(3)} |" : "     |" ) }
    puts row
  end
end
