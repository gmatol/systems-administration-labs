# Lab 05: controlled faults and recovery

**Status: exercise A (wrong DNS on MGMT01) was verified on October 20, 2026.
Exercise B account recovery and credential validation were also verified that day;
a failed-authentication comparison and exercises C-D remain pending.** Perform one fault at a time on disposable lab resources.
Keep a working management connection. Exercise A was completed through interactive SSM
PowerShell while the separate RDP tunnel issue remained unresolved. Use the incident
report template for each.

## A. Wrong DNS on MGMT01

[Verified incident report](../../../docs/incidents/2026-10-20-mgmt01-dns-recovery.md)
and [selected output](../../../evidence/published/2026-10-20-mgmt01-dns-recovery.txt).

Use an administrative Windows PowerShell session on **MGMT01**. Keep the original
resolver setting available before introducing the fault.

1. Record `hostname` and `Get-DnsClientServerAddress -InterfaceAlias "Ethernet" -AddressFamily IPv4`.
   Verify the normal LDAP SRV query succeeds with DNS set to `10.77.10.10`.
2. Temporarily set MGMT01's DNS to VPC resolver `10.77.0.2`, clear the DNS client cache
   and repeat the SRV query. Record the actual error.
3. While the incorrect client setting is still active, query DC01 directly using
   `-Server 10.77.10.10`. A successful direct query isolates the client resolver choice.
4. Restore DNS to `10.77.10.10`, clear the cache and repeat the normal query without
   specifying a server.
5. Run `nltest /dsgetdc:ad.guotlab.test /force` and `Test-ComputerSecureChannel -Verbose`
   to check domain-controller discovery and the member server's secure channel.

The SRV query used in the session was:

```powershell
Resolve-DnsName -Name "_ldap._tcp.dc._msdcs.ad.guotlab.test" -Type SRV -DnsOnly
```

Fault command, on MGMT01:

```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 10.77.0.2
Clear-DnsClientCache
```

Recovery command, on MGMT01:

```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 10.77.10.10
Clear-DnsClientCache
```

Cached logins or records can still work; a cached result is not proof the DNS change was
harmless. No interactive login failure was demonstrated in this exercise. Do not change
DC01's DNS configuration for this fault.

## B. Disabled user

[Verified account recovery report](../../../docs/incidents/2026-10-20-labuser002-account-recovery.md) and
[selected evidence](../../../evidence/published/2026-10-20-labuser002-account-recovery.txt).

The completed exercise used labuser002, which was already disabled by provisioning.
On DC01, inspect Enabled, LockedOut and PasswordLastSet, enter a unique password through
a hidden prompt, reset the password and enable the account. Verify the properties.
Then test domain credentials from MGMT01 using the report's PowerShell instructions.
I confirmed True during the session; I did not test a new desktop sign-in.

For a later controlled-fault comparison, use a dedicated disposable account with a
known private password. Verify authentication before disabling it, record a new failed
authentication after disabling, restore the account, and verify again. That comparison
has not yet been completed. Existing sessions may persist after account disablement.

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
