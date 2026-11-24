# Module 02 — Identity and Access Management

## Objective

I am practicing cloud-only identity administration using
fictional users in an authorized Microsoft 365 lab tenant.

## Status

IN PROGRESS — least-privilege, group configuration
and authorized Outlook communication checkpoints
verified live on November 23, 2026.

## Learning objectives

- Manage Microsoft Entra ID users.
- Understand security groups and Microsoft 365 groups.
- Inspect administrative role assignments.
- Validate role-based access control (RBAC).
- Apply the principle of least privilege.
- Distinguish authentication from authorization.

## Verified live activities

- [x] Standard-user authentication.
- [x] Outlook access.
- [x] Internal email communication.
- [x] Standard-user Microsoft 365 Admin Center access denied.
- [x] Administrative role configuration inspected.

## Additional verified live activities

- Inspected LAB-M365-Learners security group.
- Confirmed group owner, member and role assignability.
- Created LAB-M365-Collaboration as a private Microsoft 365 group.
- Verified collaboration group ownership and membership.
- Restricted external file sharing to organizational users.
- Verified authorized Outlook group mailbox access.
- Sent and inspected a successfully delivered group message.

## Activity checklist
- [x] Inspect and verify the existing security group.
- [x] Create and verify a Microsoft 365 group.
- [x] Verify ownership and direct membership of both groups.
- [x] Verify authorized Outlook group access and email delivery.
- [x] Configure and verify internal-only file sharing.
- [ ] Verify a second fictional user.
- [ ] Test unauthorized nonmember resource access.
- [ ] Test SharePoint file-sharing enforcement.
- [ ] Complete remaining evidence and cleanup review.

## Security boundaries

- Use only the authorized lab tenant.
- Do not assign unnecessary administrative privileges.
- Do not modify production accounts.
- Do not publish sensitive tenant information.

## Acceptance criteria

The least-privilege checkpoint passes when authorized
standard-user functionality succeeds and unauthorized
administrative access is denied.

The complete module remains in progress until all
remaining acceptance criteria are verified.

## Evidence

See the [least-privilege validation record](../../../evidence/published/microsoft-365/2026-11-23-least-privilege-validation.md).

See the [group administration validation record](../../../evidence/published/microsoft-365/2026-11-23-group-administration-validation.md).
