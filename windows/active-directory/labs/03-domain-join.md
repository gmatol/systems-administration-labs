# Lab 03: join and authenticate

**Status: not executed.** DC01 must be running with healthy DNS.
Use MGMT01 RDP, open elevated Windows PowerShell, run `C:\Lab\04-join-domain.ps1`.
The script points DNS at DC01, checks AD SRV records and joins the domain, then reboots.
Reconnect using `GUOTLAB\Administrator` (or `MGMT01\Administrator` for local recovery).

```powershell
(Get-CimInstance Win32_ComputerSystem) | Select-Object Name,Domain,PartOfDomain
Test-ComputerSecureChannel -Verbose
nltest /dsgetdc:ad.guotlab.test
whoami
```

For a regular-user authentication test, set `labuser001` to a unique test password on DC01
as in lab 02. For this specific `runas` test, clear the first-login change flag on DC01:

```powershell
Set-ADUser labuser001 -ChangePasswordAtLogon $false
```

Then in an elevated or ordinary PowerShell session on MGMT01:

```powershell
runas /user:GUOTLAB\labuser001 "cmd /k whoami"
```

Enter the test password. Expected: new command window shows `guotlab\labuser001`.
This verifies authentication; it does not grant administrative rights. Test access to a
resource separately to distinguish authorization from authentication. Disable labuser001
on DC01 when finished. A Windows Server member is used here; Windows 11 client practice
remains a later lab with its own licensing, resources and network connectivity design.

Evidence: domain membership, secure channel True, DC discovery and test identity output.
Rollback for a DNS-only problem: restore DNS to DC01 after the investigation. For complete
unjoin, use a known local Administrator credential and a planned restart; don't unjoin
until evidence is recorded and you are ready to repeat the exercise.
