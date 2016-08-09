$original_env_path=$Env:Path.clone()
###Foreach( $installer in 'puppet-agent-1.5.3-x64','puppet-agent-1.5.1-x64','puppet-agent-1.2.2-x64','puppet-3.8.4-x64','puppet-3.7.4-x64','puppet-3.7.0-x64','puppet-3.6.2', 'puppet-3.6.0', 'puppet-3.1.1', 'puppet-3.0.0' )
Foreach( $installer in 'puppet-3.6.2', 'puppet-3.6.0', 'puppet-3.1.1', 'puppet-3.0.0' )
{
  # ---------------------------------------------------------------------------
  $installer_url  = "https://downloads.puppetlabs.com/windows/${installer}.msi"
  $installer_file = "C:\vagrant\${installer}.msi"

  # ---------------------------------------------------------------------------
  # It takes a long time to download
  #
  if( -Not (Test-Path $installer_file) ) {
    Write-Output "== Downloading '${installer_url}'"
    (New-Object System.Net.WebClient).DownloadFile( $installer_url, $installer_file )
  } else {
    Write-Output "== '${installer_file}' exists; skip downloading '${installer_url}'"
  }


  Write-Output "== Env:Path = '${Env:Path}'"
  ### Write-Output "== original_env_path = '${original_env_path}'"

  # ---------------------------------------------------------------------------
  Write-Output "== Installing '${installer_file}'"
  # ---------------------------------------------------------------------------
  Start-Process msiexec -ArgumentList "/qn /norestart /i ${installer_file}" -wait

  $pup_ver_snippet =  $installer.SubString(0,10)
  if( $pup_ver_snippet -match 'puppet-3.[0-6]' ) {
    Write-Output "<< '${pup_ver_snippet}' << 3.6 or less!"
    $Env:Path="C:\Program Files (x86)\Puppet Labs\Puppet\bin;$original_env_path"
  } else {
    # The Puppet 3.x installers didn't update the $Env:Path
    # ---------------------------------------------------------------------------
    Write-Output ">> '${pup_ver_snippet}' >> 3.7+"
    $Env:Path="C:\Program Files\Puppet Labs\Puppet\bin;$original_env_path"
  }

  # ---------------------------------------------------------------------------
  Write-Output "== Gathering facts"
  # ---------------------------------------------------------------------------
  $facter_version = ([string](facter --version).SubString(0,3))
  $os             = (facter operatingsystem)
  $osmajrel       = (facter operatingsystemmajrelease)
  if( $facter_version -le '2.0' ){
    $osmajrel       = (facter operatingsystemrelease)
  }
  $arch           = (facter hardwaremodel)
  $fact_dir       = "C:\vagrant\${facter_version}"
  $facts_filename = "${fact_dir}\${os}-${osmajrel}-${arch}.facts"
  mkdir -p $fact_dir -f
  if( $facter_version -le '1.7' )
  {
    $facts_filename = "${facts_filename}.yaml.UTF16LE"
    facter -y | Tee-Object -file $facts_filename
  }
  else
  {
    $facts_filename = "${facts_filename}.UTF16LE"
    facter -j | Tee-Object -file $facts_filename
  }
  # ---------------------------------------------------------------------------
  Write-Output "++ Teed '${installer}' facts into '${facts_filename}'"

  # ---------------------------------------------------------------------------
  Write-Output "== Uninstalling '${installer_file}'"
  # ---------------------------------------------------------------------------
  Start-Process msiexec -ArgumentList "/qn /norestart /x ${installer_file}" -wait

  $Env:Path="$original_env_path"
}
