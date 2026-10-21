# Disabled AD account recovery: labuser002

Session date: October 20, 2026 (America/Denver)  
Environment: Windows Server 2025 AD lab on AWS  
Evidence source: my terminal output and my recorded confirmation of the authentication result

## Result

On DC01, I found that `labuser002` showed `Enabled: False`, `LockedOut: False`,
and a blank PasswordLastSet field. I reset its password, enabled the account, and
verified `Enabled: True`, `LockedOut: False`, and a populated password timestamp.
From MGMT01, I ran the domain credential-validation test and confirmed `True` during
my guided study session.

I recovered a synthetic account that was already disabled by the provisioning workflow.
I did not reproduce a new sign-in failure or a lockout in this exercise.

## Diagnosis

I inspected the account on DC01:

```powershell
Get-ADUser -Identity labuser002 -Properties LockedOut, PasswordLastSet |
    Select-Object SamAccountName, Enabled, LockedOut, PasswordLastSet
```

I identified the disabled account condition and distinguished it from a lockout.
Because LockedOut was false, I did not need to unlock the account. A blank password
timestamp alone does not prove the account's complete password history.

## Recovery on DC01

I set a new, unique password through a hidden prompt, then enabled only the selected
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

I connected to MGMT01 through SSM, confirmed its hostname and tested the domain
credentials using the following commands. I reported `true` during the study session;
I did not paste the full authentication command output into that session.

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

I entered the password through the hidden prompt and excluded it from this report.
The instructions included cleanup commands; I did not separately record their execution.

## Evidence and limits

[My selected evidence](../../evidence/published/2026-10-20-labuser002-account-recovery.txt)
distinguishes the pasted account-state output from my brief confirmation of the
authentication result.

I verified acceptance of domain credentials from MGMT01. I did not test a new
RDP/desktop sign-in, application authorization, group membership changes, lockout
recovery or a failed-authentication comparison before repair. I did not measure
recovery time or production impact.

My earlier SSM connection attempt failed while both EC2 instances were stopped.
I started both instances, verified that they reported Online and connected through SSM.
I treated that management availability issue separately from the disabled-account condition.

## Interview explanation

I inspected a disabled synthetic AD account and distinguished its disabled state
from a lockout. I reset its password through a hidden prompt, enabled the account,
verified its updated properties, and confirmed domain credential validation from
a member server. I documented the evidence and the limits of the authentication test.
