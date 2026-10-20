# Validation and limitations

Prepared October 18, 2026 (America/Denver).

Checked locally:
- CloudFormation YAML loads and references resolve to declared resources/parameters.
- Exactly two Windows EC2 hosts; fixed distinct private IPs; encrypted disks; IMDSv2.
- No public inbound security-group rule; internal ingress is restricted by lab SG.
- CSV has 150 unique synthetic account names, five departments and 30 users each.
- Shell script passes `bash -n` and rejects non-macOS environments.
- Relative Markdown links point to files in the package.
- ZIP integrity checked before delivery.

Not checked in a running environment:
- CloudFormation service-side validation, regional AMI availability and EC2 deployment.
- AWS IAM/organization policy compatibility and SSM/RDP connectivity.
- Windows PowerShell parsing/execution (PowerShell runtime unavailable here).
- Domain promotion, DNS, account creation, domain join and GPO results.

These materials are a prepared lab starter, not proof that any exercise was completed.
Run CloudFormation validate-template, inspect the created resources and record actual
Windows validation output before describing a lab as complete.
