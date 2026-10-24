# Terraform and AWS infrastructure interview learning flow

Updated: October 24, 2026.

Purpose: prepare for a Cloud Operations Engineer technical interview emphasizing Terraform and AWS infrastructure operations, patching, monitoring, security remediation and troubleshooting. Technical interview dates are not confirmed in the evidence available for this log.

This is supplementary interview practice. Keep the established 12-week AI engineering program unchanged. Use the existing Windows administration lab as context without deploying, importing, modifying or taking Terraform ownership of its CloudFormation-managed resources.

## How each lesson works

1. Explain one concept in plain language using the existing lab.
2. Ask for a prediction or decision before showing the answer.
3. Make one small local edit or review one hypothetical operational scenario.
4. Run only the applicable formatting, validation and mocked plan checks.
5. Read the actual result together and correct mistakes.
6. Practice a short interview explanation.
7. Record verified progress, what was explained versus demonstrated, and the next checkpoint.

Proceed one checkpoint at a time. Revisit a misunderstood concept before increasing complexity. Do not treat an explanation supplied by the assistant as a demonstrated learner answer.

## Ordered lesson sequence

| Step | Topic and practical exercise | Interview connection | Current evidence |
| --- | --- | --- | --- |
| 1 | Install tools; inspect providers, variables, resources and outputs; run init/fmt/validate/mock tests | Explain the Terraform workflow | Completed local checks; individual file concepts remain reviewable |
| 2 | Explain VPC/subnet dependencies through a resource ID reference | Implicit versus explicit dependencies | Learner correctly explained that the subnet needs the VPC ID |
| 3 | Calculate /24 subnets inside the /16 VPC; change alternate test input from 20 to 30 | Review network changes and test expectations | Completed with guidance; final three tests passed |
| 4 | Introduce and correct an undeclared resource reference | Separate configuration errors from assertion failures | Completed; validation and three tests passed after correction |
| 5 | Review outbound versus inbound security-group rules | Evaluate public RDP exposure and SSM access | Explanation provided; independent learner reasoning not yet verified |
| 6 | Understand configuration, state and existing AWS resources | Explain why matching CIDRs/tags do not establish resource ownership | Current checkpoint; answer pending |
| 7 | Compare normal planning with refresh-only review in a drift scenario | Investigate changes made outside Terraform | Not started |
| 8 | Review hypothetical imports and CloudFormation ownership handoff | Avoid dual management and destructive reconciliation | Not started; discussion only, no imports |
| 9 | Read create/update/destroy/replace proposals and unknown values | Identify operational impact before approving changes | Initial mocked create plans reviewed; mixed-action review pending |
| 10 | Troubleshoot AWS networking, IAM and SSM access using hypothetical symptoms | Isolate routing, DNS, permissions and service issues | Not started in this interview sequence |
| 11 | Review a patching or standardized-image change | Explain maintenance windows, monitoring, rollback and instance replacement risk | Not started; no EC2 changes |
| 12 | Conduct a mock technical interview using completed exercises | Explain decisions and troubleshoot unfamiliar follow-ups | Not started |

## Verified practice record

Evidence: terminal output supplied by the learner in this conversation, including the uploaded terminal transcript and later correction results. These are learner-provided local results, not independently observed execution or GitHub CI results.

- Homebrew became available after adding its shell environment to PATH.
- Terraform reported version 1.17.0 on darwin_arm64; AWS provider 6.70.0.
- Initialization completed and configuration validation succeeded.
- Baseline, alternate-subnet and invalid-subnet mock tests passed: 3 passed, 0 failed.
- Learner changed alternate subnet input to 30. The assertion still expected 10.77.20.0/24, producing the expected failure against actual 10.77.30.0/24.
- After correcting the expected CIDR, validation and all three tests passed.
- A deliberate typo, aws_vpc.pratice.id, was introduced in the security-group block. Validation reported an undeclared resource.
- After correcting the reference, validation and all three tests passed again.
- The invalid input 256 is an expected rejection test; its diagnostic is compatible with that test passing.
- No apply, live drift check, resource import or production Terraform operation has been demonstrated. Do not describe this work as production Terraform deployment experience.

## Review notes from completed lessons

### Workflow

Local practice commands, from this directory:

```bash
terraform init -backend=false
terraform fmt -recursive
terraform validate
terraform test -verbose
```

Every test run must retain command = plan and mock_provider "aws" {}. A normal Terraform test can include apply runs; the safety of this exercise depends on its explicit mock and plan configuration. Do not run terraform apply, destroy, import, refresh or state-write operations. Retain the provider account guard.

### Dependencies

The reference vpc_id = aws_vpc.practice.id creates an implicit dependency. Terraform knows the subnet or security group needs the VPC ID. File order and the printed order of resource diffs do not determine deployment ordering.

Interview wording to practice: "The subnet references the VPC ID, which creates an implicit dependency. Terraform would create the VPC first and use its ID for the subnet."

### Subnet calculation

cidrsubnet("10.77.0.0/16", 8, 30) produces 10.77.30.0/24. The extra eight prefix bits change /16 to /24; subnet index 30 selects that subnet. A full CIDR includes the prefix.

The learner initially confused the result, then identified 10.77.40.0 as the network address for index 40; the complete CIDR was explained as 10.77.40.0/24.

### Two failure types

- An undeclared resource reference fails configuration validation.
- A valid configuration can fail a test assertion because actual behavior differs from the expected result.
- Change an assertion only after confirming that the changed behavior matches the intended requirement.

### Security rules

The outbound rule's 0.0.0.0/0 is a destination, and protocol -1 permits all outbound protocols. It does not permit unsolicited inbound RDP. Public RDP also needs inbound permission and network/host reachability. The original lab uses SSM port forwarding without public inbound RDP.

This concept was explained to the learner; ask for their reasoning again later.

## Resume here: Step 6 — state

Ask the learner before giving the answer:

"You write Terraform configuration with the same CIDR and Name tag as your existing CloudFormation VPC, but Terraform state is empty. Would Terraform automatically recognize and reuse that VPC, or propose creating a new one? Why?"

After reviewing their response, explain the distinction between:
- configuration: desired infrastructure;
- state: associations between resource addresses and remote object IDs;
- AWS: actual objects observed through the provider.

Use a hypothetical state association such as aws_vpc.practice -> vpc-EXAMPLE. Do not create that association with the deployed lab. Matching names and CIDRs do not automatically associate resources with state. Imports and migration stay discussion-only.

## Later scenario prompts

- Drift: someone changes a tracked security group or tag outside Terraform. What would a normal plan propose? What does a refresh-only plan review? How do you determine whether to revert or update configuration?
- Ownership: a CloudFormation-managed VPC is requested for Terraform import. What approvals, retention/handoff strategy, matching configuration and recovery preparation would be needed before any migration?
- Change impact: a plan proposes subnet replacement. What Windows hosts, interfaces, AD dependencies and maintenance concerns must be reviewed?
- Troubleshooting: SSM shell works but an RDP tunnel does not listen locally. What would you check first? Keep this distinct from the successfully repaired MGMT01 DNS incident.
- Patching: an updated image could replace a server. How would you assess backups, service health, monitoring, rollout and rollback before approving?
- Security remediation: a request proposes inbound TCP 3389 from all IPv4 addresses. Explain the exposure and safer access options before editing anything.

These are future exercises, not claims of completed work.
