# Active Directory Lab — Verified Results

Core setup completed: October 19, 2026

DNS troubleshooting and recovery verified: October 20, 2026

## Environment
- Two Windows Server 2025 instances on AWS.
- DC01: domain controller and DNS server.
- MGMT01: domain-joined member server.
- Domain: ad.guotlab.test
- Remote access through AWS Systems Manager port forwarding.

## Completed exercises
- Deployed the AWS infrastructure using CloudFormation.
- Configured Active Directory Domain Services and DNS.
- Joined MGMT01 to the domain and verified its secure channel.
- Created 150 synthetic users across five departmental OUs using PowerShell.
- Verified 30 users each in IT, HR, Finance, Operations, and Support.
- Enabled labuser001 and tested domain authentication on MGMT01.
- Verified the practice user could access SYSVOL.
- Configured LAB-IT-ControlPanel-Restriction for the IT OU.
- Confirmed Control Panel was blocked for labuser001.
- Used gpresult to confirm the policy applied from DC01.

## DNS incident exercise — October 20, 2026

- Recorded a working LDAP SRV lookup with MGMT01 using DC01 for DNS.
- Introduced an incorrect client DNS setting and captured the resulting lookup failure.
- Compared the failing default resolver with a successful direct query to DC01.
- Restored the client DNS setting, cleared the cache and verified the normal lookup.
- Confirmed domain-controller discovery and a healthy computer secure channel.

[DNS incident report](incidents/2026-10-20-mgmt01-dns-recovery.md)

## Evidence
- [Group Policy result excerpt](../evidence/published/labuser001-group-policy.txt)
- [DNS fault and recovery excerpts](../evidence/published/2026-10-20-mgmt01-dns-recovery.txt)

## Planned practice
Additional Windows, Linux, networking, AWS, and automation exercises.
