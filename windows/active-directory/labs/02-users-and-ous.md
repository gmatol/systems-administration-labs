# Lab 02: five OUs and 150 synthetic users

**Status: not executed.** Run on DC01 in elevated Windows PowerShell.
Copy the supplied CSV and script to `C:\Lab`.

```powershell
C:\Lab\03-create-users.ps1 -CsvPath C:\Lab\users.csv -WhatIf
C:\Lab\03-create-users.ps1 -CsvPath C:\Lab\users.csv
C:\Lab\05-verify-domain.ps1
```

Read the preview, then create the accounts. Expected: IT, HR, Finance, Operations and
Support each contain 30 synthetic accounts. Run the creation script again and confirm
that existing users are skipped. The script does not move or overwrite existing accounts.
All 150 are disabled and have no assigned passwords initially; this is intentional.

Enable only a selected disposable account with its own password:

```powershell
$password = Read-Host 'Unique password for labuser001' -AsSecureString
Set-ADAccountPassword -Identity labuser001 -Reset -NewPassword $password
Enable-ADAccount -Identity labuser001
Set-ADUser -Identity labuser001 -ChangePasswordAtLogon $true
Remove-Variable password
```

Use a local desktop console or domain-user `runas` test after domain join. RDP can reject
an expired or must-change password through NLA and requires explicit login rights; normal
users cannot RDP to a domain controller by default. Do not grant users Domain Admin to
make an RDP test work. See lab 03 for an authentication check without RDP grants.

Evidence: preview, counts, one sanitized user object and a rerun showing skips. Do not
export passwords. Completion is 150 created users, not 150 successful login tests.
Cleanup: disable the selected account after testing; retain other users for future labs.

[Microsoft New-ADUser reference](https://learn.microsoft.com/en-us/powershell/module/activedirectory/new-aduser)
