# ZIP file-content exercise, NOT Windows Server Backup or system-state recovery.
[CmdletBinding()]
param([switch]$NonInteractive)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
function Pause-Lab([string]$Question) {
    if (-not $NonInteractive) { $null = Read-Host "$Question Press Enter to continue (Ctrl-C stops)" }
}
# A fresh unpredictable directory; no administrator rights or supplied target paths.
$Run = Join-Path ([IO.Path]::GetTempPath()) ('sysadmin-backup-' + [guid]::NewGuid())
$null = New-Item -ItemType Directory -Path $Run
foreach ($Name in @('source','backup','restored','lost')) {
    $null = New-Item -ItemType Directory -Path (Join-Path $Run $Name)
}
$Source = Join-Path $Run 'source'
$Restore = Join-Path $Run 'restored'
Set-Content -LiteralPath (Join-Path $Source 'service.txt') -Value 'Fictional service: inventory-demo'
Set-Content -LiteralPath (Join-Path $Source 'tickets.csv') -Value @('ticket,status','DEMO-001,resolved')
function Get-Manifest([string]$Folder) {
    @(Get-ChildItem -LiteralPath $Folder -File | Sort-Object Name | ForEach-Object {
        '{0}  {1}' -f (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash, $_.Name
    })
}
$Before = Get-Manifest $Source
$Before | Set-Content -LiteralPath (Join-Path $Run 'baseline.sha256')
Write-Output "Run directory: $Run"
$Before
Pause-Lab 'Why capture a baseline before loss?'
$Zip = Join-Path $Run 'backup/files.zip'
Compress-Archive -Path (Join-Path $Source '*') -DestinationPath $Zip
$ArchiveHash = (Get-FileHash -LiteralPath $Zip -Algorithm SHA256).Hash
$ArchiveHash | Set-Content -LiteralPath (Join-Path $Run 'archive.sha256')
if ((Get-FileHash -LiteralPath $Zip -Algorithm SHA256).Hash -ne $ArchiveHash) { throw 'Archive changed' }
Pause-Lab 'Why is an archive hash insufficient to prove successful recovery?'
Move-Item -LiteralPath (Join-Path $Source 'service.txt') -Destination (Join-Path $Run 'lost/service.txt')
if (Test-Path -LiteralPath (Join-Path $Source 'service.txt')) { throw 'Loss simulation failed' }
Write-Output 'Simulated loss confirmed.'
Pause-Lab 'Why restore into an empty directory?'
Expand-Archive -LiteralPath $Zip -DestinationPath $Restore
$After = Get-Manifest $Restore
$After | Set-Content -LiteralPath (Join-Path $Run 'restored.sha256')
if (@(Compare-Object -ReferenceObject $Before -DifferenceObject $After).Count -ne 0) { throw 'Recovery hash mismatch' }
if (@(Get-ChildItem -LiteralPath $Restore -File).Count -ne 2) { throw 'Unexpected file count' }
Get-Content -LiteralPath (Join-Path $Restore 'service.txt')
Write-Output 'PASS: two restored files match the pre-loss SHA256 manifest.'
Write-Output 'Scope: file contents only. ZIP does not validate NTFS ACLs, OS, applications, or AD.'
Write-Output "Evidence retained at $Run (temporary)."
