# Lab 04: Group Policy and effective settings

**Status: not executed.** Use DC01 Group Policy Management (`gpmc.msc`).

1. On DC01 create an additional OU named `LabWorkstations`. The five department OUs
   from lab 02 remain unchanged. Move MGMT01's computer object into LabWorkstations.
2. Create `LAB-Workstation-Lock` and link it to LabWorkstations only.
3. Edit Computer Configuration > Policies > Windows Settings > Security Settings >
   Local Policies > Security Options > Interactive logon: Machine inactivity limit.
   Set 900 seconds for this lab. Keep the GPO away from the Domain Controllers OU.
4. On MGMT01 run `gpupdate /force` and `gpresult /r /scope computer` as Administrator.
   Use `gpresult /h C:\Lab\gpresult.html` and inspect the applied GPO and scope.
5. Verify the effective setting in Local Security Policy and, with no activity, observe
   whether the session locks after the configured interval. Record actual behavior.

Password and lockout policy exercise: inspect current domain policy with
`Get-ADDefaultDomainPasswordPolicy`. Domain account password policy is domain-scoped;
linking a password-policy GPO to a user OU does not set domain-user passwords.
Capture the existing values before any changes. For an optional lab change on DC01:

```powershell
$before = Get-ADDefaultDomainPasswordPolicy
Set-ADDefaultDomainPasswordPolicy -Identity ad.guotlab.test `
  -MinPasswordLength 14 -ComplexityEnabled $true `
  -LockoutThreshold 10 -LockoutDuration '00:15:00' -LockoutObservationWindow '00:15:00'
Get-ADDefaultDomainPasswordPolicy
```

Use a disposable non-admin account for any lockout test. Keep an active admin session.
These are practice settings, not a claim of a CIS or NIST compliance baseline.
Evidence: GPO link/scope, gpresult, effective inactivity value and observed behavior.
Rollback: unlink LAB-Workstation-Lock, refresh policy; restore domain settings from the
captured `$before` values. If closing the session first, record those values securely.
