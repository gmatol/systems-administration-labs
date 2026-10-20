#Requires -RunAsAdministrator
#Requires -Modules ActiveDirectory
[CmdletBinding(SupportsShouldProcess)]
param([string]$CsvPath = "$PSScriptRoot\..\data\users.csv")
$ErrorActionPreference = 'Stop'
$domain = Get-ADDomain
if ($domain.DNSRoot -ne 'ad.guotlab.test') { throw 'Wrong domain; this script is only for ad.guotlab.test.' }
$rows = @(Import-Csv -Path $CsvPath)
$departments = @('IT','HR','Finance','Operations','Support')
if ($rows.Count -ne 150) { throw 'Expected exactly 150 synthetic users.' }
if (@($rows.SamAccountName | Sort-Object -Unique).Count -ne 150) { throw 'Duplicate user names in CSV.' }
foreach ($row in $rows) {
    if ($row.Department -notin $departments -or $row.SamAccountName -notmatch '^labuser\d{3}$') {
        throw 'Invalid department or account name in CSV.'
    }
}
foreach ($department in $departments) {
    $ouPath = "OU=$department,$($domain.DistinguishedName)"
    $existing = Get-ADOrganizationalUnit -Filter "Name -eq '$department'" -SearchBase $domain.DistinguishedName -SearchScope OneLevel
    if (-not $existing -and $PSCmdlet.ShouldProcess($ouPath, 'Create lab OU')) {
        New-ADOrganizationalUnit -Name $department -Path $domain.DistinguishedName -ProtectedFromAccidentalDeletion $true
    }
}
foreach ($row in $rows) {
    $sam = $row.SamAccountName
    $existing = Get-ADUser -Filter "SamAccountName -eq '$sam'"
    if ($existing) { Write-Host "Skipped existing $sam"; continue }
    if ($PSCmdlet.ShouldProcess($sam, 'Create disabled synthetic user')) {
        New-ADUser -Name $row.Name -SamAccountName $sam `
            -UserPrincipalName "$sam@$($domain.DNSRoot)" `
            -Department $row.Department -Path "OU=$($row.Department),$($domain.DistinguishedName)" `
            -Enabled $false -Description 'Synthetic systems administration lab account'
    }
}
Write-Host 'Accounts are disabled. Enable only selected test accounts using separate, unique passwords.'
