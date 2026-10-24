# Terraform network practice — Guot's Windows lab concepts

This is a separate, **plan-only** interview exercise. It supplements the existing lab and does not change the 12-week AI engineering program. No deployment, import, state mutation, or CloudFormation migration is authorized here.

## What was reviewed

Source: [admin-lab.yaml](../../infrastructure/aws/admin-lab.yaml), repository commit `3755aa6ae781d7f85ec10f9b398239aed85aca08`.

| CloudFormation concept | Terraform address or expression | Practice behavior |
| --- | --- | --- |
| `LabVpc`, `10.77.0.0/16` | `aws_vpc.practice` | Same CIDR and DNS concepts; does not reference the deployed VPC |
| `LabSubnet`, `10.77.10.0/24` | `aws_subnet.practice` | CIDR calculated with `cidrsubnet`; automatic public IPs deliberately disabled |
| `LabSecurityGroup` | `aws_security_group.practice` | Separate practice group |
| `LabInternalIngress` | `aws_vpc_security_group_ingress_rule.internal` | All protocols only from members of the same security group |
| Outbound all-protocol rule | `aws_vpc_security_group_egress_rule.outbound` | Explicit outbound rule; no public inbound rule |
| `Ref` / resource dependency | `aws_vpc.practice.id` | References establish ordering automatically |
| Outputs | `outputs.tf` | Computed IDs plus a known subnet CIDR |

Internet gateway, routes, EC2, disks, IAM and SSM are intentionally omitted. The original subnet auto-assigns public IPs and has internet routing; this subset has neither. It is **not** a working replacement for the AD lab or its SSM connectivity. Security group egress alone does not supply a network route. VPC DNS support does not configure Windows AD DNS.

## Files and concepts

- `versions.tf`: Terraform version range, AWS provider source/version, region and account guard.
- `variables.tf`: typed inputs and validation. A /16 VPC plus eight extra subnet bits gives /24 subnets.
- `main.tf`: desired resources, shared tags, implicit dependency references and separate group rules.
- `outputs.tf`: useful values without hardcoding AWS IDs.
- `tests/network.tftest.hcl`: mocked, explicitly plan-only runs. No AWS calls or persistent infrastructure state.
- `.gitignore`: excludes state, plans and variable files; commit the provider lock file.

`resource "aws_vpc" "practice"` has a provider resource type and a local label. Its Terraform address is `aws_vpc.practice`. Its AWS ID is a separate value. A matching CIDR or Name tag does not tell Terraform to adopt an existing resource.

## Mac setup and first session

Use Terminal on your Mac. These commands stay in this directory; do not run them in `infrastructure/aws` or an existing Terraform deployment. No AWS login is needed.

If Terraform is missing and Homebrew is installed:

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

Use Terraform 1.7 or newer, below 2.0. If `terraform version` reports an older installation, resolve the PATH/version before continuing. The provider download requires internet access and disk space.

After this practice branch is available locally, change into it:

```bash
cd ~/systems-administration-labs/practice/terraform-network
pwd
terraform version
terraform init -backend=false
terraform fmt -recursive
terraform fmt -check -recursive
terraform validate
terraform test -verbose
```

`init` installs the provider and writes `.terraform.lock.hcl`; it does not provision AWS resources. `-backend=false` skips backend initialization. `fmt` edits whitespace. `validate` checks configuration/schema consistency, not AWS permissions, live connectivity or the correctness of every operational decision.

`terraform test -verbose` prints the mock plans. Each test run uses `command = plan`; do not change that or remove `mock_provider "aws" {}`. The provider account allowlist is also a deliberate guard against accidentally targeting a real account; do not remove it. This folder does not use your `admin-lab` profile. Mocking still needs the provider installed by `init`.

Expected: three passing runs, including an expected input-validation failure. For the baseline, look for **5 to add, 0 to change, 0 to destroy**: VPC, subnet, security group, ingress rule and egress rule. Outputs are not extra AWS resources. IDs will be unknown or synthetic mock values, not your real lab IDs. Each mock plan starts without a deployed baseline; the second run does not represent a modification to an existing subnet.

Do not execute `apply`, `destroy`, `import`, `refresh`, state-write commands, or add an import block to these active `.tf` files. Do not connect a production backend. No EC2 hosts are defined here, but that is not permission to deploy this network.

## How to review a real plan — explanation only

In a separately authorized Terraform-managed environment, `terraform plan -out=review.tfplan` proposes changes and `terraform show -no-color review.tfplan` displays them. **Do not run these against the Windows lab.** Use the mock plans above for this exercise.

| Marker | Meaning | Review question |
| --- | --- | --- |
| `+` | Create | Is this genuinely new, or an existing resource missing from state? |
| `~` | Update in place | What service or security behavior changes? |
| `-` | Destroy | Who depends on this object? Is deletion authorized? |
| `-/+` or `+/-` | Replace | Which field forces replacement, in what order, and with what downtime? |
| `(known after apply)` | Not known at planning time | Is this a computed ID rather than a broken reference? |

Read every resource diff, replacement reason, rule direction and summary. Check account, region, workspace, backend, variable values and current state before trusting a production plan. A saved plan can contain sensitive values and becomes stale as infrastructure changes; do not commit it. Do not use `-target` as a routine fix or `-refresh=false` as evidence of no drift.

A normal plan refreshes tracked resources and proposes reconciliation with configuration; it does not apply the changes. `terraform plan -refresh-only` reviews differences between tracked objects and state without proposing configuration-driven infrastructure updates. Neither mode discovers every untracked object in the account. Planning may make read API calls and acquire a state lock. Do not use `terraform refresh`: it writes state without the same review checkpoint.

## Interactive checkpoints

Work one checkpoint at a time. Explain your prediction before editing; share sanitized terminal output and your reasoning afterward. Do not include credentials, state files or real account details. The reviewer should correct mistakes and ask one follow-up before advancing.

### 1. Understand the baseline

Run the Mac commands above. Identify the five planned resource addresses. Explain why Terraform creates the VPC before its subnet even though no `depends_on` exists. Explain why using the same CIDR as the CloudFormation lab does not reuse that VPC.

### 2. Change the subnet

In the `alternate_subnet` test run, change `subnet_number = 20` to `30`. Before running, predict the CIDR and which assertion will fail. Run `terraform fmt -recursive`, `terraform validate`, and `terraform test -verbose`. Correct that run's expected CIDR to your prediction and rerun. Leave the baseline defaults unchanged.

Discuss: in a real state-backed environment, changing a subnet's primary CIDR requires replacement. Existing ENIs and Windows hosts complicate deletion/migration; a seemingly small text edit can cause service interruption. The actual plan and provider replacement annotation determine the reviewed action.

### 3. Diagnose input and reference mistakes

Temporarily set the baseline `subnet_number` default to `256`. Which validation should fail? Restore `10` afterward. Next, temporarily change the subnet's reference to `aws_vpc.pratice.id`. Compare this validate error with the earlier test failure. Correct the reference, then rerun format, validation and tests.

Validation catches invalid references; assertions can catch valid configuration that does the wrong thing. A passing mock test does not prove that AWS will accept or route the network.

### 4. Review a security request

A teammate requests public RDP: inbound TCP 3389 from `0.0.0.0/0`. Do not implement it. Explain rule direction, exposure, and why existing authenticated SSM port forwarding is relevant. Propose a safer investigation of the SSM tunnel issue without assuming it is the resolved DNS incident. The self-referencing group rule allows broad traffic among attached members; it is not a least-privilege production rule.

### 5. State and drift tabletop

Hypothetical, Terraform-managed production VPC: configuration and state record `Environment = "production"`; an operator changes the AWS tag to `temporary` outside Terraform. Predict the difference between a normal plan and a refresh-only plan. Should you revert the external change or change configuration? Ask whether the change was intentional and approved before choosing.

State maps an address to a remote object ID and stores attributes/metadata. Configuration expresses intent; AWS is observed reality. With empty state, the practice configuration proposes new resources even if identical CIDRs already exist elsewhere. Changing a resource label without a state-aware `moved` block can produce destroy/create proposals. State can hold secrets and must not be committed. A production backend needs controlled access, encryption, locking and recovery appropriate to that backend. Workspaces alone are not an IAM/security boundary.

No cloud resources or live state are used in this tabletop. Mock tests cannot demonstrate genuine live drift detection.

### 6. Import and ownership tabletop

An interviewer asks you to import the existing CloudFormation VPC. Explain why you stop: two tools managing the same object can overwrite changes or delete it unexpectedly. Import is not a backup and does not automatically migrate CloudFormation ownership or produce fully matching configuration. It creates a state association; subsequent plans can still propose destructive reconciliation.

For a hypothetical resource already approved for Terraform ownership, the syntax would be `terraform import aws_vpc.practice vpc-EXAMPLE` or an import block targeting the address. These are examples only; do not execute them or copy an import block into this exercise. A real migration needs an approved ownership handoff, CloudFormation retention/removal strategy, correct matching configuration, state backup, reviewed plan and rollback procedure. Importing one VPC does not automatically import its subnet or rules.

### 7. Troubleshooting and production review

- Provider download failure: check internet/proxy and version constraints; do not delete a lock file merely to silence a version conflict.
- Missing credentials or disallowed-account error: you probably ran a real plan instead of the mock test. Stop and use the documented mock path; do not remove the account guard.
- State lock: find the active owner/run; never force-unlock a run still operating.
- Unexpected destroy: stop. Check directory, backend/workspace, variables, renamed addresses and state before proposing any fix.
- Subnet with no connectivity: inspect route table, gateway/endpoints, DNS, group rules and NACLs. An outbound SG rule alone is insufficient.
- Patching/image request: a future AMI change can replace instances depending on configuration. For a domain controller, review AD health, backup/recovery, maintenance window, dependency impact and rollback before approving a plan. This exercise includes no EC2 changes.

Finish with a 60-second explanation: "I translated the network concepts from my CloudFormation Windows lab into Terraform, validated the configuration and inspected mocked plans. I practiced CIDR changes, dependency errors and ownership decisions without deploying or importing the AD environment." Claim only checkpoints you actually completed; mock practice is not production Terraform experience.

## References

- [Terraform provider mocking](https://developer.hashicorp.com/terraform/language/tests/mocking)
- [Terraform plan modes and options](https://developer.hashicorp.com/terraform/cli/commands/plan)
- [Refresh-only review](https://developer.hashicorp.com/terraform/tutorials/state/refresh)
- [Import workflow](https://developer.hashicorp.com/terraform/language/import/single-resource)
- [AWS security group resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
