# AWS environment setup

## Before deployment

This guide uses two **Windows Server 2025 Amazon-provided EC2 AMIs**, not the Microsoft
evaluation ISO. Windows licensing is part of the applicable EC2 Windows charges.
The template creates two `t3.medium` instances with 40 GiB gp3 disks each.
Compute, EBS and public IPv4 addresses can incur charges; CPU credits may also apply
(the template uses standard CPU credit mode to avoid surplus-credit charges).
Check current AWS prices in your chosen region; no free-tier eligibility is assumed.
Stopping instances does not eliminate EBS charges. Budget alerts are delayed notifications,
not a spending cap. Delete the stack when finished, after exporting your evidence.

Use an AWS sandbox account. Prerequisites:

- AWS console access to create CloudFormation, VPC, EC2 and IAM resources.
- AWS CLI v2, AWS Session Manager plugin and an RDP client on the Mac.
- Valid authenticated AWS CLI profile. Never paste AWS credentials into GitHub or chat.
- Permission for `ssm:StartSession`, session documents, and associated terminate/resume
  actions; ability to view instance and stack details. Follow AWS's session access policy.
- No organizational restriction preventing the included AmazonSSMManagedInstanceCore
  role, public IP assignment or outbound HTTPS access.

Use `us-east-1` consistently for this starter. The subnet must not overlap any network
that you later connect through VPN. This initial design has no VPN or local client join.

## 1. Confirm identity and AMI (read-only)

```bash
aws sts get-caller-identity
aws ssm get-parameter \
  --name /aws/service/ami-windows-latest/Windows_Server-2025-English-Full-Base \
  --region us-east-1 --query Parameter.Value --output text
```

If the parameter is absent, list available Windows parameters and select an Amazon
Full-Base image in the region. Do not substitute an ARM AMI for the x86 instance type.

```bash
aws ssm get-parameters-by-path --path /aws/service/ami-windows-latest \
  --region us-east-1 --query 'Parameters[].Name' --output text
```

## 2. Create a budget alert

In AWS Billing and Cost Management > Budgets, create a monthly cost budget suitable for
your account, with actual-cost and forecast alerts sent to your verified email. Review
estimated charges before the next step. This package does not create an automatic shutdown.

## 3. Deploy

Console route: CloudFormation > Create stack > With new resources > Upload a template file.
Choose `infrastructure/aws/admin-lab.yaml`. Name the stack `guot-admin-lab`. Keep the
Windows AMI parameter default. Acknowledge IAM resource creation and submit.

CLI equivalent, from the repository folder (creates billable resources):

```bash
aws cloudformation validate-template \
  --template-body file://infrastructure/aws/admin-lab.yaml --region us-east-1
aws cloudformation deploy --stack-name guot-admin-lab \
  --template-file infrastructure/aws/admin-lab.yaml \
  --capabilities CAPABILITY_IAM --region us-east-1
aws cloudformation describe-stacks --stack-name guot-admin-lab \
  --region us-east-1 --query 'Stacks[0].Outputs' --output table
```

Wait for `CREATE_COMPLETE` and Windows startup. Copy the two instance IDs from Outputs.
A created EC2 host is not yet an AD domain controller. Do not update the stack casually:
resolving a newer AMI on an update can replace an instance and erase lab changes.

## 4. Check Systems Manager

Systems Manager > Fleet Manager: both instances should appear as managed nodes.
If absent, check EC2 status checks, the attached IAM instance profile, outbound HTTPS,
public IP, internet gateway route, DNS and SSM Agent. Never open public RDP to fix SSM.

## 5. Set administrator passwords and names

Before domain promotion, open Systems Manager > Session Manager > Start session for DC01.
Run the following in the interactive Windows PowerShell session. Save the password in
your password manager; it is never stored in the template or repo.

```powershell
$admin = Get-LocalUser | Where-Object { $_.SID.Value -match '-500$' }
$password = Read-Host 'Choose a unique local Administrator password' -AsSecureString
$admin | Set-LocalUser -Password $password
$admin | Enable-LocalUser
Remove-Variable password
```

Repeat on MGMT01 with a DIFFERENT password. Before promotion, the DC01 administrator
password becomes your initial domain Administrator password, so retain it.

Paste the contents of `windows/active-directory/scripts/01-baseline.ps1` into a local
file on each Windows host or the interactive PowerShell session. Run it with `-ComputerName
DC01` on the first host, `-ComputerName MGMT01` on the second. Reboot as directed.
The EC2 Name tag alone does not rename Windows.

## 6. Tunnel RDP from Mac

In a Mac Terminal (replace `i-REPLACE-DC01` with the actual DC01 instance ID):

```bash
aws ssm start-session --target i-REPLACE-DC01 \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["3389"],"localPortNumber":["13389"]}' \
  --region us-east-1
```

Keep the terminal open. In the RDP client connect to `127.0.0.1:13389`, username
`DC01\Administrator` before promotion. Use your saved password. Use a second Terminal
with MGMT01's instance ID and local port `13390` to connect to `127.0.0.1:13390`.

After promotion, use `GUOTLAB\Administrator` on DC01. Interactive SSM shells on domain
controllers have extra account requirements; use the SSM RDP tunnel for subsequent labs.
Port forwarding does not need an `ssm-user` interactive login on the target Windows OS.
Do not create a privileged domain `ssm-user` just to work around shell failures.

## 7. Checkpoint

Run `hostname`, `Get-Service AmazonSSMAgent`, and `Get-NetIPConfiguration` on each host.
Confirm DC01 is `10.77.10.10`, MGMT01 is `10.77.10.20`, both can reach Windows Update,
and RDP is accessible only through the authenticated tunnel from your Mac.
Use [lab 01](../windows/active-directory/labs/01-domain-and-dns.md) next.

## Session shutdown and cleanup

Stop MGMT01 first, then DC01 using EC2 > Instance state > Stop. Start DC01 first at the
next session and wait for AD/DNS before starting MGMT01. Stop does not reset the domain.
Private IPs remain allocated across stop/start; public IPs can change.

For a complete teardown, export sanitized evidence, then:

```bash
aws cloudformation delete-stack --stack-name guot-admin-lab --region us-east-1
aws cloudformation wait stack-delete-complete --stack-name guot-admin-lab --region us-east-1
```

Deletion permanently removes both instances and their lab disks. Check CloudFormation
and EC2 afterward for any failed deletion or separately created snapshots/resources.
The account-level budget you created manually remains in place.

## Sources

- [AWS Windows AMI parameters](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html)
- [SSM sessions and port forwarding](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-sessions-start.html)
- [SSM user permissions](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-ssm-user-permissions.html)
- [EC2 CloudFormation resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-resource-ec2-instance.html)
- [AWS EC2 pricing](https://aws.amazon.com/ec2/pricing/on-demand/)
- [AWS VPC pricing, including public IPv4](https://aws.amazon.com/vpc/pricing/)
