# Microsoft 365 Group Administration Validation

Module: 02 — Identity and Access Management

Status: PERSONALLY VERIFIED LIVE

Operator and date/time/timezone:
Lab operator, November 23, 2026, Mountain Time.

Scope and fictional identities:
Authorized cloud-only Microsoft 365 lab.
Fictional standard user: Alex Morgan.

Prerequisites and license entitlement:
Microsoft Entra administrator access and Outlook
functionality were observed.
Full service-plan inventory remains unverified.

Approved change and scope:
Lab-only Microsoft 365 group creation and external
file-sharing configuration change.

## Objective

I practiced Microsoft Entra ID group administration,
membership validation, collaboration and security
configuration using fictional lab identities.

## Security group verification

Existing group: LAB-M365-Learners

- Group type: Security.
- Membership type: Assigned.
- Source: Cloud.
- Owner: Lab administrator (one).
- Direct member: Alex Morgan (one).
- Microsoft Entra role assignability: No.

I inspected the existing group without creating a
duplicate or changing its ownership or membership.

## Microsoft 365 collaboration group

New group: LAB-M365-Collaboration

I created and verified the group on November 23, 2026.

Observed configuration:

- Group type: Microsoft 365.
- Membership type: Assigned.
- Source: Cloud.
- Privacy: Private.
- Owner: Lab administrator (one).
- Direct member: Alex Morgan (one).
- Microsoft Entra role assignability: No.
- Group email address: Configured.

## External file-sharing hardening

Before:
New and existing guests.

After:
Only people in your organization.

I selected the internal-only setting, saved the
configuration and verified the displayed setting
after reopening the group settings.

This verifies the administrative configuration.
An external user's actual access denial was not tested.

## Outlook group communication test

Test user: Alex Morgan.
Date: November 23, 2026.

I authenticated as the standard user and accessed
the private collaboration group through Outlook.

I opened the group mailbox and read the group
welcome message.

I sent a fictional group communication test message.

I verified that the message appeared in the group
mailbox and inspected its sender, recipient, subject
and body.

Result: PASS — authorized group communication worked.

## Verification method

I personally observed the Microsoft Entra and
Microsoft 365 administrative interfaces and
the standard-user Outlook group mailbox.

The source screenshots remain private. They are
not included in the published repository evidence.

## Cleanup and remaining resources

The two lab groups remain available for future
authorized exercises.

No cleanup or deletion was performed.
Subscription renewal and expiry require review.

## Limitations and tasks NOT performed

- Second fictional-user verification.
- Group membership modification test.
- Unauthorized nonmember access-denial test.
- External guest access-denial test.
- SharePoint site and file permission testing.
- Microsoft Teams provisioning verification.
- Intune device enrollment or policy assignment.
- Full service-plan and license assignment inventory.

## Conclusion

I verified an existing cloud security group,
created and validated a private Microsoft 365
collaboration group, restricted its external file
sharing configuration, and demonstrated successful
authorized group communication through Outlook.

These were live lab activities, not production
administration or simulated tenant operations.
