# Later environment-dependent backup work

Status: NOT EXECUTED. No live AWS or AD changes are part of this lab.

## Windows Server Backup: isolated non-DC only

Prerequisites: a disposable Windows Server, administrator access, an already available separate backup volume with sufficient space, and fictional data only. Do not use DC01/MGMT01, provision disks in AWS, or attach volumes as part of this exercise. If those prerequisites are absent, stop at the local ZIP exercise.

On the isolated server, first use read-only checks:

```powershell
hostname
Get-CimInstance Win32_ComputerSystem | Select-Object Name, DomainRole
Get-WindowsFeature Windows-Server-Backup
Get-Volume | Select-Object DriveLetter, FileSystemLabel, SizeRemaining, Size
```

DomainRole 4/5 means domain controller: stop. Confirm the intended host and target volume manually. In this example **E:** means an existing dedicated backup target; it is not a recommendation to use a drive letter without checking it. Feature installation changes the isolated server:

```powershell
Install-WindowsFeature Windows-Server-Backup
New-Item -ItemType Directory -Path C:\BackupPracticeData
Set-Content C:\BackupPracticeData\demo.txt 'Fictional WSB recovery sample'
Get-FileHash C:\BackupPracticeData\demo.txt -Algorithm SHA256
```

If the data folder already exists, choose a fresh fictional folder instead of overwriting it. Save the baseline hash outside that folder. Read the command and verify both paths before running:

```powershell
wbadmin start backup -backupTarget:E: -include:C:\BackupPracticeData -vssCopy
if ($LASTEXITCODE -ne 0) { throw 'Backup failed; stop before simulated loss' }
wbadmin get versions -backupTarget:E:
```

`-include` selects only the fictional folder, `-backupTarget` selects the dedicated destination, `-vssCopy` uses copy-backup semantics. Keep the confirmation prompt; no `-quiet`. Expected: successful completion and a catalog version. A catalog entry alone is not a recovery test.

After successful backup, move `demo.txt` into a separate fictional holding folder and confirm it is absent from the source. In Windows Server Backup → Local Backup → Recover → select the actual backup location/version → Files and folders → select the fictional file → **Another location** → a fresh empty `C:\BackupPracticeRecovered` folder. Review the summary before Recover. Do not choose volumes, system state or original-location overwrite. Locate the recovered file under that folder and run `Get-FileHash -Algorithm SHA256` on its actual path. Compare with the saved hash and read the file. Record the recovery event/result and actual path. PASS requires missing-source evidence plus matching recovered bytes, not just a successful wizard.

Troubleshooting: if the feature is unavailable, confirm Windows Server edition; if access denied, confirm authorized elevation on the disposable host; if destination is rejected, inspect supported target type and free space, never format a disk to fix it; if no versions appear, recheck destination and backup result. Inspect Windows Server Backup/Backup operational events in Event Viewer. Do not proceed after errors.

This is WSB **file recovery**. Full-server recovery requires a suitable critical-volume/bare-metal backup and isolated boot/recovery testing, including applications and service validation. Neither ZIP nor this selected-folder backup proves that capability.

## AD system-state and disaster recovery: later design only

Windows Server Backup is the tool; system state is one selectable backup scope. On a domain controller system state includes AD DS and SYSVOL along with relevant Windows components. It is not a full-machine image. A real AD recovery plan must address backup age, DSRM credentials, supported restore procedures, authoritative versus non-authoritative recovery, DNS/SYSVOL/replication validation and forest recovery sequencing.

Do not run system-state recovery, roll back DC01, or treat an EBS snapshot as a validated AD disaster recovery procedure. Build a separate disposable forest before any hands-on AD recovery. No executable AD restore commands are included here.

## AWS EBS snapshots: conceptual workflow only

A snapshot backs up volume blocks; EC2 IAM profiles, networking and all application state are not automatically an entire server backup. AWS recommends pausing writes for consistent/complete snapshots; Windows application consistency may require a VSS-aware approach. Never pause services on the existing domain controller for this lab.

Future scope, after a separate cost/environment decision:

1. Select a disposable non-DC volume with fictional data; identify region, encryption/key access, RPO/RTO and retention.
2. Coordinate consistent writes; capture the intended backup. Snapshot creation incurs storage charges.
3. Verify completion, then create a **new** volume in the test instance's Availability Zone; this also incurs charges.
4. Attach only to an isolated test host, mount safely, locate files and compare hashes with the pre-snapshot baseline.
5. Record actual validation, inventory and clean up only the identified disposable resources under an agreed plan.

No AWS CLI mutation commands are provided or executed. Do not claim snapshot recovery from a completed-snapshot status. A read-only plan and a successful file restore are different outcomes.
