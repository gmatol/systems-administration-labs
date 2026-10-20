# MGMT01 DNS troubleshooting and recovery

Date: October 20, 2026 (America/Denver)  
Environment: isolated Windows Server 2025 lab on AWS  
Method: guided manual exercise; observed results came from learner-provided terminal output

## Problem and result

A controlled DNS-client misconfiguration on MGMT01 caused the domain-controller LDAP
service lookup to fail with `DNS_ERROR_RCODE_NAME_ERROR`. A direct query to DC01 still
succeeded. Restoring MGMT01's DNS server to `10.77.10.10` restored the normal lookup.
Domain-controller discovery then succeeded and the computer secure channel was healthy.

## Environment and baseline

| Item | Value |
|---|---|
| Member server | MGMT01 |
| AD domain | ad.guotlab.test |
| Domain controller / AD DNS | DC01.ad.guotlab.test / 10.77.10.10 |
| VPC DNS resolver used for the fault | 10.77.0.2 |
| LDAP SRV record | _ldap._tcp.dc._msdcs.ad.guotlab.test |

Before the change, MGMT01 used `10.77.10.10`. Its SRV query returned
`dc01.ad.guotlab.test`, LDAP port 389, and address `10.77.10.10`.

## Fault and diagnosis

1. Changed only MGMT01's Ethernet DNS server to `10.77.0.2`.
2. Cleared the client DNS cache and repeated the SRV query using the configured resolver.
3. Observed `DNS name does not exist` and `DNS_ERROR_RCODE_NAME_ERROR`.
4. Confirmed MGMT01 still had `10.77.0.2` configured.
5. Repeated the same lookup with `-Server 10.77.10.10`; DC01 returned the correct record.

The resolver comparison localized the problem to MGMT01's DNS configuration. It showed
that DC01 was reachable and could answer this query; it did not establish the health of
every AD or DNS service.

**Root cause:** MGMT01 was pointed at a resolver that did not resolve this lab's AD
service record, instead of the domain's DNS server. The observed result was a name
resolution failure, not a DNS timeout.

## Repair and verification

Restored the original DNS server on MGMT01:

```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 10.77.10.10
Clear-DnsClientCache
```

Verification after repair:

| Check | Observed result |
|---|---|
| Get-DnsClientServerAddress | Ethernet IPv4 DNS: 10.77.10.10 |
| Resolve-DnsName using the default resolver | DC01 SRV record returned successfully |
| nltest /dsgetdc:ad.guotlab.test /force | DC01 at 10.77.10.10; command completed successfully |
| Test-ComputerSecureChannel -Verbose | True; secure channel in good condition |

## Evidence and limits

[Selected command-output excerpts](../../evidence/published/2026-10-20-mgmt01-dns-recovery.txt)
show the baseline, fault, resolver comparison and recovery.

The exercise ran through an interactive AWS SSM PowerShell session. An RDP connection
attempt returned 0x204, and the port-forwarding session did not open its local port,
before DNS fault injection. A normal SSM shell worked. The RDP tunnel issue remains
unresolved and is tracked separately from the DNS repair.

No new interactive user login after repair, application outage, measured recovery time
or production impact was demonstrated. Cached logins can continue to work during a DNS
fault. The final secure-channel result is a verification result, not evidence that the
domain trust had previously broken.

## Interview explanation

I reproduced a client DNS misconfiguration in my AD lab. The member server could not
resolve the domain-controller LDAP service record through its configured resolver.
I queried the AD DNS server directly and received the correct record, which isolated
the client setting. I restored the original resolver, cleared the cache, and verified
normal DNS lookup, domain-controller discovery and the computer secure channel.

## Next practice

Investigate the separate SSM port-forwarding issue, then continue the pending account,
Group Policy and deleted-object recovery exercises. Preserve the existing AI engineering
project and use this incident's sanitized evidence for a later evaluation exercise.
