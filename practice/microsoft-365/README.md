# Microsoft 365 administration lab

I am building a separate cloud administration portfolio track using fictional users.
**Status: planned; tenant, administrator access, subscriptions and licenses are unconfirmed.**
Documentation and local simulations do not establish that I completed tenant exercises.

## Boundaries

This track does not modify DC01, MGMT01, AWS infrastructure, Terraform state or the AI project.
Start cloud-only: no Entra Connect, directory synchronization, federation, custom-domain
DNS changes or connection to the existing AD lab. Use a dedicated authorized test tenant
and its onmicrosoft.com domain when available. Never use an employer tenant without authorization.
My Mac, VS Code, Git and PowerShell provide the local environment; a Windows endpoint
is a separate prerequisite for Windows enrollment and Autopilot exercises.

Use existing Tuesday/Thursday administration sessions, about 60–90 minutes each.
The sequence below estimates 12–16 sessions (6–8 weeks), depending on access and troubleshooting;
it is not a completion promise. AI engineering keeps its existing schedule.

## Sequence and acceptance checks

| Module | Practice | Acceptance evidence | Sessions |
|---|---|---|---|
| 01 | Tenant readiness, licensing, secure administration | Readiness decision, access inventory, approved MFA/recovery plan | 1–2 |
| 02 | Entra users, security groups, Microsoft 365 groups, assigned roles | Two fictional users, group membership, least-privilege task succeeds and unauthorized task is denied | 1 |
| 03 | Joiner/mover/leaver lifecycle | Approved create, update, block sign-in, revoke sessions, license reclamation and retention decision; verify each state | 1–2 |
| 04 | Authentication security | MFA registration and sign-in test; inspect security defaults; licensed Conditional Access pilot/report-only evaluation with recovery plan | 1–2 |
| 05 | Exchange Online | Licensed test mailbox, internal mail, delegate access, message trace, deliberate delivery fault and recovery | 1–2 |
| 06 | SharePoint Online and Teams | Test site/team, owners/members, restricted sharing, allowed/denied access tests, cleanup | 1–2 |
| 07 | Intune when licensed | Dedicated test device, enrollment, scoped configuration/compliance policy, sync and status verification; document platform limitations | 1–2 |
| 08 | Troubleshooting and portfolio | Sign-in/license/group/mail/access/device incidents; service-health check, before/after evidence and cleanup review | 2 |

For offboarding, distinguish blocking new sign-ins, revoking sessions, existing token lifetime,
and removing data access. Do not treat one action as instant removal everywhere. Do not delete
mailboxes/sites/users until retention and recovery requirements are documented.
Each later module must have its own detailed change plan before live execution.

Start [Module 01](modules/01-tenant-readiness.md). Use the
[evidence template](templates/evidence.md) and [readiness worksheet](templates/readiness.md).

## Free activities and license gates

| Activity | What can be done without a subscription purchase | Live prerequisite |
|---|---|---|
| Microsoft Learn, design, fictional CSV review, local planning script | Free local learning; no tenant required | None |
| Basic Entra users, assigned groups/roles, security defaults | Included in Entra Free if an authorized tenant is available | Tenant access and adequate role; free features do not guarantee free tenant creation |
| Conditional Access | Design and tabletop evaluation locally | Entra ID P1 for applicable users; risk-based policies need P2 |
| Privileged Identity Management | Role matrix locally | Eligible Entra ID P2 or ID Governance licensing; verify scenario |
| Exchange, SharePoint, Teams | Design permission/mail-flow tests locally | Relevant service plans enabled and assigned; verify Teams explicitly in the selected offer |
| Intune | Write enrollment/compliance plan locally | Intune entitlement for benefiting users/devices and a supported test device |
| Developer sandbox | Check eligibility only | Not universally free/available; development purpose and eligibility requirements apply |
| Business trial | Review offer and expiry locally | Approval before signup, billing details, subscription acceptance or renewal changes |

Do not buy a subscription just to finish a checklist. First map exact service plans to
modules and choose a budget and stop date. Business Premium may be a candidate, but verify
the exact offer, Teams inclusion, seats and local terms before approval. No price is assumed.
Trial access is temporary, not a permanently free lab. An eligible developer sandbox is
for development/testing, not a general entitlement to an administration training tenant.

## Evidence and publishing

Keep raw notes under ignored `evidence/local/microsoft-365/`. Commit only manually reviewed,
sanitized excerpts under `evidence/published/` using the template. Label every result
PLANNED, LOCAL SIMULATION, ASSISTANT VERIFIED LOCAL, or PERSONALLY VERIFIED LIVE.
Never publish credentials, tokens, QR codes, MFA recovery material, billing information,
real user lists, unredacted tenant identifiers or account screenshots. Do not claim
production experience or a live outcome from a simulated example.

## Sources

Licensing and portal labels can change. Reviewed November 3, 2026; recheck before signup.

- [Tenant creation prerequisites](https://learn.microsoft.com/en-us/entra/fundamentals/create-new-tenant)
- [Developer program eligibility](https://learn.microsoft.com/en-us/office/developer-program/microsoft-365-developer-program)
- [Sandbox setup and billing prerequisites](https://learn.microsoft.com/en-us/office/developer-program/microsoft-365-developer-program-get-started)
- [Business trial or purchase](https://learn.microsoft.com/en-us/microsoft-365/commerce/try-or-buy-microsoft-365)
- [Entra licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing)
- [Security defaults](https://learn.microsoft.com/en-us/entra/fundamentals/security-defaults)
- [Emergency access accounts](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access)
- [Intune licensing](https://learn.microsoft.com/en-us/intune/fundamentals/licensing)
- [PowerShell on macOS](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-macos)
- [Exchange Online module platform support](https://learn.microsoft.com/en-us/powershell/exchange/exchange-online-powershell-v2)
