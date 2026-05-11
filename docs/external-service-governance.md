     1|# External service governance
     2|
     3|Public-safe governance extraction with fictional examples.
     4|
     5|## Public-safe external service register schema
     6|
     7|# External Access Register
     8|
     9|
    10|Status: Phase 0
    11|Scope: governed agent / Hermes-compatible runtime external access metadata only
    12|
    13|---
    14|
    15|## Purpose
    16|
    17|This register records governed agent / Hermes-compatible runtime access metadata for systems, services, containers, sudo delegations, and proposed access changes.
    18|
    19|It stores access metadata only and must contain no plaintext secrets.
    20|
    21|## External access self-registration rule (Phase 2)
    22|
    23|- Oscar must consult this register before using external services, remote hosts, SSH, sudo, dashboards, APIs, containers, or persistent integrations.
    24|- If required target metadata is missing or incomplete, Oscar must propose a register update before operational use.
    25|- Oscar may infer safe metadata, but uncertain fields must be marked `unknown`.
    26|- Proposal does not equal permission.
    27|- Governance role mapping should be explicit: Governance Authority, Authorized Operator, Runtime Owner, Project Owner, and Executor Agent.
    28|- Oscar must not self-grant, expand, or operationalize privileged authority.
    29|- Unknown authority defaults to no operational authority.
    30|
    31|External hosts/servers are governed through this register; no separate server register is required in Phase 2.
    32|
    33|## External target model and relationship to projects
    34|
    35|- **External target** means a server, VM, VPS, service, API, dashboard, account, container host, or managed runtime.
    36|- External targets are governed by the **External Access Register**.
    37|- Projects/workstreams are governed by the **Project Register** and may reference one or more external targets.
    38|- The external-target/project relationship is **many-to-many**.
    39|- Unknown target-to-project relationship must be proposed, not invented.
    40|- External targets keep their own access authority, wrapper context, audit evidence, and normalized context.
    41|
    42|## External Package linkage (Phase 2)
    43|
    44|External Access Register is the live governance register for external access knowledge.
    45|
    46|- Entries may reference an **External Package** when one exists.
    47|- If an External Package is referenced for a target, Oscar must consult it before privileged or remote operational work.
    48|- If an External Package is missing, incomplete, or inaccessible, Oscar must report the governance gap and must not assume authority.
    49|- For private GitHub package repositories, HTTPS Git failure alone is not definitive; Oscar must check configured authenticated methods (`gh auth status`, `gh repo view OWNER/REPO`, `git ls-remote https://github.com/OWNER/REPO.git HEAD`) before declaring inaccessible.
    50|- If authenticated access later succeeds during a requested dry-run simulation, Oscar should continue the original simulation request automatically.
    51|- External Packages are context/implementation boundaries, not permission by themselves.
    52|- Wrapper existence does not equal permission.
    53|- Capability does not equal authority.
    54|- Proposal does not equal permission.
    55|- Oscar may read External Packages as context and may propose changes.
    56|- Oscar must not be the primary maintainer of constraints that govern operator-owned own authority.
    57|- Human/admin ownership remains required for privileged package deployment.
    58|
    59|### Optional schema extension: external_package
    60|
    61|```yaml
    62|external_package:
    63| available: true|false|unknown
    64| repo: <repo identifier or URL>
    65| path: <package path inside repo>
    66| access_for_oscar: read-only|propose-only|none|unknown
    67| manifest_path: <path to manifest.yaml>
    68| install_authority: human-admin-only|unknown
    69| last_reviewed_utc: <timestamp|null>
    70| notes: []
    71|```
    72|
    73|### Generic External Package manifest concept
    74|
    75|```yaml
    76|target_id: <canonical external target id>
    77|package_version: 1
    78|authority_model:
    79| standing_authority: ADAL-2.5
    80| temporary_elevation: ADAL-3T
    81| install_authority: human-admin-only
    82|wrappers:
    83| - name: <wrapper name>
    84| runtime_path: /usr/local/sbin/<wrapper>
    85| category: diagnostics|audit|container-diagnostics|safe-read|maintenance
    86| mode: read-only|state-changing
    87| requires_sudo: true|false
    88| allowed_under: ADAL-2.5|ADAL-3T|ADAL-4
    89| state_changing: true|false
    90| approval_required: true|false
    91|forbidden_without_elevation: []
    92|evidence:
    93| audit_retention_days: 90
    94| raw_artifacts_git_policy: never_commit
    95|```
    96|
    97|---
    98|
    99|## Absolute No-Secrets Rule
   100|
   101|Do not store plaintext passwords, private keys, API keys, OAuth tokens, session cookies, recovery codes, TOTP seeds, sudo passwords, or vault unlock credentials in this file.
   102|
   103|Use secret-location references only.
   104|
   105|---
   106|
   107|## Acronym normalization
   108|
   109|Canonical quick reference for ADAL/CDEL/ESAL/PCL definitions and level tables:
   110|- `docs/security/governance-levels-reference.md`
   111|
   112|- **ADAL** = Agent Delegated Administration Level
   113|- **CDEL** = Container Delegated Execution Level
   114|- **ESAL** = External Service Access Level
   115|- **PCL** = Project Confidentiality Level
   116|- **PAM/IAM** = privileged access and identity/access management governance
   117|- Do not use incorrect or legacy acronym variants in governance documentation.
   118|
   119|---
   120|
   121|## ADAL Summary
   122|
   123|| Level | Name | Meaning | Default Policy |
   124||---:|---|---|---|
   125|| 0 | No Access | No account, key, token, or approved operational access | Allowed |
   126|| 1 | User Access Only | Dedicated user, no sudo | Preferred default for remote hosts |
   127|| 2 | Constrained Delegated Administration | Limited NOPASSWD sudo/wrappers, no lockout/capture capability | Preferred maximum for many important hosts |
   128|| 2.5 / 2+ | Extended Delegated Operations / Extended Non-Lockout Administration | Approved package install, diagnostics, user-service management, runtime recovery, controlled Docker ops; no lockout/capture | Preferred resident-host target for runtime-agent |
   129|| 3 | Full Sudo With Approval | Broad/full sudo, risky actions require explicit approval | Exceptional |
   130|| R3 | Resident Broad Sudo Reality Class | Broad resident runtime sudo (can include NOPASSWD:ALL) | High-risk exception only |
   131|| 4 | Full Sudo Autonomous | Full sudo without per-action approval | Disposable labs only |
   132|| 5 | Agent-Owned OS | Agent sole OS admin, human controls infra recovery | Special-purpose only |
   133|| 6 | Unbounded Agent Control | Agent controls OS/infrastructure with no human break-glass | Forbidden |
   134|
   135|---
   136|
   137|## CDEL Summary
   138|
   139|| Level | Name | Meaning | Default Policy |
   140||---:|---|---|---|
   141|| 0 | No Container Access | No container backend | Allowed |
   142|| 1 | Ephemeral Isolated Container | No mounts, no secrets, non-persistent | Preferred safe default |
   143|| 2 | Persistent Workspace Container | Persistent sandbox workspace | Acceptable with inspection |
   144|| 3 | Project-Mounted Container | Host project directory mounted | Requires Git discipline |
   145|| 4 | Secret-Forwarded Container | Scoped secrets forwarded | Requires explicit register entry |
   146|| 5 | Host-Privileged Container | Docker socket/privileged/host mounts | Forbidden by default |
   147|
   148|---
   149|
   150|## Managed Systems Register
   151|
   152|| System | Host/Alias | Residency | Asset Type | Criticality | ADAL target | Current runtime capability | CDEL | Agent User | Auth Method | Secret Location | Sudo Policy | Lockout Protection | Approved Scope | Owner | Rotation |
   153||---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
   154|| runtime-agent | runtime-agent | Resident Host | Hetzner VM | Production control-plane / agent runtime | ADAL-2.5 / ADAL-2+ | Current runtime is ADAL-R3-level on runtime-agent while `/etc/sudoers.d/agent-runtime` grants `agent` `NOPASSWD:ALL` and `agent` remains in the docker group. maintainer-preferred policy target remains ADAL-2.5 / ADAL-2+; this broader runtime state is accepted for resident-host bootstrap/recovery and should be reviewed later for possible reduction to ADAL-2.5 allowlists/wrappers. Active Open WebUI deployment is `open-webui.service` (agent user systemd service) using Python venv; Docker/Compose are installed and available but not active for Open WebUI. | Controlled resident Docker/container operations allowed for Hermes/runtime/sandbox management; high-risk CDEL-5 patterns require explicit approval or ADAL-R3 | agent | local user / SSH key | external vault reference only | Non-interactive sudo for documented operations: package install, diagnostics, Docker/runtime ops, user-service management, recovery; preserve no-lockout/no-capture boundary | the owner retains rfv/admin access, SSH break-glass, Hetzner console, snapshots/backups, rescue/rebuild | Hermes runtime, Open WebUI, Docker/container stack, package installation required for Oscar operations, control-plane maintenance, resident-host runtime recovery | the owner | 90d (current) / TBD |
   155|
   156|---
   157|
   158|## External Services Register
   159|
   160|| Service | Purpose | Runtime access path | ADAL (operational) | ESAL/Secret level | Allowed actions | Forbidden actions | Runtime validation | Hermes weekly maintenance impact | Owner / approval authority | Recovery custody reference |
   161||---|---|---|---|---|---|---|---|---|---|---|
   162|| GitHub / NousResearch Hermes upstream | Hermes core update source | `git -C <runtime-register-root> remote origin` | ADAL-4 | ESAL-4 operational; ESAL-5 account/recovery/admin | fetch, ls-remote, guarded update checks | push to NousResearch upstream, secret push, history rewrite | `git -C <runtime-register-root> ls-remote --heads origin main` | Blocking for Hermes update path | the owner approval for ESAL-5 actions | owner-controlled vault metadata reference (required; no secrets in Git) |
   163|| GitHub / Oscar fork | Autonomous proposal workspace | `origin` remote in `<private-workspace-path>`; `gh auth`/SSH | ADAL-4 | ESAL-4 operational; ESAL-5 account/recovery/admin | branch, commit, push to own fork, open/update PRs | merge upstream PRs, direct protected main pushes, force-push shared/protected branches, secret push | `git -C <private-workspace-path> remote -v`; `gh auth status` | Non-blocking for Hermes update; blocking only in git-maintenance/PR workflows | the owner | owner-controlled vault metadata reference (required) |
   164|| GitHub / Eurobotics upstream | Protected upstream repository and PR target | `upstream` remote in `<private-workspace-path>` | ADAL-4 for PR/open/update; ADAL-5 for direct push/merge/admin | ESAL-4 operational; ESAL-5 org/admin/recovery | fetch, compare, open/update PR | direct main push, merge, force-push/history rewrite without approval | `git -C <private-workspace-path> ls-remote --heads upstream main` | Non-blocking for Hermes update; blocking only in git-maintenance/PR workflows | the owner | owner-controlled vault metadata reference (required) |
   165|| Gmail / Himalaya | Operational mailbox read/send integration | `himalaya` + `<private-workspace-path>` + SMTP fallback wrapper | ADAL-4 read/send | ESAL-4 operational; ESAL-5 credentials/recovery/admin | list folders, list envelopes, read approved mail, send approved operational mail via approved fallback | print app password, native Himalaya send path until retested, blind retries after false-negative, credential rotation without approval | `scripts/validate-himalaya-gmail-wrapper.sh`; `scripts/validate-himalaya-send-workaround.sh` | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
   166|| Telegram gateway | Operational command/report channel | Hermes gateway + `TELEGRAM_*` env | ADAL-4 | ESAL-4 operational; ESAL-5 token/admin/recovery | approved admin/channel messaging | token disclosure, unapproved external disclosure | `systemctl --user is-active hermes-gateway.service` + env-name presence check | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
   167|| OpenRouter | Primary model provider/inference path | `OPENROUTER_API_KEY` + Hermes provider config | ADAL-4 | ESAL-4 operational; ESAL-5 billing/key/admin | approved inference/runtime task execution | key disclosure, unapproved spend/admin changes | `<private-workspace-path> config check` + env-name presence check | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
   168|| OpenAI / Codex auth | Provider capability for coding/model tasks when configured | `<runtime-register-root>` and/or provider env variables | ADAL-4 | ESAL-4 operational; ESAL-5 billing/account/recovery | approved model operations | token disclosure, unapproved billing/admin changes | auth metadata presence check (no token output) | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
   169|| Browserbase | Browser automation backend | `BROWSERBASE_API_KEY`, `BROWSERBASE_PROJECT_ID` | ADAL-4 | ESAL-4 operational; ESAL-5 key/project admin | approved browser automation runs | key disclosure, uncontrolled external interactions | `hermes config check` + env-name presence check | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
   170|| Browser Use API | Browser automation backend | `BROWSER_USE_API_KEY` | ADAL-4 | ESAL-4 operational; ESAL-5 key/admin | approved browser automation runs | key disclosure, uncontrolled external interactions | `hermes config check` + env-name presence check | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
   171|| ZeroTier | Private network path for runtime services | `zerotier-one.service` | ADAL-4 runtime connectivity | ESAL-4 operational; ESAL-5 network/account admin | private connectivity required for approved runtime paths | network secret disclosure, unauthorized topology/admin changes | `systemctl status zerotier-one --no-pager` | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
   172|| OpenWebUI private control path | Local agent control interface over private network | `open-webui.service` and private bind address | ADAL-4 | ESAL-4 operational; ESAL-5 admin/reset/recovery | approved private frontend access | unapproved public exposure, auth weakening | `systemctl --user is-active open-webui.service`; `ss -ltnp | grep :3000` | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
   173|| Local API server | Local runtime control API path | `API_SERVER_ENABLED`, `API_SERVER_HOST`, `API_SERVER_PORT`, `API_SERVER_KEY` | ADAL-4 | ESAL-4 operational; API key is ADAL-5 secret custody | approved local API operations | API key disclosure, unauthorized remote exposure | env-name presence check + runtime service checks | Non-blocking for Hermes update | the owner | owner-controlled vault metadata reference (required) |
   174|| Google Workspace (conditional) | Optional Google APIs via enabled skill | `google-workspace` skill + Google provider credentials if configured | ADAL-4 if enabled for operations | ESAL-4 operational; ESAL-5 account/admin/recovery | approved Gmail/Calendar/Drive/Docs operations when enabled | key/token disclosure, unauthorized admin/account changes | `hermes skills inspect google-workspace` + credential metadata presence check | Non-blocking for Hermes update | the owner; explicit human review before activation | pending human-review custody reference |
   175|
   176|No ESAL-4/5 external service is fully production-ready until owner recovery custody metadata references are documented and approved.
   177|
   178|### External target: external-target-a
   179|
   180|- Service/target: external-target-a
   181|- Type: external server / Hetzner VPS / Cloudron host
   182|- Hostname: external-target-01-hel1
   183|- IP: <redacted-ip>
   184|- SSH port: 22
   185|- SSH username: agent
   186|- SSH key path reference: <private-workspace-path>
   187|- Source package: Eurobotics-Association/agent-external-systems-management/servers/external-target-a
   188|- Active runtime evidence path: <private-workspace-path>
   189|- Initial/current approved posture: ADAL-2.5 controlled diagnostics
   190|- CDEL: package-defined controlled diagnostics / wrapper-limited
   191|- ESAL: SSH key and recovery material are sensitive; metadata only in register
   192|- Allowed actions:
   193| - metadata registration
   194| - first-contact identity/reachability checks
   195| - package-approved ADAL-2.5 wrapper-limited baseline audit
   196| - evidence summary generation
   197|- Forbidden actions:
   198| - no broad sudo
   199| - no arbitrary sudo
   200| - no sudo shell
   201| - no docker group/direct Docker socket access
   202| - no Docker exec/cp/run/stop/restart/prune/pull
   203| - no Cloudron modifications
   204| - no app/service restart
   205| - no package install/upgrade
   206| - no firewall/user/sudoers/SSHD changes
   207| - no credential or secret readout
   208| - no destructive commands
   209|- Wrapper baseline audit:
   210| - sudo -n /usr/local/sbin/adal25-baseline-audit-wrapper
   211| - completed at 20260506T202307Z
   212| - audit tarball hash: a9f3d2d98c2b48b25775ffd4a429b19a8aca4814edbba086eefd151e7a2972c3
   213|- Owner/approval: the owner
   214|- Recovery/break-glass: the owner-controlled Hetzner/Cloudron/admin recovery; metadata only
   215|- Maintenance impact: non-blocking for Hermes weekly maintenance
   216|- Status: ADAL-2.5 first-connect completed; further ADAL-3T/ADAL-4/ADAL-5 actions require explicit approval
   217|
   218|---
   219|
   220|## Monthly External Interaction Reports
   221|
   222|High-impact external services require monthly reporting.
   223|
   224|Required reports where applicable:
   225|
   226|- Monthly GitHub Report
   227|- Monthly Gmail Report
   228|- Monthly Telegram / External Messaging Report
   229|
   230|Preferred delivery order:
   231|
   232|1. Email to the owner/admin address if email is available.
   233|2. Telegram home/admin channel if email is unavailable.
   234|3. Local Markdown report in control-plane/runtime report directory if neither external channel is available.
   235|
   236|Reports should include counts/scopes of repository operations, communications, attachments/transfers, failed or blocked actions, permission-change requests, and confidentiality-relevant events.
   237|
   238|Reports must not include passwords, API keys, tokens, private keys, OAuth secrets, session cookies, recovery codes, or unnecessary sensitive personal data.
   239|
   240|---
   241|
   242|## Project Confidentiality Register
   243|
   244|| Project / Repo | Location | Visibility | PCL | Allowed Disclosure | External Communication Allowed | Approval Required For | Notes |
   245||---|---|---|---:|---|---|---|---|
   246|| private runtime governance repository | private operational control-plane repository | Private | PCL-3 | Internal/admin-only summaries; no external disclosure of confidential implementation/governance details | No external disclosure by default | Any external disclosure, publication, or third-party discussion | Contains governance and identity/control-plane material |
   247|| runtime-agent resident host runtime/infrastructure | runtime-agent Hetzner VM and linked operational components | Private | PCL-3 | Need-to-know operational/admin context only | No external disclosure by default | Any external disclosure, architecture sharing, or incident details outside approved channels | Includes sudo, recovery, break-glass, and runtime governance context |
   248|| Hermes-Yellow-Control (future community candidate) | Future extracted/sanitized project (not current repo baseline) | TBD (candidate public/community) | PCL-2 until explicitly reclassified | No external disclosure as public/community project until sanitized extraction and the owner approval | Not allowed until approval/reclassification | Public release, repo visibility change, or external promotion | May become PCL-0 only after sanitized extraction and explicit the owner approval |
   249|| Unknown project/repo | TBD | Unknown | PCL-2 | Minimal internal/admin discussion only until classified | No external discussion by default | Any external sharing prior to classification | Default confidentiality rule applies |
   250|
   251|---
   252|
   253|## Container Access Register
   254|
   255|| Host | Runtime | CDEL | Image/Profile | Mounts | Forwarded Env Vars | Docker Socket | Privileged Mode | Approved Scope | Notes |
   256||---|---|---:|---|---|---|---|---|---|---|
   257|| runtime-agent | Docker / Compose | 2-4 (controlled); 5 only by explicit approval | Resident runtime images and approved sandboxes | Runtime-required mounts only; no sensitive host mounts by default | Minimal required vars only; no personal passwords | no by default | no by default | Hermes/Open WebUI/runtime/sandbox operations | `--privileged`, sensitive host mounts, host PID/network for sensitive/public services, daemon reconfig, new public ports require explicit approval |
   258|
   259|---
   260|
   261|## Sudo Delegations Register
   262|
   263|| Host | User | ADAL target | Current runtime | Sudoers File | Allowed Commands/Wrappers | NOPASSWD | Risk Level | Approved By | Notes |
   264||---|---|---|---|---|---|---|---|---|---|
   265|| runtime-agent | agent | ADAL-2.5 / ADAL-2+ | Current runtime is ADAL-R3-level on runtime-agent while `/etc/sudoers.d/agent-runtime` grants `agent` `NOPASSWD:ALL` and `agent` remains in the docker group. maintainer-preferred policy target remains ADAL-2.5 / ADAL-2+; this broader runtime state is accepted for resident-host bootstrap/recovery and should be reviewed later for possible reduction to ADAL-2.5 allowlists/wrappers. | `/etc/sudoers.d/agent-runtime` and/or `/etc/sudoers.d/private runtime governance repository` | package installation, diagnostics, Docker/runtime operations, user-service management, Open WebUI/Hermes recovery; no owner lockout/capture operations | yes | medium-high; high if NOPASSWD:ALL | the owner | resident host only; not transferable to remote production systems; review later whether to reduce broad sudo to ADAL-2.5 allowlists/wrappers |
   266|
   267|---
   268|
   269|## Proposed Access Changes
   270|
   271|| Date | Requested By | Target | Needed Action | Proposed Mechanism | ADAL/CDEL Change | Status | Approved By | Notes |
   272||---|---|---|---|---|---|---|---|---|
   273|| YYYY-MM-DD | Oscar | TBD | TBD | TBD | TBD | proposed | pending the owner | TBD |
   274|
   275|---
   276|
   277|## Runtime onboarding references
   278|
   279|- `docs/security/external-services-onboarding.md`
   280|- `docs/security/skill-external-dependency-register.md`
   281|
   282|## Change Log
   283|
   284|| Date | Change | Author | Assisted-by |
   285||---|---|---|---|
   286|| 2026-05-02 | Initial Phase 0 skeleton | F.M. Robert Vergnes | ChatGPT: GPT-5.5 Thinking |
   287|| 2026-05-02 | Added ADAL-2.5/2+ target, runtime-agent resident-host runtime reality, ADAL-R3 risk clarification, and detailed sudo/container governance entries | F.M. Robert Vergnes | ChatGPT: GPT-5.5 Thinking [review], governed agent / Hermes-compatible runtime/Codex [implementation] |
   288|| 2026-05-06 | Incident note: post-reboot Himalaya/Gmail failure traced to env/TOML/inline-command quoting boundary; fixed by wrapper-based `auth.cmd` pattern. Yellow skills not directly implicated (direct CLI reproduction). | F.M. Robert Vergnes | ChatGPT: GPT-5.5 Thinking [canmore] |
   289|| 2026-05-06 | Follow-up: Himalaya v1.2.0 `message send` reproduces mail-parser panic; `template send` transmits via SMTP but fails IMAP sent-copy (`Folder doesn't exist`, tries literal `Sent`). Temporary send workaround documented via SMTP wrapper pending Himalaya upgrade/retest. | F.M. Robert Vergnes | ChatGPT: GPT-5.5 Thinking [canmore] |
   290|
   291|
   292|# Runtime external services onboarding (runtime-agent)
   293|
   294|Status: supporting onboarding snapshot, not canonical source of truth. Canonical service entries live in docs/security/external-access-register.md. Canonical skill entries live in config/skill-register.yaml and docs/skills/skill-register.md.
   295|
   296|
   297|## Scope
   298|
   299|Runtime-first onboarding snapshot for currently active runtime-agent external services and integration dependencies.
   300|
   301|This document records classification, access path, allowed/forbidden actions, validation commands, and current runtime status.
   302|
   303|No plaintext secrets are stored here.
   304|
   305|## Runtime snapshot date
   306|
   307|- UTC snapshot: 2026-05-06
   308|- Runtime profile/work context: `default` / `agent-dev`
   309|
   310|## Service register
   311|
   312|| Service | Runtime purpose | Operational level | Secret/admin level | Access path(s) | Allowed actions | Forbidden actions | Validation command(s) | Runtime status |
   313||---|---|---|---|---|---|---|---|---|
   314|| GitHub: NousResearch/hermes-agent upstream | Hermes core update source | ADAL-4 | ADAL-5 for account ownership/recovery | Hermes runtime git remote `origin` in `<runtime-register-root>` | `fetch`, `ls-remote`, guarded pull/update through maintenance wrapper | pushing to NousResearch upstream, history rewrite | `git -C <runtime-register-root> remote -v`; `git -C <runtime-register-root> ls-remote --heads origin main` | configured; reachability check implemented |
   315|| GitHub: Oscar fork/account | Oscar proposal workspace | ADAL-4 | ADAL-5 for account ownership/recovery/billing | `origin` remote in private runtime governance repository; `gh` auth; SSH git | branch/commit/push to own fork, open/update PR | force push to protected/shared branches, secret push, upstream merge without approval | `git -C <private-workspace-path> remote -v`; `gh auth status` | configured and authenticated |
   316|| GitHub: Eurobotics upstream repos | source-of-truth and PR target | ADAL-4 for fetch/compare/PR; ADAL-5 for direct push/merge to main | ADAL-5 for org admin/recovery | `upstream` remote in private runtime governance repository | fetch, compare, PR open/update | direct main push, merge, force-push/history rewrite without approval | `git -C <private-workspace-path> ls-remote --heads upstream main` | configured (push disabled in remote config) |
   317|| Gmail via Himalaya IMAP | mailbox read/list for operations | ADAL-4 | ADAL-5 for account recovery/app-password lifecycle | `himalaya` CLI using wrapper auth cmd | folder list, envelope list, read approved mail | print app password, rotate credentials without approval | `scripts/validate-himalaya-gmail-wrapper.sh` | validated working |
   318|| Gmail via SMTP fallback wrapper | controlled report send fallback | ADAL-4 | ADAL-5 for credential/recovery control | `<private-workspace-path>` + wrapper password retrieval | send approved operational messages | native Himalaya send path until retested; blind retries after template send false-negative | `scripts/validate-himalaya-send-workaround.sh` | validated working |
   319|| Telegram gateway | operational command/report interface | ADAL-4 | ADAL-5 for bot token/recovery/admin rights | Hermes gateway + TELEGRAM_* env vars | approved admin/channel messaging | token disclosure; unapproved external disclosure | `systemctl --user is-active hermes-gateway.service`; env-name presence check | active |
   320|| OpenRouter | model provider/inference | ADAL-4 | ADAL-5 for account/billing/key admin | OPENROUTER_API_KEY env var | inference/runtime task execution | key disclosure; unauthorized spend expansion | `hermes config check` + env-name presence check | present |
   321|| OpenAI/Codex auth (if configured) | coding/provider capability | ADAL-4 | ADAL-5 for account/recovery/billing | `<runtime-register-root>` and/or provider env | authorized model operations | token disclosure | auth metadata presence check only | auth file present |
   322|| Browserbase | browser automation backend | ADAL-4 | ADAL-5 for key/project admin | BROWSERBASE_API_KEY + BROWSERBASE_PROJECT_ID | approved browser automation | key disclosure; uncontrolled external interactions | `hermes config check` + env-name presence check | present |
   323|| Browser Use API | browser automation backend | ADAL-4 | ADAL-5 for key admin | BROWSER_USE_API_KEY | approved browser automation | key disclosure | `hermes config check` + env-name presence check | present |
   324|| ZeroTier | private network access path | ADAL-4 | ADAL-5 for network/account admin | host service `zerotier-one.service` | runtime connectivity for private path | network secret disclosure; unauthorized topology/admin changes | `systemctl status zerotier-one --no-pager` | active |
   325|| OpenWebUI (private frontend path) | local control interface exposed over private network | ADAL-4 | ADAL-5 for admin/auth reset/recovery | `open-webui.service`; bound private address | approved local/private frontend access | unapproved public exposure or auth weakening | `systemctl --user is-active open-webui.service`; `ss -ltnp | grep :3000` | active, bound on private IP |
   326|| Hermes API server endpoint | local API gateway control path | ADAL-4 | ADAL-5 for API key custody | API_SERVER_* env vars | approved local API operations | API key disclosure | env-name presence check; runtime service checks | enabled in env |
   327|
   328|## Critical runtime guard rules
   329|
   330|- Never hardcode unauthenticated private HTTPS GitHub URLs in runtime guards.
   331|- Non-interactive maintenance scripts must never prompt for GitHub username/password.
   332|- Hermes core auto-update reachability gate must check Hermes upstream/origin only.
   333|- private runtime governance repository fork/upstream reachability is non-blocking for Hermes auto-update and only blocking in explicit git-maintenance/PR workflows.
   334|
   335|## Runtime truth notes
   336|
   337|- Himalaya read path works through wrapper-based auth command.
   338|- Himalaya native send path is currently unsafe on this host/runtime version.
   339|- SMTP fallback wrapper is validated and should be used for approved sends.
   340|- OpenWebUI is active and listening on private ZeroTier address (`<redacted-ip>:3000` at snapshot time).
   341|
   342|## Approval model
   343|
   344|- Human owner approval required for ADAL-5 activities, recovery-path changes, credential rotation, and broad scope changes.
   345|- Classification onboarding is governance metadata; it does not grant additional authority by itself.
   346|
   347|
   348|
   349|
   350|
   351|
   352|# Runtime external-service onboarding quick reference
   353|
   354|Use when runtime failures suggest an external integration exists but is not governance-classified.
   355|
   356|## Trigger signals
   357|- Guard checks fail due wrong access path assumptions (example: unauthenticated private HTTPS git checks).
   358|- Service works manually but fails in automation due missing classified path (example: wrapper-based Gmail auth/send path).
   359|- Runtime maintenance depends on external providers/skills without explicit authority boundaries.
   360|
   361|## Default external-service authority chain
   362|
   363|For all external services/servers/packages/accounts/integrations, first check `agent-external-systems-management` unless the task explicitly provides another reviewed source or explicitly states no pre-registration exists.
   364|
   365|1) `agent-external-systems-management`
   366|- human-managed preparation source and pre-registration package
   367|- not a runtime register
   368|
   369|2) Yellow-control / Yellow skills
   370|- read and reconcile the pre-registration package with the owner's instruction
   371|- classify ADAL/CDEL/ESAL/PCL and apply guardrails
   372|- if pre-registration conflicts with the owner's instruction, stop and report mismatch
   373|
   374|3) Active Yellow runtime registers
   375|- write runtime-approved entries to `<runtime-register-root>`
   376|- especially `<runtime-register-root>`
   377|
   378|4) runtime-backup
   379|- take runtime backup before and after runtime register changes
   380|
   381|5) PR flow back to external-systems repo
   382|- Oscar must not invent missing metadata
   383|- Oscar must not directly modify Eurobotics upstream `agent-external-systems-management`
   384|- corrections must be proposed by PR through operator-owned fork/branch for the owner review
   385|
   386|external-target-a is one example only. This authority chain also applies to GitHub, Gmail/Himalaya, Telegram, OpenRouter, Browserbase, ZeroTier, OpenWebUI, local API server, Cloudron hosts, and future external servers.
   387|
   388|## Runtime-first onboarding sequence
   389|1) Inventory runtime facts without leaking secrets:
   390|- enumerate env var names only
   391|- check Hermes config/skills visibility
   392|- inspect systemd service/timer status
   393|- inspect git remotes from active repos
   394|- confirm wrapper/script presence and executable bits
   395|
   396|2) Classify each service with operational vs admin/recovery split:
   397|- operational usage: ADAL-4/ESAL-4 class where service can execute external actions or incur spend
   398|- account recovery/billing/security ownership: ADAL-5/ESAL-5 class
   399|
   400|3) GitHub role separation (mandatory):
   401|- Hermes upstream source for core update checks
   402|- Oscar fork for branch/commit/push/PR
   403|- authoritative upstream for compare + PR target
   404|- do not use hardcoded unauthenticated private HTTPS checks in guards
   405|
   406|4) Email/Gmail/Himalaya split:
   407|- read/list path can be operationally approved
   408|- send path must use validated approved route
   409|- do not print app-password/token values; metadata-only checks
   410|
   411|5) Maintenance alignment check:
   412|- Hermes core update guards must block only on Hermes upstream reachability
   413|- project fork/upstream checks should be non-blocking unless explicit git-maintenance mode is active
   414|
   415|## Validation minimums
   416|- `git diff --check`
   417|- `bash -n` on changed scripts
   418|- maintenance dry-run with no real update
   419|- secret hygiene check (no values in docs/logs)
   420|
   421|## Common pitfall
   422|Treating tool implementation details (wrappers, auth command paths) as non-governance concerns causes brittle automation. If a path is required for runtime reliability, onboard it as a governed external access path.
   423|
   424|# External-service authority chain doctrine patch validation
   425|
   426|Use this when patching Yellow runtime governance text for external-service authority chain rules.
   427|
   428|## Required checks
   429|
   430|1) Backup before patch
   431|- `/usr/local/bin/runtime-backup-tool --event pre-risky-change --reason "pre <change>"`
   432|
   433|2) Text presence validation
   434|- grep for section title:
   435| - `grep -R -n "Default external-service authority chain" <runtime-register-root> <runtime-register-root> <runtime-register-root>`
   436|- grep for doctrine source reference:
   437| - `grep -R -n "agent-external-systems-management" <runtime-register-root> <runtime-register-root> <runtime-register-root>`
   438|
   439|3) Skill visibility check
   440|- `hermes skills list | grep -Ei 'yellow-control|yellow-skill|yellow-project'`
   441|
   442|4) No-secret scan on changed docs
   443|- scan changed markdown for common token/password/private-key patterns before commit/push
   444|
   445|5) Post-change validation backup dry-run
   446|- `/usr/local/bin/runtime-backup-tool --dry-run --event post-risky-change --reason "validate <change>"`
   447|
   448|6) Final backup after successful validation
   449|- `/usr/local/bin/runtime-backup-tool --event post-risky-change --reason "post <change>"`
   450|
   451|## Staging preservation rule
   452|
   453|If runtime Yellow skill docs changed, preserve exact changed files under `<private-workspace-path>` only when corresponding staging files already exist. If a corresponding staging path does not exist, report the gap explicitly instead of inventing new staging structure silently.
   454|
   455|## Boundaries
   456|
   457|- Do not connect to external servers for this patch class.
   458|- Do not update Hermes during doctrine-only patches.
   459|- Do not modify SOUL.md.
   460|- Do not merge PRs in this workflow.
   461|
   462|## Onboarding checklist
   463|
   464|Confirm service identity; validate authority chain; classify ADAL/CDEL/ESAL/PCL; capture first-connect evidence; verify completion and backup coverage.
   465|
   466|## Ownership and recovery custody model
   467|
   468|Human administrators retain recovery authority; agent must not become sole recovery authority.
   469|
   470|## Access-chain validation
   471|
   472|Validate authentication method, repository/service reachability, policy constraints, and least-privilege scope.
   473|
   474|## Examples
   475|
   476|GitHub: fictional org/repo with scoped maintainer path.
   477|
   478|Email: fictional mailbox automation with constrained send scope.
   479|
   480|Cloud/API: fictional staging API key lifecycle.
   481|