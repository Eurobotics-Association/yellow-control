# External service governance

Public-safe governance extraction with fictional examples.

## Public-safe external service register schema

# External Access Register

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking [policy design], Oscar/Hermes and/or Codex [implementation]

Status: Phase 0
Scope: Oscar/Hermes external access metadata only

---

## Purpose

This register records Oscar/Hermes access metadata for systems, services, containers, sudo delegations, and proposed access changes.

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
| runtime-agent | runtime-agent | Resident Host | Hetzner VM | Production control-plane / agent runtime | ADAL-2.5 / ADAL-2+ | Current runtime is ADAL-R3-level on runtime-agent while `/etc/sudoers.d/oscar-agent` grants `oscar` `NOPASSWD:ALL` and `oscar` remains in the docker group. Robert’s preferred policy target remains ADAL-2.5 / ADAL-2+; this broader runtime state is accepted for resident-host bootstrap/recovery and should be reviewed later for possible reduction to ADAL-2.5 allowlists/wrappers. Active Open WebUI deployment is `open-webui.service` (oscar user systemd service) using Python venv; Docker/Compose are installed and available but not active for Open WebUI. | Controlled resident Docker/container operations allowed for Hermes/runtime/sandbox management; high-risk CDEL-5 patterns require explicit approval or ADAL-R3 | oscar | local user / SSH key | external vault reference only | Non-interactive sudo for documented operations: package install, diagnostics, Docker/runtime ops, user-service management, recovery; preserve no-lockout/no-capture boundary | Robert retains rfv/admin access, SSH break-glass, Hetzner console, snapshots/backups, rescue/rebuild | Hermes runtime, Open WebUI, Docker/container stack, package installation required for Oscar operations, control-plane maintenance, resident-host runtime recovery | Robert | 90d (current) / TBD |

---

## External Services Register

| Service | Purpose | Runtime access path | ADAL (operational) | ESAL/Secret level | Allowed actions | Forbidden actions | Runtime validation | Hermes weekly maintenance impact | Owner / approval authority | Recovery custody reference |
|---|---|---|---|---|---|---|---|---|---|---|
| GitHub / NousResearch Hermes upstream | Hermes core update source | `git -C <runtime-register-root> remote origin` | ADAL-4 | ESAL-4 operational; ESAL-5 account/recovery/admin | fetch, ls-remote, guarded update checks | push to NousResearch upstream, secret push, history rewrite | `git -C <runtime-register-root> ls-remote --heads origin main` | Blocking for Hermes update path | Robert approval for ESAL-5 actions | owner-controlled vault metadata reference (required; no secrets in Git) |
| GitHub / Oscar fork | Autonomous proposal workspace | `origin` remote in `<private-workspace-path>`; `gh auth`/SSH | ADAL-4 | ESAL-4 operational; ESAL-5 account/recovery/admin | branch, commit, push to own fork, open/update PRs | merge upstream PRs, direct protected main pushes, force-push shared/protected branches, secret push | `git -C <private-workspace-path> remote -v`; `gh auth status` | Non-blocking for Hermes update; blocking only in git-maintenance/PR workflows | Robert | owner-controlled vault metadata reference (required) |
| GitHub / Eurobotics upstream | Protected upstream repository and PR target | `upstream` remote in `<private-workspace-path>` | ADAL-4 for PR/open/update; ADAL-5 for direct push/merge/admin | ESAL-4 operational; ESAL-5 org/admin/recovery | fetch, compare, open/update PR | direct main push, merge, force-push/history rewrite without approval | `git -C <private-workspace-path> ls-remote --heads upstream main` | Non-blocking for Hermes update; blocking only in git-maintenance/PR workflows | Robert | owner-controlled vault metadata reference (required) |
| Gmail / Himalaya | Operational mailbox read/send integration | `himalaya` + `<private-workspace-path>` + SMTP fallback wrapper | ADAL-4 read/send | ESAL-4 operational; ESAL-5 credentials/recovery/admin | list folders, list envelopes, read approved mail, send approved operational mail via approved fallback | print app password, native Himalaya send path until retested, blind retries after false-negative, credential rotation without approval | `scripts/validate-himalaya-gmail-wrapper.sh`; `scripts/validate-himalaya-send-workaround.sh` | Non-blocking for Hermes update | Robert | owner-controlled vault metadata reference (required) |
| Telegram gateway | Operational command/report channel | Hermes gateway + `TELEGRAM_*` env | ADAL-4 | ESAL-4 operational; ESAL-5 token/admin/recovery | approved admin/channel messaging | token disclosure, unapproved external disclosure | `systemctl --user is-active hermes-gateway.service` + env-name presence check | Non-blocking for Hermes update | Robert | owner-controlled vault metadata reference (required) |
| OpenRouter | Primary model provider/inference path | `OPENROUTER_API_KEY` + Hermes provider config | ADAL-4 | ESAL-4 operational; ESAL-5 billing/key/admin | approved inference/runtime task execution | key disclosure, unapproved spend/admin changes | `<private-workspace-path> config check` + env-name presence check | Non-blocking for Hermes update | Robert | owner-controlled vault metadata reference (required) |
| OpenAI / Codex auth | Provider capability for coding/model tasks when configured | `<runtime-register-root>` and/or provider env variables | ADAL-4 | ESAL-4 operational; ESAL-5 billing/account/recovery | approved model operations | token disclosure, unapproved billing/admin changes | auth metadata presence check (no token output) | Non-blocking for Hermes update | Robert | owner-controlled vault metadata reference (required) |
| Browserbase | Browser automation backend | `BROWSERBASE_API_KEY`, `BROWSERBASE_PROJECT_ID` | ADAL-4 | ESAL-4 operational; ESAL-5 key/project admin | approved browser automation runs | key disclosure, uncontrolled external interactions | `hermes config check` + env-name presence check | Non-blocking for Hermes update | Robert | owner-controlled vault metadata reference (required) |
| Browser Use API | Browser automation backend | `BROWSER_USE_API_KEY` | ADAL-4 | ESAL-4 operational; ESAL-5 key/admin | approved browser automation runs | key disclosure, uncontrolled external interactions | `hermes config check` + env-name presence check | Non-blocking for Hermes update | Robert | owner-controlled vault metadata reference (required) |
| ZeroTier | Private network path for runtime services | `zerotier-one.service` | ADAL-4 runtime connectivity | ESAL-4 operational; ESAL-5 network/account admin | private connectivity required for approved runtime paths | network secret disclosure, unauthorized topology/admin changes | `systemctl status zerotier-one --no-pager` | Non-blocking for Hermes update | Robert | owner-controlled vault metadata reference (required) |
| OpenWebUI private control path | Local agent control interface over private network | `open-webui.service` and private bind address | ADAL-4 | ESAL-4 operational; ESAL-5 admin/reset/recovery | approved private frontend access | unapproved public exposure, auth weakening | `systemctl --user is-active open-webui.service`; `ss -ltnp | grep :3000` | Non-blocking for Hermes update | Robert | owner-controlled vault metadata reference (required) |
| Local API server | Local runtime control API path | `API_SERVER_ENABLED`, `API_SERVER_HOST`, `API_SERVER_PORT`, `API_SERVER_KEY` | ADAL-4 | ESAL-4 operational; API key is ADAL-5 secret custody | approved local API operations | API key disclosure, unauthorized remote exposure | env-name presence check + runtime service checks | Non-blocking for Hermes update | Robert | owner-controlled vault metadata reference (required) |
| Google Workspace (conditional) | Optional Google APIs via enabled skill | `google-workspace` skill + Google provider credentials if configured | ADAL-4 if enabled for operations | ESAL-4 operational; ESAL-5 account/admin/recovery | approved Gmail/Calendar/Drive/Docs operations when enabled | key/token disclosure, unauthorized admin/account changes | `hermes skills inspect google-workspace` + credential metadata presence check | Non-blocking for Hermes update | Robert; explicit human review before activation | pending human-review custody reference |

No ESAL-4/5 external service is fully production-ready until owner recovery custody metadata references are documented and approved.

### External target: external-target-a

- Service/target: external-target-a
- Type: external server / Hetzner VPS / Cloudron host
- Hostname: external-target-01-hel1
- IP: <redacted-ip>
- SSH port: 22
- SSH username: oscar
- SSH key path reference: <private-workspace-path>
- Source package: Eurobotics-Association/oscar-external-systems-management/servers/external-target-a
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
- Owner/approval: Robert
- Recovery/break-glass: Robert-controlled Hetzner/Cloudron/admin recovery; metadata only
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

1. Email to Robert/admin address if email is available.
2. Telegram home/admin channel if email is unavailable.
3. Local Markdown report in control-plane/runtime report directory if neither external channel is available.

Reports should include counts/scopes of repository operations, communications, attachments/transfers, failed or blocked actions, permission-change requests, and confidentiality-relevant events.

Reports must not include passwords, API keys, tokens, private keys, OAuth secrets, session cookies, recovery codes, or unnecessary sensitive personal data.

---

## Project Confidentiality Register

| Project / Repo | Location | Visibility | PCL | Allowed Disclosure | External Communication Allowed | Approval Required For | Notes |
|---|---|---|---:|---|---|---|---|
| private-control-repo | private operational control-plane repository | Private | PCL-3 | Internal/admin-only summaries; no external disclosure of confidential implementation/governance details | No external disclosure by default | Any external disclosure, publication, or third-party discussion | Contains governance and identity/control-plane material |
| runtime-agent resident host runtime/infrastructure | runtime-agent Hetzner VM and linked operational components | Private | PCL-3 | Need-to-know operational/admin context only | No external disclosure by default | Any external disclosure, architecture sharing, or incident details outside approved channels | Includes sudo, recovery, break-glass, and runtime governance context |
| Hermes-Yellow-Control (future community candidate) | Future extracted/sanitized project (not current repo baseline) | TBD (candidate public/community) | PCL-2 until explicitly reclassified | No external disclosure as public/community project until sanitized extraction and Robert approval | Not allowed until approval/reclassification | Public release, repo visibility change, or external promotion | May become PCL-0 only after sanitized extraction and explicit Robert approval |
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
| runtime-agent | oscar | ADAL-2.5 / ADAL-2+ | Current runtime is ADAL-R3-level on runtime-agent while `/etc/sudoers.d/oscar-agent` grants `oscar` `NOPASSWD:ALL` and `oscar` remains in the docker group. Robert’s preferred policy target remains ADAL-2.5 / ADAL-2+; this broader runtime state is accepted for resident-host bootstrap/recovery and should be reviewed later for possible reduction to ADAL-2.5 allowlists/wrappers. | `/etc/sudoers.d/oscar-agent` and/or `/etc/sudoers.d/private-control-repo` | package installation, diagnostics, Docker/runtime operations, user-service management, Open WebUI/Hermes recovery; no owner lockout/capture operations | yes | medium-high; high if NOPASSWD:ALL | Robert | resident host only; not transferable to remote production systems; review later whether to reduce broad sudo to ADAL-2.5 allowlists/wrappers |

---

## Proposed Access Changes

| Date | Requested By | Target | Needed Action | Proposed Mechanism | ADAL/CDEL Change | Status | Approved By | Notes |
|---|---|---|---|---|---|---|---|---|
| YYYY-MM-DD | Oscar | TBD | TBD | TBD | TBD | proposed | pending Robert | TBD |

---

## Runtime onboarding references

- `docs/security/external-services-onboarding.md`
- `docs/security/skill-external-dependency-register.md`

## Change Log

| Date | Change | Author | Assisted-by |
|---|---|---|---|
| 2026-05-02 | Initial Phase 0 skeleton | F.M. Robert Vergnes | ChatGPT: GPT-5.5 Thinking |
| 2026-05-02 | Added ADAL-2.5/2+ target, runtime-agent resident-host runtime reality, ADAL-R3 risk clarification, and detailed sudo/container governance entries | F.M. Robert Vergnes | ChatGPT: GPT-5.5 Thinking [review], Oscar/Hermes/Codex [implementation] |
| 2026-05-06 | Incident note: post-reboot Himalaya/Gmail failure traced to env/TOML/inline-command quoting boundary; fixed by wrapper-based `auth.cmd` pattern. Yellow skills not directly implicated (direct CLI reproduction). | F.M. Robert Vergnes | ChatGPT: GPT-5.5 Thinking [canmore] |
| 2026-05-06 | Follow-up: Himalaya v1.2.0 `message send` reproduces mail-parser panic; `template send` transmits via SMTP but fails IMAP sent-copy (`Folder doesn't exist`, tries literal `Sent`). Temporary send workaround documented via SMTP wrapper pending Himalaya upgrade/retest. | F.M. Robert Vergnes | ChatGPT: GPT-5.5 Thinking [canmore] |


# Runtime external services onboarding (runtime-agent)

Status: supporting onboarding snapshot, not canonical source of truth. Canonical service entries live in docs/security/external-access-register.md. Canonical skill entries live in config/skill-register.yaml and docs/skills/skill-register.md.

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking [architecture + governance], Oscar/Hermes and/or Codex [execution]

## Scope

Runtime-first onboarding snapshot for currently active runtime-agent external services and integration dependencies.

This document records classification, access path, allowed/forbidden actions, validation commands, and current runtime status.

No plaintext secrets are stored here.

## Runtime snapshot date

- UTC snapshot: 2026-05-06
- Runtime profile/work context: `default` / `oscar-dev`

## Service register

| Service | Runtime purpose | Operational level | Secret/admin level | Access path(s) | Allowed actions | Forbidden actions | Validation command(s) | Runtime status |
|---|---|---|---|---|---|---|---|---|
| GitHub: NousResearch/hermes-agent upstream | Hermes core update source | ADAL-4 | ADAL-5 for account ownership/recovery | Hermes runtime git remote `origin` in `<runtime-register-root>` | `fetch`, `ls-remote`, guarded pull/update through maintenance wrapper | pushing to NousResearch upstream, history rewrite | `git -C <runtime-register-root> remote -v`; `git -C <runtime-register-root> ls-remote --heads origin main` | configured; reachability check implemented |
| GitHub: Oscar fork/account | Oscar proposal workspace | ADAL-4 | ADAL-5 for account ownership/recovery/billing | `origin` remote in private-control-repo; `gh` auth; SSH git | branch/commit/push to own fork, open/update PR | force push to protected/shared branches, secret push, upstream merge without approval | `git -C <private-workspace-path> remote -v`; `gh auth status` | configured and authenticated |
| GitHub: Eurobotics upstream repos | source-of-truth and PR target | ADAL-4 for fetch/compare/PR; ADAL-5 for direct push/merge to main | ADAL-5 for org admin/recovery | `upstream` remote in private-control-repo | fetch, compare, PR open/update | direct main push, merge, force-push/history rewrite without approval | `git -C <private-workspace-path> ls-remote --heads upstream main` | configured (push disabled in remote config) |
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
- private-control-repo fork/upstream reachability is non-blocking for Hermes auto-update and only blocking in explicit git-maintenance/PR workflows.

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

For all external services/servers/packages/accounts/integrations, first check `oscar-external-systems-management` unless the task explicitly provides another reviewed source or explicitly states no pre-registration exists.

1) `oscar-external-systems-management`
- human-managed preparation source and pre-registration package
- not a runtime register

2) Yellow-control / Yellow skills
- read and reconcile the pre-registration package with Robert's instruction
- classify ADAL/CDEL/ESAL/PCL and apply guardrails
- if pre-registration conflicts with Robert's instruction, stop and report mismatch

3) Active Yellow runtime registers
- write runtime-approved entries to `<runtime-register-root>`
- especially `<runtime-register-root>`

4) oscar-backup
- take runtime backup before and after runtime register changes

5) PR flow back to external-systems repo
- Oscar must not invent missing metadata
- Oscar must not directly modify Eurobotics upstream `oscar-external-systems-management`
- corrections must be proposed by PR through operator-owned fork/branch for Robert review

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
  - `grep -R -n "oscar-external-systems-management" <runtime-register-root> <runtime-register-root> <runtime-register-root>`

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

## Onboarding checklist

Confirm service identity; validate authority chain; classify ADAL/CDEL/ESAL/PCL; capture first-connect evidence; verify completion and backup coverage.

## Ownership and recovery custody model

Human administrators retain recovery authority; agent must not become sole recovery authority.

## Access-chain validation

Validate authentication method, repository/service reachability, policy constraints, and least-privilege scope.

## Examples

GitHub: fictional org/repo with scoped maintainer path.

Email: fictional mailbox automation with constrained send scope.

Cloud/API: fictional staging API key lifecycle.
