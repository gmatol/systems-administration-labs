#Requires -RunAsAdministrator
#Requires -Modules ActiveDirectory
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
if ($env:COMPUTERNAME -ne 'DC01') { throw 'Run on DC01.' }
$domain = Get-ADDomain
if ($domain.DNSRoot -ne 'ad.guotlab.test') { throw 'Wrong domain.' }
Get-ADDomain | Select-Object DNSRoot,NetBIOSName,DomainMode
Get-Service NTDS,DNS,Netlogon | Select-Object Name,Status
Resolve-DnsName -Type SRV '_ldap._tcp.dc._msdcs.ad.guotlab.test'
$counts = foreach ($department in @('IT','HR','Finance','Operations','Support')) {
    $users = @(Get-ADUser -Filter 'SamAccountName -like "labuser*"' -SearchBase "OU=$department,$($domain.DistinguishedName)" -SearchScope OneLevel)
    [pscustomobject]@{OU=$department; SyntheticUsers=$users.Count; Expected=30}
}
$counts | Format-Table -AutoSize
if (@($counts | Where-Object SyntheticUsers -ne 30).Count -gt 0) { throw 'Expected 30 synthetic users in each OU.' }
Write-Host 'Count check passed. Run dcdiag separately and inspect all reported failures.'
