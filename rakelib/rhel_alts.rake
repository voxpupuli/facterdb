desc 'Create RHEL/OracleLinux/Scientific factsets from CentOS factsets'
task :rhel_alts do
  Dir[File.join(__dir__, '..', 'facts', '*', 'centos-*-x86_64.facts')].each do |f|
    centos_factset = File.read(f)

    rhel_path = f.gsub(%r{centos-}, 'redhat-')
    File.open(rhel_path, 'w') do |fd|
      fd.puts centos_factset.gsub(%r{CentOS}, 'RedHat')
    end

    oracle_path = f.gsub(%r{centos-}, 'oraclelinux-')
    File.open(oracle_path, 'w') do |fd|
      fd.puts centos_factset.gsub(%r{CentOS}, 'OracleLinux')
    end

    # Scientific isn't going to be updated to 8
    if File.basename(f)[%r{-(\d+)-}, 1].to_i <= 7
      scientific_path = f.gsub(%r{centos-}, 'scientific-')
      File.open(scientific_path, 'w') do |fd|
        fd.puts centos_factset.gsub(%r{CentOS}, 'Scientific')
      end
    end
  end
end
