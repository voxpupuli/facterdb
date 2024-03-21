param(
  [array]$puppetAgentVersions = ('7.24.0','8.0.0','8.5.1','8.6.0'),
  [string]$baseUrl = 'https://downloads.puppetlabs.com/windows/puppet{0}/puppet-agent-{1}-{2}.msi',
  [string]$fqdn = 'foo.example.com'
)

$ComputerName = "foo"
$ComputerDomain = "example.com"

Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Hostname"
Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "NV Hostname"
Remove-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Domain"

Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername" -name "Computername" -value $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Computername\ActiveComputername" -name "Computername" -value $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "Hostname" -value $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -name "NV Hostname" -value  $ComputerName
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name Domain -Value $ComputerDomain
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name DhcpDomain -Value $ComputerDomain

# This doesn't work even though net use does???
#New-SmbMapping -LocalPath 'X:' -RemotePath '\\VBOXSVR\vagrant'
net use X: \\VBOXSVR\vagrant

$VagrantDataPath = 'X:\'
$WorkingDirectory = 'C:\vagrant_working_directory\'

# Make sure we have enough privs to install the things.
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (! ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
  Write-Host -ForegroundColor Red "You must run this script as an administrator."
  Exit 1
}

# Create our tmp dir if it's not found
if (!(Test-Path $WorkingDirectory)) {
  Write-Host "Creating folder `'$WorkingDirectory`'"
  $null = New-Item -Path "$WorkingDirectory" -ItemType Directory
}

# Install each puppet version & collect facts.
foreach ($pupAgentVer in $puppetAgentVersions) {

  $agentUrl = $baseUrl -f $pupAgentVer[0], $pupAgentVer, "x64"
  $agentName = "puppet-agent-{1}-{2}.msi" -f $pupAgentVer[0], $pupAgentVer, "x64"
  $agentLogNameI = "puppet-{1}-install.log" -f $pupAgentVer[0], $pupAgentVer, "x64"
  $agentLogNameU = "puppet-{1}-uninstall.log" -f $pupAgentVer[0], $pupAgentVer, "x64"
  $agentInstaller = Join-Path $WorkingDirectory $agentName
  $agentLogPathI = Join-Path $WorkingDirectory $agentLogNameI
  $agentLogPathU = Join-Path $WorkingDirectory $agentLogNameU

  write-Host "Downloading `'$agentUrl`' to `'$agentInstaller`'"
  (New-Object Net.WebClient).DownloadFile("$agentUrl", "$agentInstaller")

  #Install the actual agent
  $install_args = @("/l*v $agentLogPathI", "/qn", "/norestart", "/i", "$agentInstaller", "PUPPET_AGENT_CERTNAME=$fqdn")
  $uninstall_args = @("/l*v $agentLogPathU", "/qn", "/norestart", "/x", "$agentInstaller")
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

  $facterArgs = @("-j", "-p", "--show-legacy")
  $facterProcess = Start-Process -FilePath $facterBin -ArgumentList $facterArgs -Wait -PassThru -RedirectStandardOutput "X:\$facterVer\$Os-$Osmaj-$Hw.facts"
  if ($facterProcess.ExitCode -ne 0) {
    Write-Host "Facter failed."
    Exit 1
  }

  # dos2unix:  `n in Powershell is a LF character
  ((Get-Content "X:\$facterVer\$Os-$Osmaj-$Hw.facts") -join "`n") + "`n" | Set-Content -NoNewline "X:\$facterVer\$Os-$Osmaj-$Hw.facts"

  Write-Host "Facts collected for $Os-$Osmaj-$Hw with facter $facterVer"

  Write-Host "Uninstalling Puppet. running msiexec.exe $uninstall_args"
  $agentProcess = Start-Process -FilePath msiexec.exe -ArgumentList $uninstall_args -Wait -PassThru
  if ($agentProcess.ExitCode -ne 0) {
    Write-Host "Installer failed."
    Exit 1
  }
  Write-Host "Puppet Agent $pupAgentVer successfully uninstalled."

}
