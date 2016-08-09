$original_env_path = $Env:Path.clone()
$vagrant_dir       = "C:\vagrant"

# I don't know of a Windows agent that comes with Facter 2.1, so we're missing coverage for that.
Foreach( $installer in 'puppet-agent-1.5.3-x64',  'puppet-agent-1.2.7-x64', 'puppet-agent-1.2.2-x64', 'puppet-3.8.4-x64', 'puppet-3.7.4-x64', 'puppet-3.7.0-x64', 'puppet-3.6.2', 'puppet-3.6.0', 'puppet-3.1.1')
{
  # ---------------------------------------------------------------------------
  $installer_url  = "https://downloads.puppetlabs.com/windows/${installer}.msi"
  $installer_file = "${vagrant_dir}\${installer}.msi"


  # ---------------------------------------------------------------------------
  # It can take a long time to download each installer, so reuse if present
  if( -Not (Test-Path $installer_file) ) {
    Write-Output "== Downloading '${installer_url}'"
    (New-Object System.Net.WebClient).DownloadFile( $installer_url, $installer_file )
  } else {
    Write-Output "== '${installer_file}' exists; skip downloading '${installer_url}'"
  }


  ### Write-Output "== Env:Path = '${Env:Path}'"
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
  $arch           = (facter hardwaremodel)
  $osmajrel       = (facter operatingsystemmajrelease)
  if( $facter_version -lt '2.3.0' ){
    $osmajrel     = (facter operatingsystemrelease)
  }
  $fact_dir       = "${vagrant_dir}\${facter_version}"
  $facts_filename = "${fact_dir}\${os}-${osmajrel}-${arch}.facts"

  # Slightly more portable than "mkdir -p $fact_dir -f" :
  New-Item $fact_dir -Type directory -Force | Out-Null

  $facter_args = "-j", "--external-dir ${vagrant_dir}\external_facts"
  if( $facter_version -match "^3.[01]" ){
    # external_facts workaround for FACT-1276
    Write-Output "==== FACT-1276 workaround"
    Copy-Item "${vagrant_dir}\external_facts\*" "C:\ProgramData\PuppetLabs\facter\facts.d"
    $facter_args    = @("-j")
  }
  elseif( $facter_version -eq '1.6' )
  {
    # The ruby with facter 1.6 does not ship with json support
    Write-Output "==== 1.6 YAML workaround"
    $facts_filename = "${facts_filename}.yaml"
    $facter_args    = @("-y")
  }
  # facterdb conventions use 'foo.example.com'
  $env:FACTER_fqdn   = 'foo.example.com'
  $env:FACTER_domain = 'example.com'
  Write-Output  "== Start-Process -FilePath facter -ArgumentList ${facter_args} -Wait -PassThru -RedirectStandardOutput ${facts_filename}"
  $facter_process = Start-Process -FilePath facter -ArgumentList $facter_args -Wait -PassThru -RedirectStandardOutput $facts_filename
  if ($facter_process.ExitCode -ne 0) {
    Write-Output "Facter failed."
    Exit 1
  }
  # ---------------------------------------------------------------------------
  Write-Output "++++ Wrote '${installer}'/'${facter_version}' facts into '${facts_filename}'"

  # ---------------------------------------------------------------------------
  Write-Output "== Uninstalling '${installer_file}'"
  # ---------------------------------------------------------------------------
  Start-Process msiexec -ArgumentList "/qn /norestart /x ${installer_file}" -wait

  $Env:Path="$original_env_path"
}
# vim: set syntax=ps1 tw=160 ts=2 sw=2 et:
