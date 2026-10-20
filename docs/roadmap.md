# Administration practice alongside AI engineering

Keep the existing 12-week AI engineering roadmap. Add one administration session each
week, 60-90 minutes if practical. Finish one checkpoint before starting another.

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

Sessions 7-12 are scope placeholders, not implemented lab guides. Build them as you reach
them. DHCP and router/NAT exercises must use an isolated local virtual network or another
appropriate network lab: the included AWS subnet uses AWS DHCP and is not a drop-in
network for a Windows DHCP server. Never bridge a practice DHCP server to the home LAN.

The first recovery exercise uses AD Recycle Bin; full system-state backup and disaster
recovery is later work. Physical hardware replacement, iDRAC, RAID and rack/cabling
practice require suitable hardware and must not be claimed from virtual labs.

After each completed admin incident, use its sanitized evidence to evaluate the existing
AI assistant. Preserve the current AI session recap, hands-on task, three check questions
and next goal format.
