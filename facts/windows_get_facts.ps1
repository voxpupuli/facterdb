param(
  [array]$puppetAgentVersions = ('1.1.1','1.2.2','1.4.0'),
  [string]$baseUrl = 'https://downloads.puppetlabs.com/windows',
  [string]$fqdn = 'foo.example.com'
)

$PuppetInstallerPath = 'c:\vagrantshared\resources\installers'

# Make sure we have enough privs to install the things.
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (! ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
  Write-Host -ForegroundColor Red "You must run this script as an administrator."
  Exit 1
}

# Create our tmp dir if it's not found
if (!(Test-Path $PuppetInstallerPath)) {
  Write-Host "Creating folder `'$PuppetInstallerPath`'"
  $null = New-Item -Path "$PuppetInstallerPath" -ItemType Directory
}

# Install each puppet version & collect facts.
foreach ($pupAgentVer in $puppetAgentVersions) {
  $agentUrl = "$baseUrl/puppet-agent-$pupAgentVer-x64.msi"
  $agentInstaller = Join-Path $PuppetInstallerPath "puppet-agent-$pupAgentVer-x64.msi"

  write-Host "Downloading `'$agentUrl`' to `'$agentInstaller`'"
  (New-Object Net.WebClient).DownloadFile("$agentUrl", "$agentInstaller")

  #Install the actual agent, and 
  $install_args = @("/qn", "/norestart", "/i", "$agentInstaller", "PUPPET_AGENT_CERTNAME=$fqdn")
  Write-Host "Installing Puppet. running msiexec.exe $install_args"
  $agentProcess = Start-Process -FilePath msiexec.exe -ArgumentList $install_args -Wait -PassThru
  if ($agentProcess.ExitCode -ne 0) {
    Write-Host "Installer failed."
    Exit 1
  }
  Write-Host "Puppet Agent $pupAgentVer successfully installed."

  # Run facter
  $facterBin = "C:\Program Files\Puppet Labs\Puppet\bin\facter.bat"
  $facterVer = (&$facterBin facterversion).Substring(0,3)

  $Os = (&$facterBin operatingsystem).ToLower()
  $Osmaj = (&$facterBin operatingsystemmajrelease).ToLower()
  $Hw = (&$facterBin hardwaremodel).ToLower()

  # Supply a fqdn because vagrant windows only sets the short hostname.  Without this
  # the domain name will fallback to the hypervisor's domain.
  $env:FACTER_fqdn = $fqdn

  $facterArgs = @("-j")
  $facterProcess = Start-Process -FilePath $facterBin -ArgumentList $facterArgs -Wait -PassThru -RedirectStandardOutput "C:\vagrant\$facterVer\$Os-$Osmaj-$Hw.facts"
  if ($facterProcess.ExitCode -ne 0) {
    Write-Host "Facter failed."
    Exit 1
  }
  Write-Host "Facts collected for $Os-$Osmaj-$Hw with facter $facterVer"
}

