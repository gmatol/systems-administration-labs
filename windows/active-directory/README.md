# Active Directory deployment and PowerShell practice

All exercises are **pending execution**. Allocate one administration session each week;
continue your existing AI engineering sessions separately.

| Order | Exercise | Completion evidence |
|---|---|---|
| 00 | [AWS host setup](../../docs/aws-setup.md) | Correct names/IPs; SSM and RDP checks |
| 01 | [Domain and DNS](labs/01-domain-and-dns.md) | AD domain, SRV lookup and dcdiag |
| 02 | [Five OUs and 150 users](labs/02-users-and-ous.md) | CSV, counts, rerun without duplicates |
| 03 | [Join member server](labs/03-domain-join.md) | Domain membership and secure channel |
| 04 | [Group Policy](labs/04-group-policy.md) | GPO scope, gpresult and effective settings |
| 05 | [Troubleshoot and recover](labs/05-troubleshooting.md) | Before/after evidence and root cause |

Commands below assume an elevated **Windows PowerShell 5.1** session on the indicated
Windows host, not PowerShell on the Mac. Download or paste scripts into `C:\Lab` on the
correct host; read each before execution. Use the Mac only for Git, AWS CLI and RDP.
