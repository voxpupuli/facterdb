desc 'Create OracleLinux factsets from RHEL factsets'
task :rhel_alts do
  Dir[File.join(__dir__, '..', 'facts', '*', 'rhel-*-x86_64.facts')].each do |f|
    rhel_factset = File.read(f)

    oracle_path = f.gsub('rhel-', 'oraclelinux-')
    File.write(oracle_path, rhel_factset.gsub('RedHat', 'OracleLinux'))
  end
end
