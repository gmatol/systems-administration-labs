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

I performed the following work:
- I deployed the AWS infrastructure using CloudFormation.
- I configured Active Directory Domain Services and DNS.
- I joined MGMT01 to the domain and verified its secure channel.
- I created 150 synthetic users across five departmental OUs using PowerShell.
- I verified 30 users each in IT, HR, Finance, Operations, and Support.
- I enabled labuser001 and tested domain authentication on MGMT01.
- I verified the practice user could access SYSVOL.
- I configured LAB-IT-ControlPanel-Restriction for the IT OU.
- I confirmed Control Panel was blocked for labuser001.
- I used gpresult to confirm the policy applied from DC01.

## DNS incident exercise — October 20, 2026

- I recorded a working LDAP SRV lookup with MGMT01 using DC01 for DNS.
- I introduced an incorrect client DNS setting and captured the resulting lookup failure.
- I compared the failing default resolver with a successful direct query to DC01.
- I restored the client DNS setting, cleared the cache and verified the normal lookup.
- I confirmed domain-controller discovery and a healthy computer secure channel.

[DNS incident report](incidents/2026-10-20-mgmt01-dns-recovery.md)

## Evidence
- [Group Policy result excerpt](../evidence/published/labuser001-group-policy.txt)
- [DNS fault and recovery excerpts](../evidence/published/2026-10-20-mgmt01-dns-recovery.txt)

## Planned practice
Additional Windows, Linux, networking, AWS, and automation exercises.
