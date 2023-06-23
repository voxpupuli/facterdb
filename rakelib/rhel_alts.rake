desc 'Create RHEL/OracleLinux/Scientific factsets from CentOS factsets'
task :rhel_alts do
  Dir[File.join(__dir__, '..', 'facts', '*', 'centos-*-x86_64.facts')].each do |f|
    centos_factset = File.read(f)

    rhel_path = f.gsub(/centos-/, 'redhat-')
    File.write(rhel_path, centos_factset.gsub(/CentOS/, 'RedHat'))

    oracle_path = f.gsub(/centos-/, 'oraclelinux-')
    File.write(oracle_path, centos_factset.gsub(/CentOS/, 'OracleLinux'))

    # Scientific isn't going to be updated to 8
    next unless File.basename(f)[/-(\d+)-/, 1].to_i <= 7

    scientific_path = f.gsub(/centos-/, 'scientific-')
    File.write(scientific_path, centos_factset.gsub(/CentOS/, 'Scientific'))
  end
end
