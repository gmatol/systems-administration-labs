# Validation and limitations

Updated October 20, 2026 (America/Denver).

## Starter-package checks — October 18, 2026

Checks recorded when the original package was prepared:
- CloudFormation YAML loads and references resolve to declared resources/parameters.
- Exactly two Windows EC2 hosts; fixed distinct private IPs; encrypted disks; IMDSv2.
- No public inbound security-group rule; internal ingress is restricted by lab SG.
- CSV has 150 unique synthetic account names, five departments and 30 users each.
- Shell script passes `bash -n` and rejects non-macOS environments.
- Relative Markdown links point to files in the package.
- ZIP integrity checked before delivery.

## Observed lab results — October 19, 2026

The learner supplied terminal output and screenshots during the guided session:
- CloudFormation service-side template validation succeeded.
- The Windows Server 2025 AMI parameter resolved and the stack deployment succeeded.
- Both Windows instances reported Online in Systems Manager; SSM shell and RDP access worked.
- DC01 returned domain `ad.guotlab.test` and NetBIOS name `GUOTLAB`.
- The domain-controller LDAP SRV lookup returned DC01 at `10.77.10.10`.
- MGMT01 reported domain membership and a healthy secure channel.
- User counts showed 150 synthetic accounts, with 30 each in IT, HR, Finance, Operations and Support.
- All 150 accounts were initially disabled; labuser001 was subsequently enabled for testing.
- The practice user ran PowerShell on MGMT01 and accessed the domain SYSVOL share.
- labuser001 was added to MGMT01's local Remote Desktop Users group and signed in.
- The learner confirmed Control Panel displayed a restrictions message for this user.
- `gpresult /r /scope:user` identified the IT OU, DC01 as the policy source,
  and `LAB-IT-ControlPanel-Restriction` as an applied GPO.

The [published Group Policy evidence](evidence/published/labuser001-group-policy.txt)
is a labeled excerpt of the output supplied during that session. Other observations
above were checked from session output; their complete logs are not published here.
See the [completed lab summary](docs/completed-ad-lab.md).

## Observed DNS fault and recovery — October 20, 2026

From learner-provided PowerShell output on MGMT01:
- Baseline DNS was `10.77.10.10`; the domain LDAP SRV query returned DC01.
- After switching MGMT01 to `10.77.0.2` and clearing its DNS cache, the default-resolver
  SRV query failed with `DNS_ERROR_RCODE_NAME_ERROR`.
- While the incorrect setting remained in place, querying `10.77.10.10` explicitly
  returned the expected SRV record and DC01 address.
- Restoring `10.77.10.10` and clearing the cache restored the default-resolver query.
- `nltest /dsgetdc:ad.guotlab.test /force` returned DC01 and completed successfully.
- `Test-ComputerSecureChannel -Verbose` returned True and reported a healthy channel.

The [incident report](docs/incidents/2026-10-20-mgmt01-dns-recovery.md) links to
[selected output excerpts](evidence/published/2026-10-20-mgmt01-dns-recovery.txt).
The exercise used an interactive SSM PowerShell session. The RDP port-forwarding
connection failed before fault injection and remains unresolved; it is not counted as
a DNS-recovery result. A new interactive user login after repair was not tested.

## Observed disabled-account recovery — October 20, 2026

- On DC01, labuser002 initially showed Enabled False, LockedOut False and a blank PasswordLastSet.
- After the instructed password reset and enablement, pasted output showed Enabled True,
  LockedOut False and PasswordLastSet populated.
- After connecting to MGMT01, the learner confirmed that the instructed
  PrincipalContext.ValidateCredentials test returned True. This was a brief confirmation,
  not a pasted complete authentication transcript.
- No new desktop sign-in, lockout recovery or failed-authentication baseline was demonstrated.

See the [account recovery report](docs/incidents/2026-10-20-labuser002-account-recovery.md)
and [selected evidence](evidence/published/2026-10-20-labuser002-account-recovery.txt).
The account was already disabled by provisioning; a full disable/fail/restore comparison
remains pending.

## Checks and exercises still pending

- Full domain-controller health checks, including dcdiag.
- Re-running the provisioning script to verify duplicate avoidance in the live domain.
- Running every supplied PowerShell script end to end; some setup steps were performed manually.
- Group Policy rollback and comparison with an unaffected user.
- Full disabled-user failed-authentication comparison, GPO-link and deleted-object recovery exercises; backup/restore and tighter firewall exercises.
- Investigating the separate RDP/SSM port-forwarding connection issue.
- Linux, DHCP/NAT and the remaining AWS and automation tracks.

Deployment success does not establish production readiness or complete every exercise
in the starter package. There are no automated live-infrastructure tests in this repository.
