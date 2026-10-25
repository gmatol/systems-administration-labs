# Deployment evidence

**Status: initial AWS deployment and state reconciliation demonstrated on October 25, 2026. Controlled update, drift exercise and cleanup remain pending.**

Evidence source: terminal output supplied by Guot during the guided exercise. These are local AWS CLI and Terraform results, not independent console inspection. Resource IDs and identity details are omitted from this public excerpt.

## Completed initial deployment

I authenticated the admin-lab profile and checked the caller identity in us-east-1. I reviewed a saved plan for a dedicated VPC at 10.88.0.0/16 and subnet at 10.88.10.0/24. It proposed five additions, zero changes and zero destructions, without EC2 or existing AD lab resources.

I applied the reviewed plan locally:

```text
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```

Terraform outputs included the newly assigned VPC, subnet and security-group IDs and subnet_cidr = "10.88.10.0/24".

The resource addresses returned by terraform state list were:

```text
aws_security_group.practice
aws_subnet.practice
aws_vpc.practice
aws_vpc_security_group_egress_rule.outbound
aws_vpc_security_group_ingress_rule.internal
```

A subsequent normal plan refreshed all five tracked resources and returned:

```text
No changes. Your infrastructure matches the configuration.
```

This demonstrates a successful initial deployment and configuration reconciliation. It does not establish application connectivity or production readiness. The network has no application hosts.

## Evidence checklist

- [x] STS identity and region checked locally; credentials not published.
- [x] Initial plan reviewed: 5 adds, 0 changes, 0 destroys.
- [x] Apply completed: October 25, 2026; 5 added, 0 changed, 0 destroyed.
- [ ] Independently inspect AWS resource tags, dedicated CIDR, DNS settings and group ingress after deployment. The reviewed plan shows the intended settings; console or explicit describe results are not yet supplied.
- [x] terraform state list shows only the five resources in this directory.
- [x] Follow-up normal plan shows no changes.
- [ ] Controlled Environment tag update reviewed and applied.
- [ ] Deliberate VPC tag drift detected and corrected through reviewed Terraform.
- [ ] Destroy plan reviewed: only this lab's five resources.
- [ ] Cleanup verified in state and AWS.

## What I learned

- Resource references ordered VPC creation before its subnet and security group, and group creation before its rules.
- AWS assigned real resource IDs during apply; configuration addresses stayed the same.
- Terraform state tracks the five managed resources.
- A no-change plan after refresh provides evidence that the tracked infrastructure matches the configuration at that point.

## Record subsequent results

Date:
Step:
Prediction:
Command:
Sanitized actual output:
What I learned:
Unexpected behavior and correction:
Cleanup status:

Keep state, saved plans, local variable files, credentials and full identity responses out of Git. Create sanitized text excerpts instead of altering actual state.

## Current interview description

"I used Terraform to deploy an isolated AWS VPC, subnet and security-group rules. I reviewed the creation plan, applied it, inspected the five resource addresses in state and verified a no-change follow-up plan."

Tag updates, deliberate drift remediation and cleanup are not yet completed in the supplied evidence. This is a learning deployment, not production Terraform experience.
