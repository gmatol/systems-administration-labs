# Module 01 — Tenant readiness and secure administration

**Initial state: PLANNED. No tenant access or security outcome is verified.**
Goal: decide whether live work is possible, establish recovery before security changes,
and produce honest evidence. Complete Part A now; tenant work is conditional.

## Part A — Free, local preparation (20–30 minutes)

| Step | Action | Purpose | Expected result and verification |
|---|---|---|---|
| 1 | Copy the readiness worksheet to `evidence/local/microsoft-365/` from the repository root | Keep operational details private | `git check-ignore evidence/local/microsoft-365/readiness.md` prints the ignored path |
| 2 | Record tenant availability as UNKNOWN unless you can confirm an authorized test tenant; record owner and account type privately | Distinguish a personal Microsoft account from a work/school directory identity | No tenant is assumed; a personal Microsoft 365 Family subscription is not proof of business tenant access |
| 3 | In the VS Code terminal, run `git --version`, `command -v pwsh`; if installed, run `pwsh -NoProfile -Command '$PSVersionTable.PSVersion'` | Inventory the Mac tools without cloud access | Record actual versions or MISSING; these checks create no tenant resources |
| 4 | Read the fictional CSV and run the local planner below if PowerShell 7 is available | Practice a provisioning review without making users | Two LOCAL SIMULATION rows; no sign-in or API request |
| 5 | Fill out the license matrix and mark unavailable modules BLOCKED | Avoid accidental costs and unsupported exercises | Every workload has an entitlement or remains unconfirmed |

From the repository root:

```bash
mkdir -p evidence/local/microsoft-365
cp practice/microsoft-365/templates/readiness.md evidence/local/microsoft-365/readiness.md
git check-ignore evidence/local/microsoft-365/readiness.md
pwsh -NoProfile -File practice/microsoft-365/scripts/Show-LocalUserPlan.ps1
```

If PowerShell is missing, inspect the CSV in VS Code and mark script execution NOT RUN.
Use Microsoft's macOS installation guide when ready to install locally; installation is
not a prerequisite to writing the readiness plan. Do not paste passwords into a CSV.

## Part B — Tenant decision (no signup or purchase yet)

1. If an authorized isolated tenant already exists, record its owner, administrative
   role and environment privately. Do not reuse the AWS AD domain. If none exists,
   mark TENANT BLOCKED and complete the local activities.
2. Review legitimate options: an authorized existing sandbox, a qualifying developer
   sandbox for eligible development/testing, or a business trial/subscription.
   Free Entra features do not mean anyone can create a new workforce tenant for free.
3. Prepare an approval request with the exact offer, service plans, seat count, price
   after trial, tax/currency, trial end, renewal setting, payment requirement and cleanup
   date. Leave unknown fields unknown. Do not enter payment details or accept terms yet.
4. After explicit approval for a tenant route, follow Microsoft's current signup steps.
   Verify the test directory name and initial domain. Record sign-in success privately.
   A provisioning failure is a documented blocker, not a reason to buy an Azure service.

Expected result: either an approved tenant route or a useful documented blocker.
Verification: completed worksheet; no claim that the tenant exists without sign-in evidence.

## Part C — Read-only baseline, only with authorized tenant access

1. Open [Microsoft 365 admin center](https://admin.microsoft.com) using a separate browser
   profile for lab administration. Verify the organization and signed-in identity.
   Purpose: avoid acting in the wrong directory. Expected: correct test tenant; stop if uncertain.
2. Inspect Billing > Your products and Licenses (labels may vary). Record service-plan
   names, available/assigned counts, expiry and renewal status privately. Do not change
   billing or assign licenses. Expected: verified entitlement matrix or permission-denied blocker.
3. Open [Entra admin center](https://entra.microsoft.com). Inspect tenant Overview,
   Users, Groups and Roles & admins. Record current administrative role and assigned
   privileged accounts privately. Expected: role inventory; no elevation or new accounts.
4. Inspect Entra ID > Overview > Properties > Manage security defaults, and Protection >
   Conditional Access if available. Record current settings without changing them.
   Inspect available sign-in/audit logs and note licensing/retention limitations.
   Expected: known baseline, not an assumption that MFA is configured correctly.
5. Draft a change plan using the next section. Expected: named changes, scope, test,
   recovery and approval. Verification: worksheet filled; no secrets in Git.

## Part D — Secure administration change plan (approval required before execution)

The following are proposed live actions, not permission to perform them yet.

| Proposed action | Purpose | Expected result / verification | Recovery |
|---|---|---|---|
| Separate ordinary user and named admin identities; assign only task-required roles | Limit privilege during daily use | Admin can perform approved task; ordinary user cannot open privileged function | Keep original verified admin session until replacement is tested; never remove last working admin |
| Establish two cloud-only emergency access administrators following Microsoft guidance; use independent phishing-resistant authentication, protected storage and monitoring | Recover from lockout | Test each sign-in independently before changing policies; record success privately | Stop policy rollout if either recovery path fails; never publish keys or recovery details |
| Register supported MFA for named admin and verify a fresh sign-in | Protect privileged access | New sign-in satisfies required authentication; record actual method/result, not merely registration | Use tested recovery account and approved reset procedure if needed |
| If appropriate for a new Free-tier lab, enable security defaults after reviewing current policies and account readiness | Establish baseline protections | Setting enabled; fresh admin sign-in works; check sign-in result and applicable protection behavior | Tested emergency path; approved rollback to recorded baseline only if needed, then restore protection |
| If P1 is confirmed, design a Conditional Access pilot in report-only mode for test accounts instead | Practice scoped access policy | Evaluate report-only sign-in outcomes before enforcement; exclude tested emergency accounts where guidance requires | Disable pilot through tested recovery path if unexpected impact occurs |

Security defaults and enabled Conditional Access policies are alternative approaches.
Do not disable security defaults just to make the exercise fit. Security defaults do not
provide per-user exclusions; do not claim emergency accounts are exempt from them.
Emergency accounts must still meet Microsoft's mandatory admin MFA requirements.
Do not use legacy authentication or weaken protection to make PowerShell connect.
For this first module, avoid Graph consent and tenant automation entirely; later modules
must review delegated scopes, admin consent and macOS module support before connecting.

## Exit criteria and portfolio evidence

- Tenant/access/license state is documented, including blockers and renewal deadline if any.
- Actual Mac inventory is recorded; local script execution status is explicit.
- Security baseline is observed only if access exists; otherwise marked NOT VERIFIED.
- Recovery plan and exact proposed changes are reviewed before requesting live approval.
- No security change is marked completed without a fresh sign-in and observed result.
- Use `templates/evidence.md` for a sanitized report. Next: Module 02 after tenant readiness.
