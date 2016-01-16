$original_env_path=$Env:Path.clone()
Foreach( $installer in 'puppet-agent-1.2.7-x64','puppet-agent-1.2.2-x64','puppet-3.8.4-x64','puppet-3.7.4-x64' )
{
  # ---------------------------------------------------------------------------
  $installer_url  = "https://downloads.puppetlabs.com/windows/${installer}.msi"
  $installer_file = "C:\vagrant\${installer}.msi"

  # ---------------------------------------------------------------------------
  if( -Not (Test-Path $installer_file) )
  {
    Write-Output "== Downloading '${installer_url}'"
    (New-Object System.Net.WebClient).DownloadFile( $installer_url, $installer_file )
  }

  # The Puppet 3.x installers didn't update the $Env:Path
  # ---------------------------------------------------------------------------
  if( $installer.SubString(0,8) -eq 'puppet-3' )
  {
    $Env:Path="C:\Program Files\Puppet Labs\Puppet\bin;$Env:Path"
  }
  else
  {
    $Env:Path=$original_env_path
  }
  ### Write-Output "== Env:Path = '${Env:Path}'"
  ### Write-Output "== original_env_path = '${original_env_path}'"

  # ---------------------------------------------------------------------------
  Write-Output "== Installing '${installer_file}'"
  # ---------------------------------------------------------------------------
  Start-Process msiexec -ArgumentList "/qn /norestart /i ${installer_file}" -wait


  # ---------------------------------------------------------------------------
  Write-Output "== Gathering facts"
  # ---------------------------------------------------------------------------
  $facter_version = ([string](facter --version).SubString(0,3))
  $os             = (facter operatingsystem)
  $osmajrel       = (facter operatingsystemmajrelease)
  $arch           = (facter hardwaremodel)
  $fact_dir       = "C:\vagrant\${facter_version}"
  $facts_filename = "${fact_dir}\${os}-${osmajrel}-${arch}.facts"
  mkdir -p $fact_dir -f
  facter -j | Tee-Object -file $facts_filename
  # ---------------------------------------------------------------------------

  Write-Output "== Uninstalling '${installer_file}'"
  Start-Process msiexec -ArgumentList "/qn /norestart /x ${installer_file}" -wait
}
