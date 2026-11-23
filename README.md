# Systems Administration Labs

**Guot Deng Anyak | Windows, Linux, AWS, networking and automation**

I build and troubleshoot infrastructure in these labs alongside my AI Infrastructure Incident Assistant project.
The first track builds a self-managed Active Directory domain on two Windows Server EC2
instances. It covers DNS, PowerShell user provisioning, domain membership, Group Policy
and incident investigation. Later tracks cover Linux, DHCP/NAT, AWS operations and automation.

**Status: I deployed Active Directory, provisioned users, joined the member server
and verified the initial Group Policy exercise on October 19, 2026. On October 20,
I reproduced, diagnosed and repaired a DNS fault on MGMT01. I also recovered the
disabled labuser002 account and verified its domain credentials from MGMT01.
Additional validation and recovery exercises remain.**

Read the [completed lab results](docs/completed-ad-lab.md) and the
[published Group Policy evidence excerpt](evidence/published/labuser001-group-policy.txt).
The [DNS incident report](docs/incidents/2026-10-20-mgmt01-dns-recovery.md) documents a
failed lookup, resolver comparison, repair and domain-connectivity checks.
The [disabled-account recovery report](docs/incidents/2026-10-20-labuser002-account-recovery.md)
records how I checked the account, recovered it and confirmed domain credential validation.

## Terraform deployment portfolio

The [Terraform AWS network deployment lab](practice/terraform-network-live/README.md)
provides a separate create, verify, update, drift and cleanup walkthrough with
mock-provider checks. It uses a dedicated VPC range and its own local state.
**Status: deployment, in-place tag update and cleanup demonstrated on October 25, 2026 from supplied terminal output. Five resources were created, three updated and all five destroyed; state is empty and the final destroy plan has no remaining actions. Deliberate drift testing remains pending.**
See the [evidence checklist](practice/terraform-network-live/EVIDENCE.md).
The existing Windows AD environment remains managed by CloudFormation.

## Microsoft 365 administration

I am starting a separate [Microsoft 365 administration track](practice/microsoft-365/README.md)
covering Entra ID, user lifecycle, roles, authentication security, Exchange Online,
SharePoint Online, Teams and Intune where licensing permits.
**Status: planned; tenant access and licenses are not yet confirmed.**
Start with [tenant readiness and secure administration](practice/microsoft-365/modules/01-tenant-readiness.md).
Local examples are simulations, not completed cloud exercises. Existing AD, AWS,
Terraform, backup and AI engineering work remains separate.

## Start here

1. Read [START-HERE.md](START-HERE.md).
2. Run `bash scripts/mac-inventory.sh` on your Mac (read-only).
3. Follow [AWS environment setup](docs/aws-setup.md) to launch only when ready for charges.
4. Work through the [Active Directory track](windows/active-directory/README.md).
5. Add actual evidence using [the report template](templates/lab-report.md).
6. Follow [GitHub publishing](docs/github-publishing.md).

## Portfolio tracks

| Track | Scope | Current status |
|---|---|---|
| Windows / Active Directory | AD DS, DNS, 150 synthetic accounts / five OUs, domain join, GPO, troubleshooting | Core deployment, user counts, domain join, first GPO, DNS fault recovery and disabled-account recovery verified; further recovery planned |
| Microsoft 365 | Entra ID, lifecycle, security, collaboration and licensed endpoint management | Planned; tenant and licensing unconfirmed; readiness guide available |
| Linux | Users, permissions, systemd, storage, patching, logs, backup/restore | Planned |
| Networking | DHCP scopes/leases, isolated routing/NAT, DNS and firewall faults | Planned |
| AWS operations | EC2, IAM, monitoring, backups and incident investigation | Lab infrastructure deployed with CloudFormation and accessed through SSM; further operations exercises planned |
| Automation | PowerShell, Bash and Python operational tasks | PowerShell CSV user provisioning executed; further automation planned |

The [roadmap](docs/roadmap.md) preserves all agreed labs without changing the existing
12-week AI engineering program. Administration sessions are on Tuesdays and Thursdays;
AI engineering sessions are on Mondays, Wednesdays and Fridays.

## Lab design

- `DC01`: Windows Server 2025, AD DS and DNS, `10.77.10.10`.
- `MGMT01`: Windows Server 2025 member server, `10.77.10.20`.
- Domain: `ad.guotlab.test`; NetBIOS: `GUOTLAB`.
- AWS subnet: `10.77.10.0/24` within lab VPC `10.77.0.0/16`.
- SSM port forwarding for RDP; no public inbound security-group rules.
- Two x86 instances, encrypted EBS, IMDSv2; public IPs supply outbound internet access.

```mermaid
flowchart TD
  Mac["Mac: VS Code and Git"] --> SSM["SSM authenticated tunnel"]
  SSM --> DC["DC01: AD DS and DNS"]
  SSM --> Member["MGMT01: member server"]
  Member --> DC
```

This is an isolated learning environment, not a highly available production design.
Internal security-group traffic is intentionally broad between only these two lab machines.
Windows Firewall remains enabled; later exercises examine narrower rules.
A server member provides domain-join practice, but is not a Windows 11 workstation.

## Validation

[VALIDATION.md](VALIDATION.md) distinguishes starter-package checks, observed lab results
and checks still pending. [Published evidence](evidence/published/README.md) includes
labeled excerpts of my Group Policy, DNS troubleshooting and disabled-account recovery results.

## Backup and restore practice

The [guided backup lab](practice/backup-restore/README.md) covers fictional file creation,
backup integrity checks, simulated loss and validated file restoration in Bash and PowerShell.
User execution is pending; Linux workspace script checks are recorded separately.
Windows Server Backup, AWS EBS recovery and AD disaster recovery remain environment-dependent
follow-up work, not completed labs.
