# Administration practice alongside AI engineering

Keep the existing 12-week AI engineering curriculum and project sequence.

- Tuesdays and Thursdays: administration labs, 60-90 minutes if practical.
- Mondays, Wednesdays and Fridays: AI engineering on the existing project.
- Weekends: optional catch-up or rest.

Study reminders use America/Denver time: AI at 9:00 AM and administration around 9:00 AM.
Finish one checkpoint before starting another; the table below describes the project
sequence rather than a requirement to complete each topic in one session.

| Sessions | Track | Practice |
|---|---|---|
| 1 | Environment | Mac inventory, AWS hosts, SSM/RDP, baseline evidence |
| 2 | Windows | AD DS, DNS, domain health |
| 3 | Automation / IAM | Five OUs, 150 synthetic users, safe reruns |
| 4 | Windows | Domain join, authentication and permissions |
| 5 | Windows security | GPO scope, password/lockout policy, effective settings |
| 6 | Incident response | DNS/login/GPO faults and deleted-object recovery |
| 7 | Linux | Users/groups, permissions, sudo and filesystem navigation |
| 8 | Linux operations | systemd, logs, updates, disk usage and backup restore |
| 9 | Networking | Isolated DHCP scope, exclusions, reservations and lease recovery |
| 10 | Networking | Separate router/NAT lab and firewall troubleshooting |
| 11 | AWS | EC2 monitoring, IAM, backup/restore and incident evidence |
| 12 | Portfolio | Reproduce a lab, review evidence, record a 3-minute demonstration |

**Progress:** core AD setup, account provisioning, domain join and the initial GPO test
are verified. The MGMT01 DNS fault and recovery exercise is also verified; the remaining
incident-response exercises are pending.

Sessions 7-12 remain mostly scope placeholders. A [guided file backup/restore lab](../practice/backup-restore/README.md)
now supports part of Session 8; user execution is pending. Session 11 AWS recovery and
later AD system-state/DR work remain pending. Build the remaining guides as you reach them. DHCP and router/NAT exercises must use an isolated local virtual network or another
appropriate network lab: the included AWS subnet uses AWS DHCP and is not a drop-in
network for a Windows DHCP server. Never bridge a practice DHCP server to the home LAN.

The first recovery exercise uses AD Recycle Bin; full system-state backup and disaster
recovery is later work. Physical hardware replacement, iDRAC, RAID and rack/cabling
practice require suitable hardware and must not be claimed from virtual labs.

After each completed admin incident, use its sanitized evidence to evaluate the existing
AI assistant. Preserve the current AI session recap, hands-on task, three check questions
and next goal format.

## Next administration project: Microsoft 365

I selected the separate [Microsoft 365 track](../practice/microsoft-365/README.md)
as my next hands-on administration project on November 3, 2026. It takes the next
Tuesday/Thursday administration sessions; the earlier table remains the backlog,
not a requirement to finish Linux/networking first. AI engineering remains unchanged.

Follow Modules 01–08: readiness and secure administration; Entra identities/groups/roles;
joiner/mover/leaver lifecycle; authentication security; Exchange; SharePoint and Teams;
licensed Intune; troubleshooting and portfolio review. Allow roughly 12–16 sessions,
with tenant or licensing blockers recorded rather than hidden.

Start [Module 01](../practice/microsoft-365/modules/01-tenant-readiness.md) locally.
Tenant, administrator access and licenses are unconfirmed. No subscription purchase,
tenant changes or device enrollment is authorized by this roadmap.
