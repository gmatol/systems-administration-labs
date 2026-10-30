# Deployment evidence

**Status: deployment, in-place tag update and cleanup demonstrated on October 25, 2026 from supplied terminal output. Five resources were created, three updated and all five destroyed; state is empty and the final destroy plan has no remaining actions. Deliberate drift testing remains pending.**

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

## Completed controlled tag update

I changed only the local Environment input from learning to interview-practice and reviewed a saved plan proposing three in-place updates, with no creation or destruction. The VPC, subnet and security group retained their IDs.

```text
Apply complete! Resources: 0 added, 3 changed, 0 destroyed.
No changes. Your infrastructure matches the configuration.
```

## Completed cleanup

I stopped before the deliberate drift exercise, reviewed a destroy plan targeting only the five practice resources in the dedicated 10.88 network, and applied that saved plan. No CloudFormation lab resources appeared in the reviewed cleanup plan.

```text
Plan: 0 to add, 0 to change, 5 to destroy.
Apply complete! Resources: 0 added, 0 changed, 5 destroyed.
```

The subsequent terraform state list returned no resource addresses. A follow-up terraform plan -destroy returned:

```text
No changes. No objects need to be destroyed.
```

Terraform reported successful AWS deletion for all five tracked resources. No independent console inspection after deletion is recorded. Keep local state and configuration; a future normal apply would recreate the network.

## Evidence checklist

- [x] STS identity and region checked locally; credentials not published.
- [x] Initial plan reviewed: 5 adds, 0 changes, 0 destroys.
- [x] Apply completed: October 25, 2026; 5 added, 0 changed, 0 destroyed.
- [ ] Independently inspect AWS resource tags, dedicated CIDR, DNS settings and group ingress after deployment. The reviewed plan shows the intended settings; console or explicit describe results are not yet supplied.
- [x] terraform state list shows only the five resources in this directory.
- [x] Follow-up normal plan shows no changes.
- [x] Controlled Environment tag update reviewed and applied; three in-place updates followed by a no-change plan.
- [ ] Deliberate VPC tag drift detected and corrected through reviewed Terraform.
- [x] Destroy plan reviewed: only this lab's five resources.
- [x] Cleanup: AWS provider reported five successful deletions; state list is empty and the final destroy plan has no remaining actions.
- [ ] Independent post-cleanup AWS console or describe inspection; not supplied.

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

"I used Terraform to create an isolated AWS VPC, subnet and security-group rules. I reviewed and applied an in-place tag update, checked state and no-change plans, then reviewed and executed cleanup of all five resources."

Deliberate drift detection and remediation were deferred and are not completed. The resources were removed at the end of this session. This is a learning deployment, not production Terraform experience.
