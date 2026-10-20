# Lab 05: controlled faults and recovery

**Status: not executed.** Perform one fault at a time on disposable lab resources.
Keep working RDP/SSM connectivity. Use the incident report template for each.

## A. Wrong DNS on MGMT01

Record the NIC's DNS settings, then temporarily use VPC DNS `10.77.0.2` on MGMT01.
Run `Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.ad.guotlab.test` and
`nltest /dsgetdc:ad.guotlab.test /force`. Capture results. Cached logins or records can
still work; a cached result is not proof the DNS change was harmless. Restore DNS to
`10.77.10.10`, run `Clear-DnsClientCache`, and repeat. Do not change DC01 DNS for this fault.

## B. Disabled user

Enable a disposable user with its own password, verify authentication with runas, then
`Disable-ADAccount labuser001` on DC01. Try a NEW authentication, record the exact error,
inspect `Get-ADUser labuser001 -Properties Enabled`, restore with `Enable-ADAccount`,
and retest. Existing sessions may persist and must not be mistaken for a new login.

## C. Missing GPO link

Unlink LAB-Workstation-Lock from LabWorkstations. Refresh policy and inspect gpresult.
Some security settings can persist after unlinking; check the effective setting as well.
Restore the link, refresh and verify. Explain scope, refresh timing and resultant policy.

## D. Deleted disposable account recovery

On DC01 check AD Recycle Bin first:

```powershell
Get-ADOptionalFeature -Filter 'Name -eq "Recycle Bin Feature"' | Select-Object Name,EnabledScopes
```

If it is disabled, enabling AD Recycle Bin is irreversible for this forest. This is a
throwaway lab: enable it intentionally before deleting any test user:

```powershell
Enable-ADOptionalFeature 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target ad.guotlab.test
```

Create one disabled account named `recovery-demo` in the IT OU. Save its ObjectGUID,
delete only that account, then query deleted objects by the saved GUID and use
`Restore-ADObject -Identity <saved-guid>`. Verify the restored OU, attributes and disabled
state. Do not delete one of the 150 CSV accounts for this exercise. Recovery Bin is
object recovery, not a substitute for AD system-state backups.

## AI connection

After fixing the fault, submit only sanitized symptoms/logs to your existing Incident
Assistant. Record its likely cause, recommended checks, missed risks and whether the
advice matches your verified fix. Do not execute its suggestions automatically. Keep the
current AI project API schema and 12-week roadmap; no API contract is assumed here.

Measure actual time to diagnosis and recovery if useful. Report the observed duration
and limitations; never invent uptime, MTTR reduction or business impact from a single lab.
