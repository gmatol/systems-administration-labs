#Requires -RunAsAdministrator
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
if ($env:COMPUTERNAME -ne 'DC01') { throw 'Run only on DC01 after its rename and reboot.' }
if ((Get-CimInstance Win32_ComputerSystem).PartOfDomain) { throw 'Host already belongs to a domain. Inspect before continuing.' }
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools | Out-Host
$dsrm = Read-Host 'Enter a unique DSRM recovery password (save securely)' -AsSecureString
Install-ADDSForest -DomainName 'ad.guotlab.test' -DomainNetbiosName 'GUOTLAB' -InstallDns -SafeModeAdministratorPassword $dsrm
# Windows requests confirmation and reboots. Do not suppress prerequisite checks.
