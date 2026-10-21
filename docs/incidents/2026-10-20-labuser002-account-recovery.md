# Disabled AD account recovery: labuser002

Session date: October 20, 2026 (America/Denver)  
Environment: Windows Server 2025 AD lab on AWS  
Evidence source: learner-provided terminal output and a learner-confirmed authentication result

## Result

On DC01, `labuser002` initially showed `Enabled: False`, `LockedOut: False`,
and a blank PasswordLastSet field. After a password reset and account enablement,
the account showed `Enabled: True`, `LockedOut: False`, and a password timestamp.
From MGMT01, the learner confirmed that the instructed domain credential-validation
test returned `True`.

This exercise recovered a synthetic account that was already disabled by the
provisioning workflow. It did not reproduce a new sign-in failure or a lockout.

## Diagnosis

The initial query was run on DC01:

```powershell
Get-ADUser -Identity labuser002 -Properties LockedOut, PasswordLastSet |
    Select-Object SamAccountName, Enabled, LockedOut, PasswordLastSet
```

The disabled flag identified the account condition. The lockout flag was false,
so an unlock operation was not part of the repair. A blank password timestamp
alone does not prove an account's complete password history.

## Recovery on DC01

Set a new, unique password through a hidden prompt, then enable only the selected
practice account:

```powershell
$newPassword = Read-Host "Enter a new password for labuser002" -AsSecureString
Set-ADAccountPassword -Identity labuser002 -Reset -NewPassword $newPassword
Enable-ADAccount -Identity labuser002
Remove-Variable newPassword

Get-ADUser -Identity labuser002 -Properties LockedOut, PasswordLastSet |
    Select-Object SamAccountName, Enabled, LockedOut, PasswordLastSet
```

The observed password timestamp was `10/21/2026 12:46:03 AM`. It is preserved as
displayed by the server; its display timezone was not independently verified.

## Authentication check on MGMT01

The learner connected to MGMT01 through SSM and confirmed its hostname. The
following test was then provided, and the learner reported `true`:

```powershell
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$domainContext = [System.DirectoryServices.AccountManagement.PrincipalContext]::new(
    [System.DirectoryServices.AccountManagement.ContextType]::Domain,
    'ad.guotlab.test'
)
$testPassword = Read-Host "Enter the password for labuser002" -AsSecureString
$testCredential = [System.Net.NetworkCredential]::new(
    'labuser002',
    $testPassword,
    'GUOTLAB'
)
$domainContext.ValidateCredentials('labuser002', $testCredential.Password)

$domainContext.Dispose()
Remove-Variable testPassword, testCredential, domainContext
```

No password was requested in chat or included in this report. Cleanup commands were
provided; their execution was not separately confirmed.

## Evidence and limits

[Selected evidence and learner confirmation](../../evidence/published/2026-10-20-labuser002-account-recovery.txt) distinguishes the
pasted account-state output from the brief confirmation of the authentication result.

The test verifies acceptance of domain credentials from MGMT01. It does not verify
a new RDP/desktop sign-in, application authorization, group membership changes,
lockout recovery, or a failed-authentication comparison before repair. No elapsed
recovery time or production impact was measured.

The earlier SSM connection attempt failed while both EC2 instances were stopped.
After startup, both reported Online and the learner connected. This management
availability issue is separate from the disabled-account condition.

## Interview explanation

I inspected a disabled synthetic AD account and distinguished its disabled state
from a lockout. I reset its password through a hidden prompt, enabled the account,
verified its updated properties, and confirmed domain credential validation from
a member server. I documented the evidence and the limits of the authentication test.
