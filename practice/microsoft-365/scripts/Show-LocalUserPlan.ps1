# Local simulation only. No modules, credentials, network calls or tenant changes.
# Run from any working directory using PowerShell 7.
[CmdletBinding()]
param()
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$csvPath = Join-Path $PSScriptRoot '../examples/users.fictional.csv'
Import-Csv -LiteralPath $csvPath | ForEach-Object {
    [pscustomobject]@{
        Status = 'LOCAL SIMULATION - NOT PROVISIONED'
        ProposedAlias = $_.Alias
        DisplayName = $_.DisplayName
        Department = $_.Department
        ProposedGroup = 'LAB-M365-Learners'
        License = 'UNASSIGNED - entitlement review required'
    }
}
