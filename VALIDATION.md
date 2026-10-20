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

## Checks and exercises still pending

- Full domain-controller health checks, including dcdiag.
- Re-running the provisioning script to verify duplicate avoidance in the live domain.
- Running every supplied PowerShell script end to end; some setup steps were performed manually.
- Group Policy rollback and comparison with an unaffected user.
- Deliberate fault injection, recovery, backup/restore and tighter firewall exercises.
- Linux, DHCP/NAT and the remaining AWS and automation tracks.

Deployment success does not establish production readiness or complete every exercise
in the starter package. There are no automated live-infrastructure tests in this repository.
