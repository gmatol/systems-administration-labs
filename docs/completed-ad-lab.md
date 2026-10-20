# Active Directory Lab — Verified Results

Completed: October 19, 2026

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

## Evidence
[Group Policy result excerpt](../evidence/published/labuser001-group-policy.txt)

## Planned practice
Additional Windows, Linux, networking, AWS, and automation exercises.
