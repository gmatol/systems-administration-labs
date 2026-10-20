# Active Directory deployment and PowerShell practice

Core deployment and the first user-policy test were verified during the October 19,
2026 session. Continue your existing AI engineering sessions separately.

| Order | Exercise | Observed status |
|---|---|---|
| 00 | [AWS host setup](../../docs/aws-setup.md) | Stack deployed; host names/IPs and SSM/RDP access verified |
| 01 | [Domain and DNS](labs/01-domain-and-dns.md) | Domain and SRV lookup verified; dcdiag pending |
| 02 | [Five OUs and 150 users](labs/02-users-and-ous.md) | Creation and departmental counts verified; duplicate-avoidance rerun pending |
| 03 | [Join member server](labs/03-domain-join.md) | Domain membership and secure channel verified |
| 04 | [Group Policy](labs/04-group-policy.md) | IT user received Control Panel restriction; gpresult confirmed applied GPO |
| 05 | [Troubleshoot and recover](labs/05-troubleshooting.md) | Planned; fault and recovery evidence pending |

See [verified results](../../docs/completed-ad-lab.md),
[Group Policy evidence](../../evidence/published/labuser001-group-policy.txt)
and [validation limits](../../VALIDATION.md).

Run setup and management commands in an elevated **Windows PowerShell 5.1** session on
the indicated Windows host. Run standard-user authentication and policy checks as the
practice user, without elevation. Use the Mac Terminal for Git and AWS CLI commands.
The Mac Terminal prompt normally ends in `%`; Windows PowerShell starts with `PS C:\`.

The Active Directory files were copied to `C:\Lab\ActiveDirectory` on DC01 during the
guided session. Read each script before running it on the appropriate host.
