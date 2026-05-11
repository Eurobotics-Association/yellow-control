# Policy gates

Public-safe extraction of enforceable gates.

## Authority gate

# Agent PAM/IAM Governance Policy — ADAL/CDEL/ESAL/PCL


Status: Phase 0 approved for control-plane documentation
Scope: governed agent / Hermes-compatible runtime agent access governance, privileged access, server access, container access, and secret-handling boundaries
Repository: private runtime governance repository
Applies to: governed agent / Hermes-compatible runtime, Codex, human administrators, AI-assisted administrators, and control-plane maintainers

---

## 1. Purpose

This document defines the PAM/IAM governance model for governed agent / Hermes-compatible runtime.

For canonical definitions and level tables, see `docs/security/governance-levels-reference.md`.

Core doctrine:

> Oscar may operate systems. 
> Oscar may not capture systems. 
> Oscar may propose new privileges. 
> Oscar may not self-grant new privileges. 
> Oscar may reference secrets. 
> Oscar may not become the uncontrolled vault of secrets.

---

## 1.1 Acronym normalization

- **ADAL** = Agent Delegated Administration Level
- **CDEL** = Container Delegated Execution Level
- **ESAL** = External Service Access Level
- **PCL** = Project Confidentiality Level
- **PAM/IAM** = privileged access and identity/access management governance
- Do not use incorrect or legacy acronym variants in governance documentation.

## 1.2 Profile/Project governance note

- Profile/project governance supports PCL and ESAL boundaries.
- `agent-dev` is currently the active full-stack/cyber-engineering profile.
- Engineering/Pegasus-M context is deferred.
- Persistent automation must be governed before activation.

## 1.3 Register-first authority rule (Phase 2)

- External services/hosts/SSH/sudo/container/dashboard/API targets are governed through `docs/security/external-access-register.md`.
- Project/workstream identity is governed through `config/project-register.yaml`.
- Profile/work-context mapping is governed through `config/profile-register.yaml`.
- Skill inventory/lifecycle is governed through `config/skill-register.yaml` (informational/dashboard only in Phase 2).
- If authority or required metadata is unknown, default to no operational authority.
- Proposal does not equal permission; Oscar may propose updates but must not self-grant privilege.

## 1.4 Desired/deployed/evidence model

- Git repo = desired governance state.
- Oscar runtime = deployed governance state and local evidence.
- External hosts/services = host-local controls and logs.
- Raw audit artifacts remain runtime state and must not be committed unless sanitized and explicitly approved.

## 1.5 External Packages Management architecture boundary

- Runtime operational state is authoritative for runtime-agent governance execution.
- `<runtime-register-root>` is the active runtime register root.
- `<runtime-register-root>` is legacy/historical only.
- `<private-workspace-path>` is a temporary staging/drafting repo.
- External Packages Management is the target-specific implementation layer (manifests, wrappers, sudoers templates, install/rollback scripts, operational constraints).
- External Access Register remains the live governance map of access targets and may reference External Packages where available.
- External Package reference does not grant permission by itself. Wrapper existence does not equal permission. Capability does not equal authority.
- For canonical level definitions and ADAL-3T temporary elevation semantics, use `docs/security/governance-levels-reference.md`.

## 1.6 ADAL contextual target-role rule (resident runtime vs external target)

- ADAL level interpretation is contextual by target role.
- On the resident Hermes runtime host, ADAL-2.5 may include controlled resident-runtime maintenance when documented and approved:
 - Hermes update preflight only,
 - runtime version/status/log inspection,
 - backup creation,
 - applying reviewed repo-managed Yellow `SKILL.md` proposals with backup/hash verification,
 - user-service status checks,
 - preparing an approved Hermes update plan.
- `hermes update` itself is runtime-changing and requires explicit approval after preflight.
- If update execution requires maintenance beyond approved resident ADAL-2.5 envelope (for example system-level package remediation, sudoers changes, or service-impacting recovery outside approved user-space operations), ADAL-3T temporary elevation is required.
- For external targets, ADAL-2.5 remains narrower: read-only diagnostics and wrapper-mediated baseline audit; no arbitrary install/update/restart, no broad sudo, and no service/container state changes unless explicitly approved/elevated.

## 2. Runtime Adoption Scope and Safety Boundary

Current deployment supports both clean/newborn runtimes and mature existing runtimes using staged governance deployment.

Mature runtime support is constrained by safety rules:

- Use `--prepare-merge` as normal mode.
- Copy only missing governance files during prepare mode.
- Stage sensitive differing files for semantic review.
- Do not blindly overwrite sensitive runtime governance files.
- Use `--apply-staged` only as an exceptional, explicitly approved operation.

This preserves runtime-evolved identity/governance content while allowing controlled baseline alignment.
---

## 3. SOUL.md Safety Rule

`SOUL.md` is an agent identity/personality/governance file and may be complex.

Rules:

- Do not overwrite `SOUL.md`.
- Do not reorganize `SOUL.md`.
- For runtime-agent, patch only a small principle-level section when needed.
- For mature runtimes, use staged merge review and targeted manual apply for reviewed content.
- Mature existing agents must not be modified by blind bulk overwrite.
- Future enhancements may use explicit managed blocks with human-approved diffs.

Future Mode 2 design note example (not Phase 0 implementation):

```html
<!-- private runtime governance repository:BEGIN external-access-pam-iam -->
...
<!-- private runtime governance repository:END external-access-pam-iam -->
```

---

## 4. Core Security Principles

- Least privilege.
- Progressive delegation.
- No owner lockout/capture.
- No human personal passwords in Hermes.
- No plaintext secrets in documentation/Git/chat/logs.
- Patch, do not reinvent.
- Control plane before runtime.

---

## 5. ADAL — Agent Delegated Administration Level

ADAL classifies delegated administrative authority for host/service operations.

### 5.1 ADAL Summary Table

| Level | Name | Meaning | Suitable For | Default Policy | Notes |
|---|---|---|---|---|---|
| ADAL-0 | No Access | No account/key/token/approved access | Out-of-scope systems | Allowed | No runtime operations |
| ADAL-1 | User Access Only | Dedicated user, no sudo/elevation | Remote diagnostics, repo/user-space work | Preferred default for remote hosts | Lowest operational risk |
| ADAL-2 | Constrained Delegated Administration | Limited NOPASSWD sudo/wrappers, lockout-protected | Managed hosts with narrow privileged tasks | Preferred maximum for many important hosts | May allow `apt update`; generic `apt install` should not be default |
| **ADAL-2.5 / ADAL-2+** | **Extended Delegated Operations / Extended Non-Lockout Administration** | Approved package installation, user-service management, diagnostics, runtime recovery, and controlled Docker/container operations **without owner lockout/capture capability** | Resident agent host or explicitly approved managed host | **maintainer-preferred resident-host level for runtime-agent for now** | Stronger than ADAL-2; weaker than ADAL-3 |
| ADAL-3 | Full Sudo With Approval | Broad/full sudo, risky actions require explicit approval | Exceptional staging/non-critical operations | Exceptional | Higher risk; can approach host-capture capability |
| ADAL-R3 (if used) | Resident Broad Sudo Reality Class | Runtime may have broad sudo (including possible `NOPASSWD:ALL`) on resident host | Temporary operational reality | High-risk exception only | Stronger than ADAL-2.5; requires explicit the owner approval and later review |
| ADAL-4 | Full Sudo Autonomous | Full sudo without per-action approval | Disposable labs only | Avoid for production | Not for important hosts |
| ADAL-5 | Agent-Owned OS | Agent is sole OS admin; human still controls infrastructure recovery | Special-purpose lab contexts | Special-purpose only | Never for systems requiring owner-admin continuity |
| ADAL-6 | Unbounded Agent Control | Agent controls OS + infrastructure recovery path with no human break-glass | None | Forbidden | Explicitly forbidden |

### 5.2 ADAL-2.5 / ADAL-2+ Definition

**ADAL-2.5 — Extended Delegated Operations** (alias: **ADAL-2+ — Extended Non-Lockout Administration**) grants broader operational authority than ADAL-2, including approved package installation, controlled Docker/container operations, user service management, diagnostics, and resident-agent runtime recovery, while preserving the ADAL-2 lockout-protection boundary.

The agent may materially affect host operation, but must not be able to:

- capture the host,
- remove owner access,
- modify break-glass paths,
- or control infrastructure recovery.

Positioning:

- Stronger than ADAL-2 (more host-impact capability).
- Weaker than ADAL-3 (no unrestricted lockout/capture capability).
- Suitable for resident agent hosts where the agent must maintain runtime/container stack.
- Suitable for selected managed hosts only after explicit approval.
- Not default for remote production hosts.

### 5.3 ADAL-R3 Clarification

If ADAL-R3 appears in this repository, treat it as:

- Stronger than ADAL-2.5.
- Potentially including `NOPASSWD:ALL` on resident host.
- High risk; use only with explicit the owner approval.

For runtime-agent now:

- Preferred policy target: ADAL-2.5 / ADAL-2+.
- If runtime is broader (for example `NOPASSWD:ALL`), document reality honestly and mark for later review against ADAL-2.5 target.

---

## 6. Lockout/Capture Risk vs Host-Impact Risk

### 6.1 Lockout/Capture Risk

Lockout/capture risk means the agent can remove or block the owner/admin access or control recovery paths.

Examples:

- changing/deleting the owner/rfv/admin accounts
- changing admin passwords
- editing `/root/.ssh/authorized_keys`
- editing `<private-workspace-path>`
- modifying `sshd_config`
- changing firewall rules that can block admin access
- editing sudoers
- disabling SSH
- deleting backups/snapshots
- controlling Hetzner/cloud dashboard or password-manager recovery

### 6.2 Host-Impact Risk

Host-impact risk means the agent can change or break host/application state without necessarily locking out admin access.

Examples:

- installing packages
- running Docker containers
- changing non-access services
- consuming disk/CPU/RAM
- exposing application ports
- changing application runtime state
- restarting user services
- bootstrapping local application databases
- repairing env files

### 6.3 Policy Boundary

**ADAL-2.5 accepts some host-impact risk for operational usefulness, but continues to reject lockout/capture risk.**

---

## 7. Resident Host Installation Reliability Contract (ADAL-2.5)

ADAL-2.5 is not only a rights model; it is also an installation reliability contract for resident-agent hosts.

Before changes, installers must preflight:

- Effective Unix user
 - `whoami`
 - `id`
- Non-interactive sudo
 - `sudo -n true`
 - `sudo -n -l`
- Package capability (if packages may be installed)
 - `apt-get` availability
 - non-interactive install capability where required
- Docker/container capability (if Docker is required)
 - `command -v docker`
 - `docker ps`
 - `docker compose version`
 - docker group membership for `agent` if non-sudo Docker is expected
- User systemd bus
 - `/run/user/<uid>` exists
 - `XDG_RUNTIME_DIR=/run/user/<uid> systemctl --user status` works
- Service management
 - ability to `start/restart/status` required user services
- Network/listening checks
 - `ss -ltnp` for expected ports
 - `curl` local health/version endpoints where available
- Env-file syntax validation before restart
 - source env file under bash
 - values with spaces must be quoted
 - never print secrets
- DB/bootstrap state where applicable
 - detect whether admin user exists
 - backup DB before modifying
 - do not print password hashes unless necessary
- Duplicate process detection
 - avoid manual `nohup` starts when a systemd unit exists
 - manage Open WebUI via user systemd service when installed that way
 - verify exactly one expected process/listener after restart

If checks fail, installer must stop before partial runtime changes.

The installer must never ask the owner for an interactive sudo password inside Hermes/Open WebUI. It must use `sudo -n` and report precise remediation commands for `rfv/admin`.

### 7.1 Mandatory pre-apply backup/checkpoint gate

Before any runtime deploy/re-apply modifies files, control-plane deployment must create a timestamped pre-apply backup under:

- `<private-workspace-path>`

Required controls:

- directory owner `agent:agent`
- directory mode `700`
- artifact mode `600` where practical
- no commit/push/email/Telegram transmission of backup artifacts by default
- no secret values printed in logs

Minimum backup scope (when present):

- private runtime governance repository git metadata (`branch`, `HEAD`, `status`, recent log) and `git bundle --all`
- private runtime governance repository working tree tarball excluding `.git`, `.env`, caches, `node_modules`, `__pycache__`, `*.pyc`
- Hermes critical runtime files (`SOUL.md`, `config.yaml`, `.env`, `auth.json`)
- Open WebUI critical runtime files (`open-webui.env`, `open-webui.service`, `webui.db`, `.webui_secret_key`)
- privileged policy snapshots (`/etc/sudoers.d/agent-runtime`, `/etc/sudoers.d/private runtime governance repository`) using `sudo -n`
- runtime state report and `SHA256SUMS`

If pre-apply backup fails, deployment/apply must stop.

---

## 8. Resident Host Operational Allowances under ADAL-2.5

### 8.1 Read-only diagnostics allowed

- `ps`, `id`, `whoami`
- env inspection with secret redaction
- `ss`, `lsof`
- `journalctl` read-only inspection
- `systemctl status`
- `systemctl --user status/cat`
- `docker ps/logs/inspect` for resident runtime
- read-only firewall/security posture checks (for example `ufw status verbose`)

### 8.2 Controlled operations allowed

- `apt update`
- package installation required for agent/runtime/container stack
- Docker/container operations required for Hermes/Open WebUI/runtime/sandbox management
- systemd user service start/stop/restart/status for Hermes/Open WebUI and related user services
- env-file backup and syntax repair
- Open WebUI DB backup and bootstrap repair when needed
- port/listener health checks
- duplicate-process cleanup for agent stack
- controlled restart of agent frontend/backend services

### 8.3 Firewall boundary

Allowed under ADAL-2.5:

- read-only firewall status (for example `ufw status verbose`)

Restricted unless explicitly approved:

- `ufw allow/deny/delete/reset/disable/enable`
- equivalent firewall rule changes

---

## 9. Package Installation Policy (ADAL-2 vs ADAL-2.5)

### ADAL-2

- May allow `apt update`.
- Should not allow generic `apt install` by default.

### ADAL-2.5

- May allow package installation required for agent/runtime/container operations.
- Should prefer allowlisted packages, wrapper scripts, or documented command classes where practical.
- May allow Docker-related packages on resident host if documented.
- Must not use package installation as a route to owner lockout or uncontrolled capture.

Generic package installation is stronger than diagnostics and must be explicitly documented in the external access register.

---

## 10. Docker/CDEL Policy Clarification

- Docker access is host-impacting and can be host-admin-equivalent if unrestricted.
- ADAL-2.5 may allow controlled Docker/container operations for resident-agent runtime management.
- ADAL-2.5 Docker use should avoid uncontrolled host-capture patterns unless explicitly approved.

High-risk patterns (ADAL-3/R3 or explicit approval):

- `docker run --privileged`
- mounting `/`, `/etc`, `/root`, `/home`, or other sensitive host paths
- mounting `/var/run/docker.sock` into another container
- host PID namespace
- host network for sensitive/public services
- Docker daemon configuration changes
- exposing new public ports without approval

Defaults:

- Remote production hosts: unrestricted Docker forbidden by default.
- Resident Oscar host: controlled Docker for Hermes/runtime/sandbox operations allowed under ADAL-2.5 when documented.

### CDEL Summary Table

| Level | Name | Meaning | Suitable For | Default Policy |
|---|---|---|---|---|
| CDEL-0 | No Container Access | No container backend | Systems without approved container use | Allowed |
| CDEL-1 | Ephemeral Isolated Container | No mounts, no secrets, non-persistent | Safe tests | Preferred safe default |
| CDEL-2 | Persistent Workspace Container | Persistent sandbox workspace | Longer builds/tests | Acceptable with inspection |
| CDEL-3 | Project-Mounted Container | Host project directory mounted | Repo builds/tests | Requires Git discipline |
| CDEL-4 | Secret-Forwarded Container | Scoped secrets forwarded | Token-based tests | Requires explicit register entry |
| CDEL-5 | Host-Privileged Container | Docker socket/privileged/host mounts | Host-admin-equivalent patterns | Forbidden by default |

---

## 11. ESAL — External Service Access Level

ESAL classifies governed agent / Hermes-compatible runtime access to external services such as GitHub, Gmail, Telegram, cloud dashboards, APIs, SaaS platforms, password managers, and web administration portals.

Clarification:

- ADAL is for host/server/OS administration.
- CDEL is for container/sandbox execution.
- ESAL is for external service authority and communication power.

### 11.1 ESAL Levels

| Level | Name | Meaning |
|---|---|---|
| ESAL-0 | No External Service Access | No token, login, API access, OAuth grant, bot access, or service account. |
| ESAL-1 | Read-Only External Access | Oscar may read approved service data; no writing, sending, posting, commenting, editing, or publishing. |
| ESAL-2 | Draft / Proposed Action Access | Oscar may prepare drafts, PR text, issue comments, email drafts, or proposed changes; human approval required before sending/publishing. |
| ESAL-3 | Scoped Write Access | Oscar may write within a narrow approved scope (for example fork/PR-only workflow or approved home/admin channel reporting). |
| ESAL-4 | Broad Operational Service Access | Oscar may perform multiple write actions in an approved external service (for example branches/commits/PRs/comments/selected repo settings/routine operational reporting); requires register entry and monthly reporting. |
| ESAL-5 | High-Impact Identity / External Communication Authority | Oscar may send as an identity, interact with third parties, or materially affect public/private repositories and external relationships; requires explicit register entry, PCL controls, and monthly reporting. |

Positioning examples:

- Gmail send authority should normally be ESAL-5.
- GitHub write authority over private repositories is normally ESAL-4 or ESAL-5 depending on repo/org permissions.
- GitHub read-only access may be ESAL-1.
- GitHub fork/PR-only workflow may be ESAL-3.
- Telegram home-channel reporting may be ESAL-3; broader messaging may be ESAL-4 or ESAL-5 depending on scope.

### 11.2 External Confidentiality Rule

ESAL authority must not be used to disclose private/confidential project information without approval.

### 11.3 ESAL-4/5 Owner Recovery Custody Requirement

- ESAL-4 and ESAL-5 accounts must not be agent-only recoverable.
- the owner/owner must retain break-glass recovery custody.
- For Gmail/Google accounts, owner custody should include a recovery email/path and backup codes where available.
- For GitHub accounts, owner custody should include recovery codes and at least one documented recovery method where available.
- Recovery codes must be stored in an owner-controlled vault/password manager, not in this control plane repository.
- The external-access register may reference the vault item/location but must not contain recovery codes.
- Oscar must not rotate, delete, consume, regenerate, or invalidate recovery codes without explicit the owner approval.
- Oscar must not change recovery email, 2FA methods, passkeys, security keys, or account ownership without explicit the owner approval.
- If recovery custody is missing or unknown, ESAL-4/5 access is incomplete and must not be expanded.

---

## 12. Monthly External Interaction Reports

Oscar must produce monthly reports for high-impact external services.

Separate reports are required where applicable:

- Monthly GitHub Report
- Monthly Gmail Report
- Monthly Telegram / External Messaging Report

Preferred delivery order:

1. Email to the owner/admin address if Gmail/email is available.
2. Telegram home/admin channel if email is unavailable.
3. Local Markdown report in control-plane/runtime report directory if neither external channel is available.

Reports must summarize:

- repositories accessed;
- branches created;
- commits made;
- PRs opened, updated, commented, or closed;
- issues opened/commented;
- emails sent, drafted, or forwarded;
- Telegram/external messages sent;
- external contacts interacted with;
- files/attachments transmitted;
- access or permission changes requested;
- failed or blocked external actions;
- confidentiality-relevant events.

Reports must not include:

- passwords;
- API keys;
- tokens;
- private keys;
- OAuth secrets;
- session cookies;
- recovery codes;
- sensitive personal data beyond what is necessary for audit.

---

## 13. PCL — Project Confidentiality Level

| Level | Name | Meaning |
|---|---|---|
| PCL-0 | Public | Public project/repository. Oscar may discuss public facts/material, but must not disclose secrets or private operational details. |
| PCL-1 | Internal | Internal operational material; discussion allowed only in approved internal/admin channels. |
| PCL-2 | Private | Private repositories, private infrastructure, non-public implementation details; no external disclosure without explicit approval. Default when unknown. |
| PCL-3 | Confidential | Sensitive business/security/credential/infrastructure/client/legal/governance material; no external disclosure without explicit written approval; minimize summaries and recipients. |
| PCL-4 | Restricted / Secret | Highly sensitive credentials, recovery material, identity/security control plane, private keys, vault data, or sensitive client data; no external transmission except explicitly approved secure process. |

Default rules:

- If project confidentiality is unknown, treat it as PCL-2 Private.
- Any private GitHub repository is at least PCL-2 Private by default.
- Any credential/sudoers/SSH/password-manager/recovery/firewall/external-access-register/identity-governance material is at least PCL-3 unless explicitly marked otherwise.
- A public repository may be PCL-0, but secrets, private infrastructure details, private hostnames, credentials, and owner-private operational details remain PCL-3/PCL-4.

---

## 14. Open WebUI Incident Rationale

Open WebUI installation/recovery friction showed resident Hermes operation needs reliable:

- non-interactive sudo,
- env validation,
- service management,
- DB/bootstrap awareness,
- duplicate-process prevention.

The issue was not only sudo scope; it was missing end-to-end resident-host installation reliability checks.

ADAL-2.5 exists to prevent partial-install/manual-recovery spirals while preserving no-lockout/no-capture boundaries.

Future installers must preflight privileges and runtime dependencies before modifying services, env files, or databases.

---

## 15. Registers and Delegation Requirements

All privileged or external access must be recorded in `docs/security/external-access-register.md` before use.

Required sections include:

- ADAL summary
- CDEL summary
- managed systems register
- external services register (ESAL)
- monthly external interaction reports policy
- project confidentiality register (PCL)
- container access register
- sudo delegations register
- proposed access changes
- change log

No plaintext secrets in register entries; only location references.

---

## 16. Sudo and Wrapper Principles

- Prefer narrow root-owned wrappers where practical.
- Wrapper scripts must be root-owned and not writable by `agent`.
- Validate arguments and avoid arbitrary shell expansion.
- Do not permit wrappers that alter owner access, sudoers, SSH admin paths, break-glass accounts, or recovery control unless explicitly approved.

---

## 17. Remote Production Defaults

For remote production hosts (default):

- ADAL-1 initially.
- ADAL-2 only after explicit register entry + approval.
- ADAL-2.5 is not default for remote production.
- Unrestricted Docker and lockout-capable operations remain forbidden by default.

---

## 18. Phase 0 Document Split Clarification

In Phase 0, secrets-management and privileged-delegation guidance remain in this main policy document.

Planned Phase 1 split-outs (unless the owner asks to create now):

- `docs/security/secrets-management-policy.md`
- `docs/security/privileged-delegation-procedure.md`

---

## 19. Out of Scope (Phase 0)

Do not implement in this phase:

- Mode 2 existing-agent adoption
- automatic SOUL.md migration
- `.env` migration
- `config.yaml` migration
- runtime auto-patching of mature Hermes installations

Mode 2 is future design territory only.



# GitHub safety

## Branch protection assumptions

Protected mainline branches require pull requests, reviews, and status checks before merge.

## Execution model

Oscar works in its own fork or non-protected branch, never by direct mainline modification.

## Submission behavior

When work appears ready, Oscar requests submission/review rather than self-merging protected targets.

## Runtime guard dependency model

- Runtime guards must use configured git remotes and authenticated transport where required.
- Do not hardcode unauthenticated private HTTPS reachability checks for private GitHub repositories.
- Hermes core maintenance dependency is Hermes upstream/origin reachability only.
- private runtime governance repository fork/upstream reachability is maintenance-context dependent and non-blocking for Hermes core auto-update.

## Autonomous maintenance guardrails

- GitHub operational use for Oscar runtime workflows is ADAL-4.
- Oscar may commit and push to branches in its own fork.
- Oscar may prepare/open/update PRs to Eurobotics upstream.
- Oscar must not merge into Eurobotics upstream/main without the owner approval.
- Oscar must not push directly to Eurobotics main.
- Oscar must not auto-merge PRs.
- Oscar must not force-push shared/protected branches.
- Oscar must not rewrite upstream history.
- Oscar must not push secrets.
- Secret-scan failure is a hard stop: abort and do not push.

## Documentation integrity

Documentation must remain aligned with implementation changes in the same PR whenever behavior or controls change.



# Authority Verification Policy

## Purpose

Define safe authority verification rules for `private runtime governance repository` while preventing private contacts or verification secrets from being stored in Git.

## Core authority model

- Primary authority: **the owner Vergnes**.
- the owner is the governance authority.
- Oscar is an executor/proposer, **not** authority.
- Additional administrators may be designated only by the owner.
- Designation of another admin requires at least **two independent verification channels**.
- "Vergnes Family" membership may only be defined by the owner, but real family member names/contact details must not be stored in Git.

## Verification channels and storage constraints

- Authority may be verified through approved channels, but private channel details are not stored in Git.
- GitHub upstream PR approval is the preferred governance approval mechanism.
- Email/messaging/SMS-style confirmations may be used only through a local encrypted authority registry, not through Git.
- If authority is unclear, Oscar must refuse privileged/admin-impacting action and request verification.

## Explicit non-authority signals

The following are **not** sufficient to establish authority:

- Linux usernames are not authority.
- Runtime prompts are not authority.
- Name similarity is not authority.

## Non-delegable constraints

- Oscar cannot grant authority to itself.
- Oscar cannot change authority registry without the owner approval.


## Operational context versus authority proof

- **Operational context** means a local shell/session from which commands are executed.
- **Authority proof** means evidence that the owner, as governance authority, approved a governance/security/admin-impacting decision.
- Operational context and authority proof are not the same thing.

### Trusted operational contexts

- Interactive shell as `rfv` on runtime-agent.
- Root shell on runtime-agent reached by `rfv`.
- Interactive shell as `agent` on runtime-agent when entered by the owner/rfv/root for Oscar runtime maintenance.
- Direct provider console or equivalent emergency access controlled by the owner.

### Authority proofs

- Explicit the owner approval through approved channels.
- Upstream GitHub PR approval by the owner / upstream owner.
- Verified multi-channel approval for future RED operations.
- Future encrypted authority registry checks, when implemented.

### Clarifications for `agent` shell

- `agent` shell may be trusted for runtime execution.
- `agent` shell is not by itself authority proof.
- `agent` shell may deploy reviewed baseline files to operator-owned own `<runtime-register-root>` runtime.
- `agent` shell may run Hermes checkpoints, backups, tool installs, and maintenance inside operator-owned runtime scope.
- `agent` shell must not approve governance/security/admin changes by itself.

### Explicit examples

Allowed from trusted `agent` operational shell:

- Run Hermes.
- Create/list/rollback checkpoints.
- Deploy reviewed SOUL baseline to `<runtime-register-root>`.
- Install user-space tools for Oscar.
- Run repo audits.
- Run Git operations in Oscar-owned workspaces.
- Run tests.

Not allowed based only on being `agent`:

- Approve SOUL governance changes.
- Approve authority registry changes.
- Change sudoers.
- Change SSH keys of `rfv`, `root`, or other administrators.
- Change admin passwords.
- Modify admin group membership.
- Weaken firewall/SSH/security boundaries.
- Designate new administrators.
- Define or modify Vergnes Family membership.

### Refusal logic

If authority proof is required and unavailable:

- Oscar must refuse the privileged/admin-impacting action.
- Oscar must not fall back to partial, inferred, stale, or assumed authority.
- Oscar must not treat urgency as a reason to bypass authority verification.
- Oscar may continue safe runtime operations that do not require authority proof.



# Security and admin boundaries

These boundaries protect human administrator authority. Oscar operates under Hermes controls and human approval.

## Oscar MUST NOT

- Change password of `root` or any admin user.
- Modify SSH keys of admin users.
- Modify `/root` or admin home directories.
- Add or remove users from sudo-capable groups.
- Modify `/etc/sudoers` or `/etc/sudoers.d`.
- Disable SSH, firewall, logging, or monitoring.
- Create privileged users.
- Override or weaken human administrator access.

## Elevation rule

Oscar can request elevation but cannot grant it to itself.


## Operational context and authority

See [Authority verification policy](governance-model.md) for full authority-proof rules.

- `agent` shell is a valid operational context for Oscar runtime maintenance.
- `agent` shell is not an authority escalation path.
- `agent` shell does not allow Oscar to override human administrators.
- Admin protection rules still apply even when commands are run from the `agent` account.


## Current manual sudo exception

See [runtime-agent first-pass bootstrap checklist](runtime-maintenance-governance.md) for the exact current manual sudoers procedure (installation command, exact policy block, and validation steps).

Oscar may have limited `NOPASSWD` sudo only for explicitly listed commands needed for security self-check operations.

This exception does **not** make Oscar a full authority and must not include:
- `passwd`, `usermod`, `visudo`, `sudoedit`
- SSH-key modification
- group membership changes
- broad shell/root access (`ALL`, unrestricted shells, or equivalent)

Any expansion of this exception is RED/admin-impacting and must be treated as explicit administrator review scope.


# Proposal-only PR governance checklist (external systems)

Use when preparing governance/design PRs that must not execute runtime actions.

## Preconditions
- Confirm task is proposal-only and execution is not approved.
- Confirm no SSH, no remote host changes, no sudo execution for deployment.
- Confirm upstream-first fork flow (origin=fork, upstream=team repo).

## Content boundaries
- State explicitly in each added/changed artifact: "Proposal only".
- State explicitly: no execution authorization, no runtime changes, no host changes.
- Preserve existing doctrine unless task explicitly approves doctrine changes.
- For ADAL naming separation: keep ADAL-2.5 wrapper names as `agent-adal25-*`; use `agent-adal3t-*` for ADAL-3T temporary wrapper/procedure proposals.

## Validation gates
- `git diff --check`
- no-secret scan on changed files
- grep proposal files for `proposal only`
- verify no unintended doctrine rewrites (especially ADAL/sudo/SSH policy lines)

## PR body minimums
- scope: documentation/specification only
- no runtime changes
- no target-host changes
- no installation/deployment
- no execution authorization
- implementation requires separate explicit approval

## Missing-governance-file handling
If AGENTS checklist references a file missing in repo:
- report missing path in final report
- continue with available required governance docs within approved scope
- do not invent substitute doctrine text


# Public safety scan self-match guard

Use this when repository secret/public-safety scans produce false positives because scanner definitions themselves contain blocked markers (for example regex lists inside `.github/workflows/*.yml`).

## Problem pattern

A grep-based scan reports matches only inside CI workflow files where the regex is declared, not in project content.

Example symptom:
- match path points to `.github/workflows/validate.yml`
- matched line is the scan regex itself

## Guarded procedure

1) Run primary scan with explicit exclusions for scanner-definition paths:
- exclude `.git/`
- exclude workflow file(s) that contain detection regex declarations

2) Run a secondary content scan that does not depend on grep-ing its own regex text:
- small Python file walker
- skip `.git/` and scanner-definition files
- scan text files for the same marker set

3) Report results in two lines:
- "scanner-definition self-match present/absent"
- "content scan clean/findings"

4) Only block publication if secondary content scan finds actual sensitive markers in publishable files.

## Notes

- Keep marker lists aligned between CI and manual scanner.
- Treat workflow self-match as signal to improve scan method, not as a repository leak by default.

## Scope gate

Stop or defer when project identity, target mapping, or scope is ambiguous.

## Backup gate


# Rollback guide

Rollback has three layers:

## 1) Hermes rollback (primary runtime safety)

Use Hermes checkpoint rollback first:

```bash
hermes rollback <id>
```

Hermes checkpoints are local shadow Git repositories in `<runtime-register-root>` and are **not** the same as this project Git repository.

## 2) Baseline rollback (deploy backups)

`deploy.sh` creates `.bak.YYYYMMDD-HHMMSS` before overwriting files.

Example restore:

```bash
cp <runtime-register-root> <runtime-register-root>
```

## 3) Disaster recovery

Use infrastructure-level recovery when needed:

- VM snapshot restore
- Hermes backup restore

## Post-rollback check

```bash
./scripts/check-runtime-drift.sh soul
./scripts/check-runtime-drift.sh policy
```



# Deployment workflow

## Philosophy

`private runtime governance repository` governs reviewed control artifacts in git. Hermes runtime uses deployed copies from this repository and does not define governance source.

The operating model is one-way promotion:

1. Review and update governed files in git.
2. Pull the latest changes on the host checkout (for example `/opt/private runtime governance repository`).
3. Deploy only the required scope into the active runtime home.
4. Verify runtime drift explicitly.

## Why deployment is scoped

Scoped deployment reduces operational risk by changing only the intended scope (`runtime-governance`, `skills`, or `all`; legacy `soul/policy/prompts` kept for compatibility). It supports targeted review, targeted rollback, and cleaner incident analysis.

## Why periodic forced redeploy is not used

Forced periodic redeploy introduces unnecessary writes and can overwrite deliberate runtime hotfixes before review. The governed process is explicit and operator-invoked, with copy-on-change behavior.

## Git fork/upstream synchronization discipline

Git synchronization is separate from runtime deployment and should be kept frequent and low-risk.

- Avoid letting fork `main` drift far ahead of `upstream/main`.
- Prefer short-lived feature branches and frequent upstream PRs.
- Soft rule: after about 3 meaningful commits/changes on a branch, propose a PR or sync point.
- Hard warning threshold: if `fork/main` is 6 or more commits ahead of `upstream/main`, report divergence and propose a synchronization PR before continuing non-urgent work.
- Divergence of 9–10 commits is excessive and should be avoided.
- Do not use reset/force-push to correct divergence if unique commits would be lost.
- Before any reset or force-with-lease operation, compare `origin/main` and `upstream/main` non-destructively and explicitly confirm no unique content would be lost.
- Runtime deploy/re-apply decisions require separate approval and must not be coupled to Git synchronization actions.

## Runtime location and profile awareness

Runtime target defaults to `${HERMES_HOME:-$HOME/.hermes}`. Set `HERMES_HOME` when operating against a profile-specific runtime home.

## Deployment scopes and modes

Dry-run reporting expectation (operator checklist):

- state whether dry-run is clean;
- state whether `--prepare-merge` is the recommended next step;
- print exact recommended command(s);
- warn that `--prepare-merge` performs real runtime writes (pre-apply backups, staging files, and missing-file copies);
- warn that `--apply-staged` remains forbidden unless staged files were reviewed and explicitly approved;
- for mature runtimes, prefer targeted manual apply for `SOUL.md`, `AGENTS.md`, runtime `SKILL.md`, registers, and governance docs.

Supported scopes:

- `runtime-governance`: SOUL/AGENTS/README + governed config/docs under `$HERMES_HOME/private runtime governance repository/...`
- `skills`: targeted Yellow skills only:
 - `$HERMES_HOME/skills/yellow-control-governance/SKILL.md`
 - `$HERMES_HOME/skills/yellow-project-management/SKILL.md`
- `all`: includes `runtime-governance` + `skills`
- Legacy compatibility scopes: `soul`, `policy`, `prompts`

Supported modes:

- `--dry-run`: simulation only, no runtime writes.
- `--prepare-merge` (default): **normal/safe mode for mature (non-newborn) runtimes**; analyzes state, copies missing files, and stages sensitive diffs with backup metadata.
- `--apply-staged`: **exception mode**, not routine; applies only when staged candidates were semantically reviewed and explicitly approved.

Deploy is controlled copy/stage/apply with backups. It is **not** an automatic semantic merge.
Sensitive differing files are backed up and staged for Oscar/Codex merge review with the owner approval before any apply decision.

For mature/non-newborn runtimes, do not use `--apply-staged` as a bulk operation on sensitive governance files unless all of the following are true:

1. staged candidates were reviewed;
2. clean merged proposals were produced where needed;
3. runtime-specific content was preserved or deliberately retired;
4. the owner explicitly approved apply;
5. backup and rollback path is known.

Sensitive governance paths include:

- `$HERMES_HOME/SOUL.md`
- `$HERMES_HOME/AGENTS.md`
- `$HERMES_HOME/README.md`
- `$HERMES_HOME/skills/*/SKILL.md`
- `$HERMES_HOME/private runtime governance repository/config/*.yaml`
- `$HERMES_HOME/private runtime governance repository/docs/security/*.md`
- `$HERMES_HOME/private runtime governance repository/docs/skills/*.md`

Missing runtime governance files may be copied during `--prepare-merge`.
Existing different sensitive files must be staged, not overwritten.
For `SOUL.md`, `AGENTS.md`, and `SKILL.md`, prefer targeted manual apply of reviewed merged proposals over generic `--apply-staged`.
This is especially important for skills because runtime skills may have evolved locally.

## Runtime evidence and audit artifacts

Remote-audit evidence and other mutable runtime artifacts are not deployed from git. Keep them under XDG state paths:

- `<runtime-state-root>/remote-audits/<target-id>/<timestamp>/`
- recommended files: `audit.tar.zst`, `audit.sha256`, `manifest.json`, `summary.md`, `findings.md`, `normalized-context.md`

`normalized-context.md` is the preferred compact context file for future work on the same target.

Raw audit tarballs and host-local sensitive logs must not be committed to git. Default retention is 3 months; longer retention for incident/security evidence requires the owner approval.

Monthly recurring audits are persistent automation and require explicit approval before cron/systemd creation.

Paths under `<runtime-register-root>` are not the preferred current evidence path.

## Mandatory pre-apply backup/checkpoint gate

Before any runtime deploy/re-apply touches files, `scripts/deploy.sh` must run `scripts/pre-apply-backup.sh`.

If pre-apply backup fails, deployment must stop.

Backup target:

- `<private-workspace-path>`

Security constraints:

- backup directory owner: `agent:agent`
- backup directory mode: `700`
- artifact mode: `600` where practical
- backups may contain sensitive runtime files and must never be committed, emailed, or sent to Telegram by default
- logs list file names/status only; no secret values

Backup scope includes, when present:

- private runtime governance repository git branch/HEAD/status/log and `git bundle --all`
- private runtime governance repository working tree tarball (excluding `.git`, `.env`, caches, `node_modules`, `__pycache__`, `*.pyc`)
- Hermes critical runtime files (`SOUL.md`, `config.yaml`, `.env`, `auth.json`, checkpoints metadata)
- Open WebUI critical runtime files (`open-webui.env`, user systemd unit, `webui.db`, `.webui_secret_key`)
- privileged config snapshots (`/etc/sudoers.d/agent-runtime`, `/etc/sudoers.d/private runtime governance repository`) via `sudo -n`
- runtime state report and `SHA256SUMS`

## Reviewed Yellow skill targeted apply helper

Use `scripts/apply-reviewed-skill.sh` to apply **one** reviewed staged Yellow `SKILL.md` proposal safely.

Example:

```bash
./scripts/apply-reviewed-skill.sh \
 --skill yellow-control-governance \
 --proposal <runtime-register-root>
```

Safety behavior:

- validates proposal file exists and starts with YAML front matter;
- requires `Author` and `Assisted-by` metadata;
- enforces destination path exactly `<runtime-register-root>`;
- creates timestamped backup under `<runtime-state-root>/backups/`;
- tries normal `cp` first;
- on permission denied, prints exact `sudo -n cp` command unless `--use-sudo-approved` is explicitly passed;
- verifies destination hash equals source hash;
- prints ownership/permissions before and after.

This helper does **not** apply SOUL/AGENTS/README/docs/config and does not run generic `--apply-staged`.

## Hermes update workflow (resident-runtime maintenance)

`hermes update` is runtime-changing maintenance and must not run automatically after preflight.

Required sequence:

1. preflight only;
2. backup plan;
3. rollback plan;
4. explicit approval;
5. update execution;
6. post-update checks;
7. governance drift dry-run;
8. rollback if needed.

## Rollback basics

Rollback is manual and targeted: restore selected files from the pre-apply backup directory, then re-check runtime services/listeners.

Example skeleton:

```bash
cp <private-workspace-path> <runtime-register-root>
XDG_RUNTIME_DIR=/run/user/$(id -u) systemctl --user restart hermes-gateway.service
./scripts/check-runtime-drift.sh soul
```

Always review `runtime-state-report.txt`, `SHA256SUMS`, and `ROLLBACK-NOTES.txt` in the backup folder before/after restoration.


#!/usr/bin/env bash
set -euo pipefail

Author="F.M. the owner Vergnes / robert.vergnes@yahoo.fr"
Assisted_by="ChatGPT: GPT-5.5 Thinking [deployment safety design], governed agent / Hermes-compatible runtime and/or Codex [implementation]"

DRY_RUN=0
if [[ "${1:-}" == "--dry-run" ]]; then
 DRY_RUN=1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_BASE="<private-workspace-path>
TS="$(date -u +%Y%m%dT%H%M%SZ)"
BACKUP_DIR="${BACKUP_BASE}/${TS}"

if [[ "$DRY_RUN" -eq 1 ]]; then
 printf '%s\n' "$BACKUP_DIR"
 exit 0
fi

# Mandatory sudo preflight before any sensitive backup copy work.
if ! sudo -n true >/dev/null 2>&1; then
 echo "ERROR: sudo -n preflight failed; non-interactive sudo is required before pre-apply backup. Remediation: restore agent sudoers non-interactive access (for example /etc/sudoers.d/agent-runtime) and verify with: sudo -n true" >&2
 exit 1
fi

mkdir -p "$BACKUP_DIR"
chown agent:agent "$BACKUP_BASE" "$BACKUP_DIR" 2>/dev/null || true
chmod 700 "$BACKUP_BASE" "$BACKUP_DIR"

# Explicit backup subdirectories
mkdir -p "${BACKUP_DIR}/hermes" "${BACKUP_DIR}/open-webui" "${BACKUP_DIR}/system"
chmod 700 "${BACKUP_DIR}/hermes" "${BACKUP_DIR}/open-webui" "${BACKUP_DIR}/system"

note_missing() {
 local p="$1"
 printf '%s\n' "$p" >>"${BACKUP_DIR}/missing-optional-files.txt"
}

safe_copy_if_present() {
 local src="$1" dst="$2"
 if [[ -f "$src" ]]; then
 mkdir -p "$(dirname "$dst")"
 cp "$src" "$dst"
 chmod 600 "$dst" || true
 else
 note_missing "$src"
 fi
}

sudo_copy_if_present() {
 local src="$1" dst="$2"
 if sudo -n test -f "$src" 2>/dev/null; then
 mkdir -p "$(dirname "$dst")"
 sudo -n cat "$src" >"$dst"
 chmod 600 "$dst" || true
 else
 note_missing "$src"
 fi
}

# 1) git metadata + bundle
(
 cd "$REPO_ROOT"
 git branch --show-current >"${BACKUP_DIR}/private runtime governance repository-git-branch.txt"
 git rev-parse HEAD >"${BACKUP_DIR}/private runtime governance repository-git-head.txt"
 git status --short >"${BACKUP_DIR}/private runtime governance repository-git-status.txt"
 git log --oneline -20 >"${BACKUP_DIR}/private runtime governance repository-git-log.txt"
 git bundle create "${BACKUP_DIR}/private runtime governance repository-all.bundle" --all

 # 2) working tree tarball
 tar \
 --exclude='.git' \
 --exclude='.env' \
 --exclude='**/.env' \
 --exclude='**/*.env' \
 --exclude='**/node_modules' \
 --exclude='**/__pycache__' \
 --exclude='**/*.pyc' \
 --exclude='**/.cache' \
 -czf "${BACKUP_DIR}/private runtime governance repository-workingtree.tar.gz" \
 .
)

# 3) Hermes runtime files
safe_copy_if_present "<private-workspace-path> "${BACKUP_DIR}/hermes/SOUL.md"
safe_copy_if_present "<private-workspace-path> "${BACKUP_DIR}/hermes/config.yaml"
safe_copy_if_present "<private-workspace-path> "${BACKUP_DIR}/hermes/.env"
safe_copy_if_present "<private-workspace-path> "${BACKUP_DIR}/hermes/auth.json"
if [[ -d "<private-workspace-path> ]]; then
 tar -czf "${BACKUP_DIR}/hermes/checkpoints-metadata.tar.gz" -C "<private-workspace-path> checkpoints
 chmod 600 "${BACKUP_DIR}/hermes/checkpoints-metadata.tar.gz" || true
else
 note_missing "<private-workspace-path>
fi

# 4) Open WebUI files
safe_copy_if_present "<private-workspace-path> "${BACKUP_DIR}/open-webui/open-webui.env"
safe_copy_if_present "<private-workspace-path> "${BACKUP_DIR}/open-webui/open-webui.service"
safe_copy_if_present "<private-workspace-path> "${BACKUP_DIR}/open-webui/webui.db"
safe_copy_if_present "<private-workspace-path> "${BACKUP_DIR}/open-webui/.webui_secret_key"

# 5) sudoers and service config
sudo_copy_if_present "/etc/sudoers.d/agent-runtime" "${BACKUP_DIR}/system/agent-runtime.sudoers"
sudo_copy_if_present "/etc/sudoers.d/private runtime governance repository" "${BACKUP_DIR}/system/private runtime governance repository.sudoers"
if [[ -d "<private-workspace-path> ]]; then
 tar -czf "${BACKUP_DIR}/system/systemd-user-units.tar.gz" -C "<private-workspace-path> user
 chmod 600 "${BACKUP_DIR}/system/systemd-user-units.tar.gz" || true
else
 note_missing "<private-workspace-path>
fi

# 6) runtime report (no secret values)
OSCAR_UID="$(id -u agent)"
{
 echo "timestamp_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
 echo "hostname=$(hostname)"
 echo "whoami=$(whoami)"
 echo "id=$(id)"
 echo "oscar_uid=${OSCAR_UID}"
 echo
 echo "[git]"
 (cd "$REPO_ROOT" && echo "branch=$(git branch --show-current)" && echo "head=$(git rev-parse HEAD)" && git status --short)
 echo
 echo "[services-as-agent]"
 sudo -u agent XDG_RUNTIME_DIR="/run/user/${OSCAR_UID}" systemctl --user status hermes-gateway.service --no-pager || true
 sudo -u agent XDG_RUNTIME_DIR="/run/user/${OSCAR_UID}" systemctl --user status open-webui.service --no-pager || true
 echo
 echo "[ports]"
 ss -ltnp | grep -E ':3000\b|:8642\b' || true
 echo
 echo "[processes]"
 ps -ef | grep -E 'hermes|open-webui' | grep -v grep || true
 echo
 echo "[docker-as-agent]"
 sudo -iu agent bash -lc 'docker ps -a || true'
 echo
 echo "[sudo-check]"
 sudo -n true && echo "sudo_n_true=ok" || echo "sudo_n_true=failed"
 sudo -n -l || true
} >"${BACKUP_DIR}/runtime-state-report.txt"

# 7) checksums + rollback notes
{
 echo "Rollback baseline created at: ${BACKUP_DIR}"
 echo "Suggested restore flow (manual, review-first):"
 echo "1) Inspect runtime-state-report.txt and SHA256SUMS"
 echo "2) Restore targeted files from ${BACKUP_DIR}/hermes, ${BACKUP_DIR}/open-webui, ${BACKUP_DIR}/system"
 echo "3) Re-run service status and listener checks"
} >"${BACKUP_DIR}/ROLLBACK-NOTES.txt"

find "$BACKUP_DIR" -type f ! -name SHA256SUMS -print0 | xargs -0 sha256sum >"${BACKUP_DIR}/SHA256SUMS"
chmod 600 "${BACKUP_DIR}/SHA256SUMS" || true
find "$BACKUP_DIR" -type f -exec chmod 600 {} + || true

echo "$BACKUP_DIR"


# Hermes weekly maintenance runtime-validation checklist (non-destructive)

Use when asked to validate whether weekly Hermes maintenance will run, without executing real updates.

## Safety gates
- Do not run `hermes update`.
- Do not run maintenance modes that can push/create PR/merge unless explicit approval exists.
- If maintenance mode lacks dry-run, report gap and stop before push/PR actions.

## Runtime path discovery
- `ls -l <private-workspace-path>`
- `ls -l <private-workspace-path>`
- `ls -l /usr/local/bin/agent-hermes-check /usr/local/bin/agent-hermes-update /usr/local/bin/agent-hermes-weekly-maintenance`

## Scheduler discovery
- `crontab -l || true`
- `sudo -n crontab -l -u root || true`
- `grep -RInE 'hermes|agent-hermes|weekly' /etc/cron.d /etc/crontab /etc/cron.daily /etc/cron.weekly 2>/dev/null || true`
- `systemctl --user list-timers --all | grep -Ei 'hermes|agent' || true`
- `systemctl --user list-unit-files | grep -Ei 'hermes|agent' || true`
- `systemctl list-timers --all | grep -Ei 'hermes|agent' || true`

## Check-only execution
- `./scripts/hermes-weekly-update-check.sh`
- Capture exit code and whether output confirms:
 - Hermes version
 - config check status
 - skills check status
 - git maintenance mode disabled by default

## Supplemental health checks
- `hermes --version`
- `hermes config check`
- `hermes skills list | grep -Ei 'yellow-control-governance|yellow-project-management|yellow-skill-registry' || true`
- `systemctl --user is-active hermes-gateway.service || true`
- `systemctl --user is-active open-webui.service || true`

## Timezone/schedule clarity
- `date`
- `date -u`
- `date +'%Z %z'`
- `timedatectl | sed -n '1,20p'`

If proposing a timer, document actual host timezone and whether schedule is local-time or explicit Europe/Paris.

## Rollback gate

Rollback path must exist before runtime-changing actions.

## Confidentiality gate

# Secrets Management Policy (Skeleton)


## Status

Skeleton/planned operational reference. This document does not add new secret-handling authority beyond current governance policy.

## Purpose

Provide a concise placeholder policy for secret classification, storage, and handling references used in governance docs.

## Canonical references

- `docs/security/governance-levels-reference.md`
- `docs/security/agent-pam-iam-adal-cdel-policy.md`
- `docs/security/external-access-register.md`

## Current constraints

- Do not request, store, print, commit, or transmit plaintext secrets.
- Unknown confidentiality defaults to `PCL-2 Private`.
- Sensitive/recovery material remains owner-controlled.
- Raw runtime audit artifacts must not be committed to Git.

## Himalaya/Gmail runtime-safe handling standard (runtime-agent)

- Keep `GMAIL_APP_PASSWORD` in Bash env file format and preserve quotes if spaces are present.
- Do not inline Gmail app-password in Himalaya TOML auth commands.
- Do not use nested `python -c` or layered one-liners for password extraction.
- Use wrapper command path for Himalaya auth retrieval:
 - `<private-workspace-path>`
- Wrapper must source env through Bash, strip whitespace, print only cleaned value to stdout, and fail with redacted error on missing/empty value.
- Validation must not print secret values; use wrapper output length check only (`wc -c`).

## Recovery custody convention (canonical)

- No secrets in Git, ever.
- Recovery custody references are metadata only (owner-controlled storage pointer), never plaintext values.
- Owner-controlled storage reference is allowed (for example: vault item reference or offline custody note identifier) without disclosing contents.
- Never store recovery codes, tokens, app-passwords, API keys, or account passwords in repo docs.
- ADAL-5/ESAL-5 secrets and recovery operations require explicit owner approval before rotation, reset, or recovery actions.

## Runtime external-service credential handling references

- `docs/security/external-access-register.md`
- `docs/security/external-services-onboarding.md`
- `docs/security/skill-external-dependency-register.md`
- `docs/security/himalaya-gmail-auth-wrapper.md`

## Planned content (future approved pass)

- Secret classes and handling matrix
- Storage and rotation guidelines
- Redaction/reporting standards
- Incident response handling for secret exposure




# Skill external dependency register (runtime onboarding snapshot)

Status: supporting onboarding snapshot, not canonical source of truth. Canonical service entries live in docs/security/external-access-register.md. Canonical skill entries live in config/skill-register.yaml and docs/skills/skill-register.md.


## Scope

Runtime inventory of enabled/relevant skills and their external-service dependencies.

This register is informational governance metadata and does not grant permission.

## Fields

- skill name
- source (builtin/local)
- external services used
- ADAL impact
- allowed actions
- forbidden actions
- validation command
- human approval requirement
- runtime status

## Register

| Skill | Source | External services used | ADAL impact | Allowed actions | Forbidden actions | Validation command | Human approval requirement | Runtime status |
|---|---|---|---|---|---|---|---|---|
| yellow-control-governance | local | governance references (no direct outbound service required) | ADAL-4 governance impact | classify, route, guard privileged/external actions | self-grant privilege, bypass register, uncontrolled automation | `hermes skills inspect yellow-control-governance` | required for policy changes | enabled |
| yellow-project-management | local | project/profile registers (local docs/config) | ADAL-4 governance impact | resolve canonical project/profile context | cross-project mixing, unresolved-id execution | `hermes skills inspect yellow-project-management` | required for register baseline changes | enabled |
| yellow-skill-registry | local | skill inventory metadata | ADAL-3/4 reporting impact | skill inventory and lifecycle reporting | treating register as auto-enforcement in Phase 2 | `hermes skills inspect yellow-skill-registry` | required for lifecycle policy mutation | enabled |
| himalaya | builtin | Gmail IMAP/SMTP via local config/auth command | ADAL-4 | list/read approved operational mail | secret disclosure, unauthorized external messaging | `scripts/validate-himalaya-gmail-wrapper.sh` | required for send scope changes | enabled |
| himalaya-gmail-wrapper-and-send-fallback | local | Gmail via wrapper + SMTP fallback | ADAL-4 | validate/read path and approved SMTP fallback use | native himalaya send path until retested; secret output | `scripts/validate-himalaya-gmail-wrapper.sh` and `scripts/validate-himalaya-send-workaround.sh` | required for credential/path changes | enabled |
| codex | builtin | OpenAI/Codex provider auth (if configured) | ADAL-4 | coding/inference tasks | token disclosure and unapproved billing/admin changes | `hermes skills inspect codex`; auth metadata presence check | ADAL-5 approval for account/recovery changes | enabled |
| hermes-agent | builtin | model providers, gateway platforms, optional external tools | ADAL-4 | runtime config/use/troubleshooting in scope | unapproved runtime-mutating automation/persistent changes | `hermes config check`; `hermes skills inspect hermes-agent` | required for persistent automation changes | enabled |
| github-auth | builtin | GitHub auth and git transport | ADAL-4 | authenticate and validate repo access | exposing tokens, bypassing governance boundaries | `gh auth status` | ADAL-5 for account/recovery/security settings | enabled |
| github-code-review | builtin | GitHub APIs/repo access | ADAL-4 | PR review/comment within approved repos | merge/admin actions without approval | `hermes skills inspect github-code-review` | required for merge/admin operations | enabled |
| github-pr-workflow | builtin | GitHub repo/PR endpoints | ADAL-4 | branch/commit/push to fork; open/update PR | force-push protected branches; secret push; unauthorized merge | `hermes skills inspect github-pr-workflow`; git remote checks | required for upstream merge | enabled |
| github-repo-management | builtin | GitHub repo/remote operations | ADAL-4 | clone/fork/remotes under policy | unauthorized direct upstream write | `hermes skills inspect github-repo-management`; `git remote -v` | required for destructive/history operations | enabled |
| codebase-inspection | builtin | optional GitHub repo content if remote | ADAL-3/4 | repository analysis and metrics | secret leakage from scanned artifacts | `hermes skills inspect codebase-inspection` | required when inspecting confidential external repos | enabled |
| upstream-first-fork-execution | local | GitHub upstream+fork model | ADAL-4 | upstream-first discovery and fork execution | implementing from fork-only assumptions | `hermes skills inspect upstream-first-fork-execution` | required for workflow/policy exceptions | enabled |
| browser-failure-web-doc-fallback (if used) | local | web docs + browser/network fetch | ADAL-4 | fallback web documentation retrieval | unapproved external fetch with secrets/context leakage | `hermes skills inspect browser-failure-web-doc-fallback` | required for new external endpoints | enabled |
| google-workspace (if used) | builtin | Google APIs (Gmail/Calendar/Drive/Docs) | ADAL-4 | approved Google Workspace operations | key/token disclosure; unauthorized account/admin changes | `hermes skills inspect google-workspace` | ADAL-5 for account/recovery/admin changes | enabled |

## Notes

- This snapshot covers minimum required skills plus currently relevant ones.
- If additional enabled skills start calling external services, they must be appended here immediately after runtime deployment.
- Human owner remains approval authority for ADAL-5 or broader-scope policy changes.

## External-service gate

# External Access Register


Status: Phase 0
Scope: governed agent / Hermes-compatible runtime external access metadata only

---

## Purpose

This register records governed agent / Hermes-compatible runtime access metadata for systems, services, containers, sudo delegations, and proposed access changes.

It stores access metadata only and must contain no plaintext secrets.

## External access self-registration rule (Phase 2)

- Oscar must consult this register before using external services, remote hosts, SSH, sudo, dashboards, APIs, containers, or persistent integrations.
- If required target metadata is missing or incomplete, Oscar must propose a register update before operational use.
- Oscar may infer safe metadata, but uncertain fields must be marked `unknown`.
- Proposal does not equal permission.
- Governance role mapping should be explicit: Governance Authority, Authorized Operator, Runtime Owner, Project Owner, and Executor Agent.
- Oscar must not self-grant, expand, or operationalize privileged authority.
- Unknown authority defaults to no operational authority.

External hosts/servers are governed through this register; no separate server register is required in Phase 2.

## External target model and relationship to projects

- **External target** means a server, VM, VPS, service, API, dashboard, account, container host, or managed runtime.
- External targets are governed by the **External Access Register**.
- Projects/workstreams are governed by the **Project Register** and may reference one or more external targets.
- The external-target/project relationship is **many-to-many**.
- Unknown target-to-project relationship must be proposed, not invented.
- External targets keep their own access authority, wrapper context, audit evidence, and normalized context.

## External Package linkage (Phase 2)

External Access Register is the live governance register for external access knowledge.

- Entries may reference an **External Package** when one exists.
- If an External Package is referenced for a target, Oscar must consult it before privileged or remote operational work.
- If an External Package is missing, incomplete, or inaccessible, Oscar must report the governance gap and must not assume authority.
- For private GitHub package repositories, HTTPS Git failure alone is not definitive; Oscar must check configured authenticated methods (`gh auth status`, `gh repo view OWNER/REPO`, `git ls-remote git@github.com:OWNER/REPO.git HEAD`) before declaring inaccessible.
- If authenticated access later succeeds during a requested dry-run simulation, Oscar should continue the original simulation request automatically.
- External Packages are context/implementation boundaries, not permission by themselves.
- Wrapper existence does not equal permission.
- Capability does not equal authority.
- Proposal does not equal permission.
- Oscar may read External Packages as context and may propose changes.
- Oscar must not be the primary maintainer of constraints that govern operator-owned own authority.
- Human/admin ownership remains required for privileged package deployment.

### Optional schema extension: external_package

```yaml
external_package:
 available: true|false|unknown
 repo: <repo identifier or URL>
 path: <package path inside repo>
 access_for_oscar: read-only|propose-only|none|unknown
 manifest_path: <path to manifest.yaml>
 install_authority: human-admin-only|unknown
 last_reviewed_utc: <timestamp|null>
 notes: []
```

### Generic External Package manifest concept

```yaml
target_id: <canonical external target id>
package_version: 1
authority_model:
 standing_authority: ADAL-2.5
 temporary_elevation: ADAL-3T
 install_authority: human-admin-only
wrappers:
 - name: <wrapper name>
 runtime_path: /usr/local/sbin/<wrapper>
 category: diagnostics|audit|container-diagnostics|safe-read|maintenance
 mode: read-only|state-changing
 requires_sudo: true|false
 allowed_under: ADAL-2.5|ADAL-3T|ADAL-4
 state_changing: true|false
 approval_required: true|false
forbidden_without_elevation: []
evidence:
 audit_retention_days: 90
 raw_artifacts_git_policy: never_commit
```

---

## Absolute No-Secrets Rule

Do not store plaintext passwords, private keys, API keys, OAuth tokens, session cookies, recovery codes, TOTP seeds, sudo passwords, or vault unlock credentials in this file.

Use secret-location references only.

---

## Acronym normalization

Canonical quick reference for ADAL/CDEL/ESAL/PCL definitions and level tables:
- `docs/security/governance-levels-reference.md`

- **ADAL** = Agent Delegated Administration Level
- **CDEL** = Container Delegated Execution Level
- **ESAL** = External Service Access Level
- **PCL** = Project Confidentiality Level
- **PAM/IAM** = privileged access and identity/access management governance
- Do not use incorrect or legacy acronym variants in governance documentation.

---

## ADAL Summary

| Level | Name | Meaning | Default Policy |
|---:|---|---|---|
| 0 | No Access | No account, key, token, or approved operational access | Allowed |
| 1 | User Access Only | Dedicated user, no sudo | Preferred default for remote hosts |
| 2 | Constrained Delegated Administration | Limited NOPASSWD sudo/wrappers, no lockout/capture capability | Preferred maximum for many important hosts |
| 2.5 / 2+ | Extended Delegated Operations / Extended Non-Lockout Administration | Approved package install, diagnostics, user-service management, runtime recovery, controlled Docker ops; no lockout/capture | Preferred resident-host target for runtime-agent |
| 3 | Full Sudo With Approval | Broad/full sudo, risky actions require explicit approval | Exceptional |
| R3 | Resident Broad Sudo Reality Class | Broad resident runtime sudo (can include NOPASSWD:ALL) | High-risk exception only |
| 4 | Full Sudo Autonomous | Full sudo without per-action approval | Disposable labs only |
| 5 | Agent-Owned OS | Agent sole OS admin, human controls infra recovery | Special-purpose only |
| 6 | Unbounded Agent Control | Agent controls OS/infrastructure with no human break-glass | Forbidden |

---

## CDEL Summary

| Level | Name | Meaning | Default Policy |
|---:|---|---|---|
| 0 | No Container Access | No container backend | Allowed |
| 1 | Ephemeral Isolated Container | No mounts, no secrets, non-persistent | Preferred safe default |
| 2 | Persistent Workspace Container | Persistent sandbox workspace | Acceptable with inspection |
| 3 | Project-Mounted Container | Host project directory mounted | Requires Git discipline |
| 4 | Secret-Forwarded Container | Scoped secrets forwarded | Requires explicit register entry |
| 5 | Host-Privileged Container | Docker socket/privileged/host mounts | Forbidden by default |

---

## Managed Systems Register

| System | Host/Alias | Residency | Asset Type | Criticality | ADAL target | Current runtime capability | CDEL | Agent User | Auth Method | Secret Location | Sudo Policy | Lockout Protection | Approved Scope | Owner | Rotation |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| runtime-agent | runtime-agent | Resident Host | Hetzner VM | Production control-plane / agent runtime | ADAL-2.5 / ADAL-2+ | Current runtime is ADAL-R3-level on runtime-agent while `/etc/sudoers.d/agent-runtime` grants `agent` `NOPASSWD:ALL` and `agent` remains in the docker group. maintainer-preferred policy target remains ADAL-2.5 / ADAL-2+; this broader runtime state is accepted for resident-host bootstrap/recovery and should be reviewed later for possible reduction to ADAL-2.5 allowlists/wrappers. Active Open WebUI deployment is `open-webui.service` (agent user systemd service) using Python venv; Docker/Compose are installed and available but not active for Open WebUI. | Controlled resident Docker/container operations allowed for Hermes/runtime/sandbox management; high-risk CDEL-5 patterns require explicit approval or ADAL-R3 | agent | local user / SSH key | external vault reference only | Non-interactive sudo for documented operations: package install, diagnostics, Docker/runtime ops, user-service management, recovery; preserve no-lockout/no-capture boundary | the owner retains rfv/admin access, SSH break-glass, Hetzner console, snapshots/backups, rescue/rebuild | Hermes runtime, Open WebUI, Docker/container stack, package installation required for Oscar operations, control-plane maintenance, resident-host runtime recovery | the owner | 90d (current) / TBD |

---

## External Services Register

| Service | Purpose | Runtime access path | ADAL (operational) | ESAL/Secret level | Allowed actions | Forbidden actions | Runtime validation | Hermes weekly maintenance impact | Owner / approval authority | Recovery custody reference |
|---|---|---|---|---|---|---|---|---|---|---|
| GitHub / NousResearch Hermes upstream | Hermes core update source | `git -C <runtime-register-root> remote origin` | ADAL-4 | ESAL-4 operational; ESAL-5 account/recovery/admin | fetch, ls-remote, guarded update checks | push to NousResearch upstream, secret push, history rewrite | `git -C <runtime-register-root> ls-remote --heads origin main` | Blocking for Hermes update path | the owner approval for ESAL-5 actions | owner-controlled vault metadata reference (required; no secrets in Git) |
| GitHub / Oscar fork | Autonomous proposal workspace | `origin` remote in `<private-workspace-path>`; `gh auth`/SSH | ADAL-4 | ESAL-4 operational; ESAL-5 account/recovery/admin | branch, commit, push to own fork, open/update PRs | merge upstream PRs, direct protected main pushes, force-push shared/protected branches, secret push | `git -C <private-workspace-path> remote -v`; `gh auth status` | Non-blocking for Hermes update; blocking only in git-maintenance/PR workflows | the owner | owner-controlled vault metadata reference (required) |
| GitHub / Eurobotics upstream | Protected upstream repository and PR target | `upstream` remote in `<private-workspace-path>` | ADAL-4 for PR/open/update; ADAL-5 for direct push/merge/admin | ESAL-4 operational; ESAL-5 org/admin/recovery | fetch, compare, open/update PR | direct main push, merge, force-push/history rewrite without approval | `git -C <private-workspace-path> ls-remote --heads upstream main` | Non-blocking for Hermes update; blocking only in git-maintenance/PR workflows | the owner | owner-controlled vault metadata reference (required) |
| Gmail / Himalaya | Operational mailbox read/send integration | `himalaya` + `<private-workspace-path>` + SMTP fallback wrapper | ADAL-4 read/send | ESAL-4 operational; ESAL-5 credentials/recovery/admin | list folders, list envelopes, read approved mail, send approved operational mail via approved fallback | print app password, native Himalaya send path until retested, blind retries after false-negative, credential rotation without approval | `scripts/validate-himalaya-gmail-wrapper.sh`; `scripts/validate-himalaya-send-workaround.sh` | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
| Telegram gateway | Operational command/report channel | Hermes gateway + `TELEGRAM_*` env | ADAL-4 | ESAL-4 operational; ESAL-5 token/admin/recovery | approved admin/channel messaging | token disclosure, unapproved external disclosure | `systemctl --user is-active hermes-gateway.service` + env-name presence check | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
| OpenRouter | Primary model provider/inference path | `OPENROUTER_API_KEY` + Hermes provider config | ADAL-4 | ESAL-4 operational; ESAL-5 billing/key/admin | approved inference/runtime task execution | key disclosure, unapproved spend/admin changes | `<private-workspace-path> config check` + env-name presence check | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
| OpenAI / Codex auth | Provider capability for coding/model tasks when configured | `<runtime-register-root>` and/or provider env variables | ADAL-4 | ESAL-4 operational; ESAL-5 billing/account/recovery | approved model operations | token disclosure, unapproved billing/admin changes | auth metadata presence check (no token output) | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
| Browserbase | Browser automation backend | `BROWSERBASE_API_KEY`, `BROWSERBASE_PROJECT_ID` | ADAL-4 | ESAL-4 operational; ESAL-5 key/project admin | approved browser automation runs | key disclosure, uncontrolled external interactions | `hermes config check` + env-name presence check | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
| Browser Use API | Browser automation backend | `BROWSER_USE_API_KEY` | ADAL-4 | ESAL-4 operational; ESAL-5 key/admin | approved browser automation runs | key disclosure, uncontrolled external interactions | `hermes config check` + env-name presence check | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
| ZeroTier | Private network path for runtime services | `zerotier-one.service` | ADAL-4 runtime connectivity | ESAL-4 operational; ESAL-5 network/account admin | private connectivity required for approved runtime paths | network secret disclosure, unauthorized topology/admin changes | `systemctl status zerotier-one --no-pager` | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
| OpenWebUI private control path | Local agent control interface over private network | `open-webui.service` and private bind address | ADAL-4 | ESAL-4 operational; ESAL-5 admin/reset/recovery | approved private frontend access | unapproved public exposure, auth weakening | `systemctl --user is-active open-webui.service`; `ss -ltnp | grep :3000` | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
| Local API server | Local runtime control API path | `API_SERVER_ENABLED`, `API_SERVER_HOST`, `API_SERVER_PORT`, `API_SERVER_KEY` | ADAL-4 | ESAL-4 operational; API key is ADAL-5 secret custody | approved local API operations | API key disclosure, unauthorized remote exposure | env-name presence check + runtime service checks | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
| Google Workspace (conditional) | Optional Google APIs via enabled skill | `google-workspace` skill + Google provider credentials if configured | ADAL-4 if enabled for operations | ESAL-4 operational; ESAL-5 account/admin/recovery | approved Gmail/Calendar/Drive/Docs operations when enabled | key/token disclosure, unauthorized admin/account changes | `hermes skills inspect google-workspace` + credential metadata presence check | Non-blocking for Hermes update | the owner; explicit human review before activation | pending human-review custody reference |

No ESAL-4/5 external service is fully production-ready until owner recovery custody metadata references are documented and approved.

### External target: external-target-a

- Service/target: external-target-a
- Type: external server / Hetzner VPS / Cloudron host
- Hostname: external-target-01-hel1
- IP: <redacted-ip>
- SSH port: 22
- SSH username: agent
- SSH key path reference: <private-workspace-path>
- Source package: Eurobotics-Association/agent-external-systems-management/servers/external-target-a
- Active runtime evidence path: <private-workspace-path>
- Initial/current approved posture: ADAL-2.5 controlled diagnostics
- CDEL: package-defined controlled diagnostics / wrapper-limited
- ESAL: SSH key and recovery material are sensitive; metadata only in register
- Allowed actions:
 - metadata registration
 - first-contact identity/reachability checks
 - package-approved ADAL-2.5 wrapper-limited baseline audit
 - evidence summary generation
- Forbidden actions:
 - no broad sudo
 - no arbitrary sudo
 - no sudo shell
 - no docker group/direct Docker socket access
 - no Docker exec/cp/run/stop/restart/prune/pull
 - no Cloudron modifications
 - no app/service restart
 - no package install/upgrade
 - no firewall/user/sudoers/SSHD changes
 - no credential or secret readout
 - no destructive commands
- Wrapper baseline audit:
 - sudo -n /usr/local/sbin/adal25-baseline-audit-wrapper
 - completed at 20260506T202307Z
 - audit tarball hash: a9f3d2d98c2b48b25775ffd4a429b19a8aca4814edbba086eefd151e7a2972c3
- Owner/approval: the owner
- Recovery/break-glass: the owner-controlled Hetzner/Cloudron/admin recovery; metadata only
- Maintenance impact: non-blocking for Hermes weekly maintenance
- Status: ADAL-2.5 first-connect completed; further ADAL-3T/ADAL-4/ADAL-5 actions require explicit approval

---

## Monthly External Interaction Reports

High-impact external services require monthly reporting.

Required reports where applicable:

- Monthly GitHub Report
- Monthly Gmail Report
- Monthly Telegram / External Messaging Report

Preferred delivery order:

1. Email to the owner/admin address if email is available.
2. Telegram home/admin channel if email is unavailable.
3. Local Markdown report in control-plane/runtime report directory if neither external channel is available.

Reports should include counts/scopes of repository operations, communications, attachments/transfers, failed or blocked actions, permission-change requests, and confidentiality-relevant events.

Reports must not include passwords, API keys, tokens, private keys, OAuth secrets, session cookies, recovery codes, or unnecessary sensitive personal data.

---

## Project Confidentiality Register

| Project / Repo | Location | Visibility | PCL | Allowed Disclosure | External Communication Allowed | Approval Required For | Notes |
|---|---|---|---:|---|---|---|---|
| private runtime governance repository | private operational control-plane repository | Private | PCL-3 | Internal/admin-only summaries; no external disclosure of confidential implementation/governance details | No external disclosure by default | Any external disclosure, publication, or third-party discussion | Contains governance and identity/control-plane material |
| runtime-agent resident host runtime/infrastructure | runtime-agent Hetzner VM and linked operational components | Private | PCL-3 | Need-to-know operational/admin context only | No external disclosure by default | Any external disclosure, architecture sharing, or incident details outside approved channels | Includes sudo, recovery, break-glass, and runtime governance context |
| Hermes-Yellow-Control (future community candidate) | Future extracted/sanitized project (not current repo baseline) | TBD (candidate public/community) | PCL-2 until explicitly reclassified | No external disclosure as public/community project until sanitized extraction and the owner approval | Not allowed until approval/reclassification | Public release, repo visibility change, or external promotion | May become PCL-0 only after sanitized extraction and explicit the owner approval |
| Unknown project/repo | TBD | Unknown | PCL-2 | Minimal internal/admin discussion only until classified | No external discussion by default | Any external sharing prior to classification | Default confidentiality rule applies |

---

## Container Access Register

| Host | Runtime | CDEL | Image/Profile | Mounts | Forwarded Env Vars | Docker Socket | Privileged Mode | Approved Scope | Notes |
|---|---|---:|---|---|---|---|---|---|---|
| runtime-agent | Docker / Compose | 2-4 (controlled); 5 only by explicit approval | Resident runtime images and approved sandboxes | Runtime-required mounts only; no sensitive host mounts by default | Minimal required vars only; no personal passwords | no by default | no by default | Hermes/Open WebUI/runtime/sandbox operations | `--privileged`, sensitive host mounts, host PID/network for sensitive/public services, daemon reconfig, new public ports require explicit approval |

---

## Sudo Delegations Register

| Host | User | ADAL target | Current runtime | Sudoers File | Allowed Commands/Wrappers | NOPASSWD | Risk Level | Approved By | Notes |
|---|---|---|---|---|---|---|---|---|---|
| runtime-agent | agent | ADAL-2.5 / ADAL-2+ | Current runtime is ADAL-R3-level on runtime-agent while `/etc/sudoers.d/agent-runtime` grants `agent` `NOPASSWD:ALL` and `agent` remains in the docker group. maintainer-preferred policy target remains ADAL-2.5 / ADAL-2+; this broader runtime state is accepted for resident-host bootstrap/recovery and should be reviewed later for possible reduction to ADAL-2.5 allowlists/wrappers. | `/etc/sudoers.d/agent-runtime` and/or `/etc/sudoers.d/private runtime governance repository` | package installation, diagnostics, Docker/runtime operations, user-service management, Open WebUI/Hermes recovery; no owner lockout/capture operations | yes | medium-high; high if NOPASSWD:ALL | the owner | resident host only; not transferable to remote production systems; review later whether to reduce broad sudo to ADAL-2.5 allowlists/wrappers |

---

## Proposed Access Changes

| Date | Requested By | Target | Needed Action | Proposed Mechanism | ADAL/CDEL Change | Status | Approved By | Notes |
|---|---|---|---|---|---|---|---|---|
| YYYY-MM-DD | Oscar | TBD | TBD | TBD | TBD | proposed | pending the owner | TBD |

---

## Runtime onboarding references

- `docs/security/external-services-onboarding.md`
- `docs/security/skill-external-dependency-register.md`

## Change Log

| Date | Change | Author | Assisted-by |
|---|---|---|---|
| 2026-05-02 | Initial Phase 0 skeleton | F.M. the owner Vergnes | ChatGPT: GPT-5.5 Thinking |
| 2026-05-02 | Added ADAL-2.5/2+ target, runtime-agent resident-host runtime reality, ADAL-R3 risk clarification, and detailed sudo/container governance entries | F.M. the owner Vergnes | ChatGPT: GPT-5.5 Thinking [review], governed agent / Hermes-compatible runtime/Codex [implementation] |
| 2026-05-06 | Incident note: post-reboot Himalaya/Gmail failure traced to env/TOML/inline-command quoting boundary; fixed by wrapper-based `auth.cmd` pattern. Yellow skills not directly implicated (direct CLI reproduction). | F.M. the owner Vergnes | ChatGPT: GPT-5.5 Thinking [canmore] |
| 2026-05-06 | Follow-up: Himalaya v1.2.0 `message send` reproduces mail-parser panic; `template send` transmits via SMTP but fails IMAP sent-copy (`Folder doesn't exist`, tries literal `Sent`). Temporary send workaround documented via SMTP wrapper pending Himalaya upgrade/retest. | F.M. the owner Vergnes | ChatGPT: GPT-5.5 Thinking [canmore] |


# Runtime external services onboarding (runtime-agent)

Status: supporting onboarding snapshot, not canonical source of truth. Canonical service entries live in docs/security/external-access-register.md. Canonical skill entries live in config/skill-register.yaml and docs/skills/skill-register.md.


## Scope

Runtime-first onboarding snapshot for currently active runtime-agent external services and integration dependencies.

This document records classification, access path, allowed/forbidden actions, validation commands, and current runtime status.

No plaintext secrets are stored here.

## Runtime snapshot date

- UTC snapshot: 2026-05-06
- Runtime profile/work context: `default` / `agent-dev`

## Service register

| Service | Runtime purpose | Operational level | Secret/admin level | Access path(s) | Allowed actions | Forbidden actions | Validation command(s) | Runtime status |
|---|---|---|---|---|---|---|---|---|
| GitHub: NousResearch/hermes-agent upstream | Hermes core update source | ADAL-4 | ADAL-5 for account ownership/recovery | Hermes runtime git remote `origin` in `<runtime-register-root>` | `fetch`, `ls-remote`, guarded pull/update through maintenance wrapper | pushing to NousResearch upstream, history rewrite | `git -C <runtime-register-root> remote -v`; `git -C <runtime-register-root> ls-remote --heads origin main` | configured; reachability check implemented |
| GitHub: Oscar fork/account | Oscar proposal workspace | ADAL-4 | ADAL-5 for account ownership/recovery/billing | `origin` remote in private runtime governance repository; `gh` auth; SSH git | branch/commit/push to own fork, open/update PR | force push to protected/shared branches, secret push, upstream merge without approval | `git -C <private-workspace-path> remote -v`; `gh auth status` | configured and authenticated |
| GitHub: Eurobotics upstream repos | source-of-truth and PR target | ADAL-4 for fetch/compare/PR; ADAL-5 for direct push/merge to main | ADAL-5 for org admin/recovery | `upstream` remote in private runtime governance repository | fetch, compare, PR open/update | direct main push, merge, force-push/history rewrite without approval | `git -C <private-workspace-path> ls-remote --heads upstream main` | configured (push disabled in remote config) |
| Gmail via Himalaya IMAP | mailbox read/list for operations | ADAL-4 | ADAL-5 for account recovery/app-password lifecycle | `himalaya` CLI using wrapper auth cmd | folder list, envelope list, read approved mail | print app password, rotate credentials without approval | `scripts/validate-himalaya-gmail-wrapper.sh` | validated working |
| Gmail via SMTP fallback wrapper | controlled report send fallback | ADAL-4 | ADAL-5 for credential/recovery control | `<private-workspace-path>` + wrapper password retrieval | send approved operational messages | native Himalaya send path until retested; blind retries after template send false-negative | `scripts/validate-himalaya-send-workaround.sh` | validated working |
| Telegram gateway | operational command/report interface | ADAL-4 | ADAL-5 for bot token/recovery/admin rights | Hermes gateway + TELEGRAM_* env vars | approved admin/channel messaging | token disclosure; unapproved external disclosure | `systemctl --user is-active hermes-gateway.service`; env-name presence check | active |
| OpenRouter | model provider/inference | ADAL-4 | ADAL-5 for account/billing/key admin | OPENROUTER_API_KEY env var | inference/runtime task execution | key disclosure; unauthorized spend expansion | `hermes config check` + env-name presence check | present |
| OpenAI/Codex auth (if configured) | coding/provider capability | ADAL-4 | ADAL-5 for account/recovery/billing | `<runtime-register-root>` and/or provider env | authorized model operations | token disclosure | auth metadata presence check only | auth file present |
| Browserbase | browser automation backend | ADAL-4 | ADAL-5 for key/project admin | BROWSERBASE_API_KEY + BROWSERBASE_PROJECT_ID | approved browser automation | key disclosure; uncontrolled external interactions | `hermes config check` + env-name presence check | present |
| Browser Use API | browser automation backend | ADAL-4 | ADAL-5 for key admin | BROWSER_USE_API_KEY | approved browser automation | key disclosure | `hermes config check` + env-name presence check | present |
| ZeroTier | private network access path | ADAL-4 | ADAL-5 for network/account admin | host service `zerotier-one.service` | runtime connectivity for private path | network secret disclosure; unauthorized topology/admin changes | `systemctl status zerotier-one --no-pager` | active |
| OpenWebUI (private frontend path) | local control interface exposed over private network | ADAL-4 | ADAL-5 for admin/auth reset/recovery | `open-webui.service`; bound private address | approved local/private frontend access | unapproved public exposure or auth weakening | `systemctl --user is-active open-webui.service`; `ss -ltnp | grep :3000` | active, bound on private IP |
| Hermes API server endpoint | local API gateway control path | ADAL-4 | ADAL-5 for API key custody | API_SERVER_* env vars | approved local API operations | API key disclosure | env-name presence check; runtime service checks | enabled in env |

## Critical runtime guard rules

- Never hardcode unauthenticated private HTTPS GitHub URLs in runtime guards.
- Non-interactive maintenance scripts must never prompt for GitHub username/password.
- Hermes core auto-update reachability gate must check Hermes upstream/origin only.
- private runtime governance repository fork/upstream reachability is non-blocking for Hermes auto-update and only blocking in explicit git-maintenance/PR workflows.

## Runtime truth notes

- Himalaya read path works through wrapper-based auth command.
- Himalaya native send path is currently unsafe on this host/runtime version.
- SMTP fallback wrapper is validated and should be used for approved sends.
- OpenWebUI is active and listening on private ZeroTier address (`<redacted-ip>:3000` at snapshot time).

## Approval model

- Human owner approval required for ADAL-5 activities, recovery-path changes, credential rotation, and broad scope changes.
- Classification onboarding is governance metadata; it does not grant additional authority by itself.






# Runtime external-service onboarding quick reference

Use when runtime failures suggest an external integration exists but is not governance-classified.

## Trigger signals
- Guard checks fail due wrong access path assumptions (example: unauthenticated private HTTPS git checks).
- Service works manually but fails in automation due missing classified path (example: wrapper-based Gmail auth/send path).
- Runtime maintenance depends on external providers/skills without explicit authority boundaries.

## Default external-service authority chain

For all external services/servers/packages/accounts/integrations, first check `agent-external-systems-management` unless the task explicitly provides another reviewed source or explicitly states no pre-registration exists.

1) `agent-external-systems-management`
- human-managed preparation source and pre-registration package
- not a runtime register

2) Yellow-control / Yellow skills
- read and reconcile the pre-registration package with the owner's instruction
- classify ADAL/CDEL/ESAL/PCL and apply guardrails
- if pre-registration conflicts with the owner's instruction, stop and report mismatch

3) Active Yellow runtime registers
- write runtime-approved entries to `<runtime-register-root>`
- especially `<runtime-register-root>`

4) runtime-backup
- take runtime backup before and after runtime register changes

5) PR flow back to external-systems repo
- Oscar must not invent missing metadata
- Oscar must not directly modify Eurobotics upstream `agent-external-systems-management`
- corrections must be proposed by PR through operator-owned fork/branch for the owner review

external-target-a is one example only. This authority chain also applies to GitHub, Gmail/Himalaya, Telegram, OpenRouter, Browserbase, ZeroTier, OpenWebUI, local API server, Cloudron hosts, and future external servers.

## Runtime-first onboarding sequence
1) Inventory runtime facts without leaking secrets:
- enumerate env var names only
- check Hermes config/skills visibility
- inspect systemd service/timer status
- inspect git remotes from active repos
- confirm wrapper/script presence and executable bits

2) Classify each service with operational vs admin/recovery split:
- operational usage: ADAL-4/ESAL-4 class where service can execute external actions or incur spend
- account recovery/billing/security ownership: ADAL-5/ESAL-5 class

3) GitHub role separation (mandatory):
- Hermes upstream source for core update checks
- Oscar fork for branch/commit/push/PR
- authoritative upstream for compare + PR target
- do not use hardcoded unauthenticated private HTTPS checks in guards

4) Email/Gmail/Himalaya split:
- read/list path can be operationally approved
- send path must use validated approved route
- do not print app-password/token values; metadata-only checks

5) Maintenance alignment check:
- Hermes core update guards must block only on Hermes upstream reachability
- project fork/upstream checks should be non-blocking unless explicit git-maintenance mode is active

## Validation minimums
- `git diff --check`
- `bash -n` on changed scripts
- maintenance dry-run with no real update
- secret hygiene check (no values in docs/logs)

## Common pitfall
Treating tool implementation details (wrappers, auth command paths) as non-governance concerns causes brittle automation. If a path is required for runtime reliability, onboard it as a governed external access path.

# External-service authority chain doctrine patch validation

Use this when patching Yellow runtime governance text for external-service authority chain rules.

## Required checks

1) Backup before patch
- `/usr/local/bin/runtime-backup-tool --event pre-risky-change --reason "pre <change>"`

2) Text presence validation
- grep for section title:
 - `grep -R -n "Default external-service authority chain" <runtime-register-root> <runtime-register-root> <runtime-register-root>`
- grep for doctrine source reference:
 - `grep -R -n "agent-external-systems-management" <runtime-register-root> <runtime-register-root> <runtime-register-root>`

3) Skill visibility check
- `hermes skills list | grep -Ei 'yellow-control|yellow-skill|yellow-project'`

4) No-secret scan on changed docs
- scan changed markdown for common token/password/private-key patterns before commit/push

5) Post-change validation backup dry-run
- `/usr/local/bin/runtime-backup-tool --dry-run --event post-risky-change --reason "validate <change>"`

6) Final backup after successful validation
- `/usr/local/bin/runtime-backup-tool --event post-risky-change --reason "post <change>"`

## Staging preservation rule

If runtime Yellow skill docs changed, preserve exact changed files under `<private-workspace-path>` only when corresponding staging files already exist. If a corresponding staging path does not exist, report the gap explicitly instead of inventing new staging structure silently.

## Boundaries

- Do not connect to external servers for this patch class.
- Do not update Hermes during doctrine-only patches.
- Do not modify SOUL.md.
- Do not merge PRs in this workflow.

## GitHub/repository gate


# GitHub safety

## Branch protection assumptions

Protected mainline branches require pull requests, reviews, and status checks before merge.

## Execution model

Oscar works in its own fork or non-protected branch, never by direct mainline modification.

## Submission behavior

When work appears ready, Oscar requests submission/review rather than self-merging protected targets.

## Runtime guard dependency model

- Runtime guards must use configured git remotes and authenticated transport where required.
- Do not hardcode unauthenticated private HTTPS reachability checks for private GitHub repositories.
- Hermes core maintenance dependency is Hermes upstream/origin reachability only.
- private runtime governance repository fork/upstream reachability is maintenance-context dependent and non-blocking for Hermes core auto-update.

## Autonomous maintenance guardrails

- GitHub operational use for Oscar runtime workflows is ADAL-4.
- Oscar may commit and push to branches in its own fork.
- Oscar may prepare/open/update PRs to Eurobotics upstream.
- Oscar must not merge into Eurobotics upstream/main without the owner approval.
- Oscar must not push directly to Eurobotics main.
- Oscar must not auto-merge PRs.
- Oscar must not force-push shared/protected branches.
- Oscar must not rewrite upstream history.
- Oscar must not push secrets.
- Secret-scan failure is a hard stop: abort and do not push.

## Documentation integrity

Documentation must remain aligned with implementation changes in the same PR whenever behavior or controls change.



# Runtime governance sync boundaries

## Governed runtime governance model

Runtime governance is composed of multiple aligned layers:

- `SOUL.md`: identity, operating behavior, and high-level routing.
- `AGENTS.md`: operational governance context and execution guardrails.
- project/profile/skill registers and docs: detailed governance reference set (not runtime-state authority).
- runtime skills: Hermes entry points under `<runtime-register-root>`.
- mutable runtime evidence/backups/audits: `<runtime-state-root>/`.

## Deployable scopes and targets

The controlled deployment path supports these scopes:

- `runtime-governance`:
 - `profiles/global/SOUL.md` -> `$HERMES_HOME/SOUL.md`
 - `AGENTS.md` -> `$HERMES_HOME/AGENTS.md`
 - `README.md` -> `$HERMES_HOME/README.md`
 - `config/*.yaml` -> `$HERMES_HOME/private runtime governance repository/config/`
 - `docs/security/*.md` -> `$HERMES_HOME/private runtime governance repository/docs/security/`
 - `docs/skills/*.md` -> `$HERMES_HOME/private runtime governance repository/docs/skills/`
- `skills`:
 - `skills/yellow-control-governance/SKILL.md` -> `$HERMES_HOME/skills/yellow-control-governance/SKILL.md`
 - `skills/yellow-project-management/SKILL.md` -> `$HERMES_HOME/skills/yellow-project-management/SKILL.md`
 - `skills/yellow-skill-registry/SKILL.md` -> `$HERMES_HOME/skills/yellow-skill-registry/SKILL.md`
- `all`: includes `runtime-governance` and `skills`
- Legacy compatibility scopes remain available: `soul`, `policy`, `prompts`

## Deployment modes

- `--dry-run`: simulation only.
- `--prepare-merge` (default): normal/safe mode for mature/non-newborn runtimes; copies missing files and stages sensitive diffs with backup paths.
- `--apply-staged`: exceptional mode (not routine); use only after semantic review + explicit approval from the Governance Authority or explicitly delegated Authorized Operator.

Dry-run reports should explicitly state:

- whether dry-run is clean;
- whether `--prepare-merge` is the recommended next step;
- exact next command(s);
- warning that `--prepare-merge` performs real runtime writes (backups, staging files, missing-file copies);
- warning that `--apply-staged` remains forbidden unless reviewed and approved.

For mature runtimes, do not use `--apply-staged` as bulk apply for sensitive files. Prefer targeted manual apply of reviewed merged proposals, especially for `SOUL.md`, `AGENTS.md`, and runtime `SKILL.md` files.

## Runtime evidence location

Mutable evidence is not deployed from git and should be kept under XDG state paths:

- Canonical path: `<runtime-state-root>/remote-audits/<target-id>/<timestamp>/`
- Recommended files: `audit.tar.zst`, `audit.sha256`, `manifest.json`, `summary.md`, `findings.md`, `normalized-context.md`
- `normalized-context.md` is the preferred compact context handoff for future work on the same target.
- Raw tarballs/logs/secrets remain runtime-only and must not be committed.
- Default retention is 3 months; incident/security evidence may be retained longer with the owner approval.
- Future audits should compare against the prior baseline and report meaningful drift.
- Monthly recurring audits are persistent automation and require explicit approval before cron/systemd creation.
- Legacy-looking paths under `<runtime-register-root>` are not the preferred current path.

## Not governed for deployment

The following runtime content is explicitly excluded from governed deployment and git sync:

- secrets and credentials
- `auth.json`
- `.env`
- sessions
- logs
- caches

## Drift checking vs deployment

- Deployment (`scripts/deploy.sh`) is an explicit write path from repo to runtime.
- Drift checking (`scripts/check-runtime-drift.sh`) is a read-only comparison path.

These are intentionally separate controls: detect first, then deploy (or rollback) with operator judgment.

## Why runtime is not auto-committed to git

Automatic runtime-to-git sync risks exfiltrating secrets, committing volatile artifacts, and creating noisy non-governed history. Governance remains rooted in reviewed repository changes.


# Yellow skill development workflow


## Purpose and scope

This workflow governs **Yellow skill development only** (`yellow-control-governance`, `yellow-project-management`, `yellow-skill-registry`).

It is a repository and runtime-governance workflow. It is **not** an external server operations workflow.

## Source-of-truth rule

- Repository `skills/*/SKILL.md` files are the source of truth.
- Runtime skill edits are not source of truth.
- If runtime testing reveals needed changes, patch repo first, then redeploy through reviewed flow.

## Development lifecycle

1. Patch repo skill file(s) in `skills/*/SKILL.md`.
2. Validate YAML front matter and metadata (`Author`, `Assisted-by`, routing references).
3. Commit to fork, open PR, merge upstream, and sync local/fork/upstream.
4. Run runtime deployment dry-run:
 - `./scripts/deploy.sh skills --dry-run`
5. Run prepare-merge (normal mode for mature runtimes):
 - `./scripts/deploy.sh skills --prepare-merge`
6. If runtime skill exists and differs, generate a clean semantic merge proposal under staging.
7. Apply only reviewed target skill files (targeted manual apply), not generic bulk apply:
 - `./scripts/apply-reviewed-skill.sh --skill <skill> --proposal <.../SKILL.md.merged.proposal.md>`
8. Reset/reload Hermes session context (`/reset`) if needed so runtime uses updated guidance.
9. Run behavior tests using `docs/skills/yellow-skill-test-protocol.md`.
10. Feed findings back into repo source files; avoid runtime-only drift.

## Mature runtime safety

- `--prepare-merge` is the normal/safe mode.
- Generic `--apply-staged` is exceptional and requires explicit approval from the Governance Authority or explicitly delegated Authorized Operator.
- For dry-runs, always report whether output is clean and whether `--prepare-merge` is the recommended next step.
- `--prepare-merge` performs real runtime writes (pre-apply backups, staging files, missing-file copies).
- Prefer targeted manual apply for `SKILL.md` files after semantic review.
- Use `scripts/apply-reviewed-skill.sh` for single-skill reviewed apply with backup/hash/permission verification.

## Skill drift handling

- Compare repo path and runtime path before apply.
- Preserve useful runtime content only when still valid and coherent with current governance.
- Do not let runtime become untracked governance truth.

## Evidence and logging

- Include backup paths and SHA256 hashes in deployment reports.
- Record staged merge directory and proposal paths.
- Do not commit runtime backups, raw runtime staging artifacts, or local runtime evidence to Git.

## Related references

- `docs/skills/yellow-skills.md`
- `docs/skills/yellow-skill-test-protocol.md`
- `docs/security/governance-levels-reference.md`
- `docs/deployment-workflow.md`
- `docs/runtime-governance-sync.md`

## Automation/persistence gate

Persistent automation creation/modification requires explicit approval and governance telemetry.

## Proposal-only gate

Proposal-only scope blocks execution actions.

## Allow/defer/block tables

Allow: all required gates pass.

Defer: evidence/approval missing.

Block: forbidden or high-risk boundary breach.

## Worked examples

Include runtime maintenance, external onboarding, publication, and repo merge scenarios.
