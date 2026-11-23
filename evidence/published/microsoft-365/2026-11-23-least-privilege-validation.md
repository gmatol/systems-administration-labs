# Microsoft 365 Least-Privilege Validation

Module: 02 — Identity and Access Management

Status: PERSONALLY VERIFIED LIVE

Operator and date/time/timezone:
Lab operator, November 23, 2026, Mountain Time.

Scope and fictional identities:
Authorized Microsoft 365 lab tenant.
Fictional standard user: Alex Morgan.

Prerequisites and license entitlement:
Working Microsoft 365 administrator and standard-user
access. Full service-plan inventory remains unverified.

Approved change and scope:
NO TENANT CHANGES during this validation.

## Before state

I previously verified that the standard user could
sign in to Outlook and exchange internal email.

## Steps actually performed

1. I accessed the Microsoft 365 Admin Center using
   the standard-user account.
2. I observed the administrative access denial.
3. I accessed the admin center using my administrator
   account.
4. I inspected Alex Morgan's administrative roles.

## Expected result

Standard-user productivity services remain accessible,
while unauthorized administrative access is denied.

## Observed result

PASS — the standard user was denied access to the
Microsoft 365 Admin Center.

The administrative role configuration displayed:

"User (no admin center access)"

## Verification method and sanitized excerpt

I inspected the live Microsoft 365 portal and captured
screenshots of both the access denial and role configuration.

Sanitized access-denial message:

"Switch to an account that has permission"

The account did not have permission to view or manage
the requested Microsoft 365 Admin Center page.

## Troubleshooting, cause and recovery

No fault was identified. The denial was expected
authorization behavior. No remediation was required.

## Cleanup / remaining resources / renewal deadline

No role changes were required.
The existing lab account remains available.
Subscription expiry and renewal details require review.

## Limitations and tasks NOT performed

- Full Entra role and permission audit.
- Security group validation.
- Microsoft 365 group validation.
- Intune enrollment or compliance testing.
- Production tenant validation.

This evidence establishes the tested Microsoft 365
Admin Center access boundary, not every possible
administrative permission.

Raw screenshots are not included in this published record.

## Conclusion

I demonstrated that Microsoft 365 enforced the expected
administrative access boundary while allowing previously
verified standard-user productivity services.
