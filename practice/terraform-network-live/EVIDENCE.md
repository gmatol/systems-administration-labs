# Deployment evidence

**Status: deployment not yet demonstrated.**

Replace each pending entry only after performing and verifying it. Mock tests and CI establish configuration checks, not a live AWS deployment.

## Evidence checklist

- [ ] STS identity and region checked locally; credentials not published.
- [ ] Initial plan reviewed: 5 adds, 0 changes, 0 destroys.
- [ ] Apply completed; date and actual result recorded.
- [ ] AWS resource tags, dedicated CIDR and no public ingress verified.
- [ ] terraform state list shows only the five resources in this directory.
- [ ] Follow-up plan shows no changes.
- [ ] Controlled Environment tag update reviewed and applied.
- [ ] Deliberate VPC tag drift detected and corrected through reviewed Terraform.
- [ ] Destroy plan reviewed: only this lab's five resources.
- [ ] Cleanup verified in state and AWS.

## Record each result

Date:
Step:
Prediction:
Command:
Sanitized actual output:
What I learned:
Unexpected behavior and correction:
Cleanup status:

Do not publish state, saved plans, credentials, full identity responses or unredacted screenshots. Replace account IDs and resource IDs consistently in excerpts. Do not edit the real state to sanitize it; create a separate text excerpt.

## Interview description after completion

Before deployment: "I prepared an isolated Terraform networking lab with mock tests and a deployment runbook."

After verified completion, adapt only to what you actually did: "I used Terraform to create an isolated VPC, subnet and security-group rules, verified state, reviewed a controlled tag change, investigated deliberate drift and removed the lab resources."

This is a learning deployment, not production Terraform experience.
