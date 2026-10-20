#Requires -RunAsAdministrator
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
if ($env:COMPUTERNAME -ne 'MGMT01') { throw 'Run only on MGMT01 after its rename and reboot.' }
if ((Get-CimInstance Win32_ComputerSystem).PartOfDomain) { throw 'Already domain joined; verify the existing domain.' }
$adapters = @(Get-NetAdapter | Where-Object Status -eq 'Up')
if ($adapters.Count -ne 1) { throw 'Expected one active adapter; choose the lab adapter manually.' }
Set-DnsClientServerAddress -InterfaceIndex $adapters[0].ifIndex -ServerAddresses '10.77.10.10'
Resolve-DnsName -Type SRV '_ldap._tcp.dc._msdcs.ad.guotlab.test' -ErrorAction Stop
$credential = Get-Credential -UserName 'GUOTLAB\Administrator' -Message 'Domain join credentials'
Add-Computer -DomainName 'ad.guotlab.test' -Credential $credential -Restart
