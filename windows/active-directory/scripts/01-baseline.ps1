#Requires -RunAsAdministrator
[CmdletBinding()]
param([Parameter(Mandatory)][ValidateSet('DC01','MGMT01')][string]$ComputerName)
$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Path C:\Lab -Force | Out-Null
Get-NetIPConfiguration
Get-Service AmazonSSMAgent
if ($env:COMPUTERNAME -ne $ComputerName) {
    Rename-Computer -NewName $ComputerName
    Write-Host 'Name changed. Save your work, then run Restart-Computer before continuing.'
} else {
    Write-Host 'Computer already has the requested name.'
}
