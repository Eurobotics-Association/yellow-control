# Scope boundaries

Defines scope of this public repository vs related governance assets.

## Yellow-Control scope

Classification, policy gates, telemetry, and public-safe governance patterns.

## Related scopes

---
name: yellow-project-management
description: Runtime reference for project/profile governance — project identity, labels, canonical IDs, work-context mapping, and cron-project binding.
version: 0.1.0
platforms: [linux]
metadata:
  hermes:
    tags: [governance, project-management, profile-register, project-register, labels, canonical-id, cron-binding, self-registration]
    related_skills: [yellow-control-governance, yellow-skill-registry]
---
Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking [skills architecture], Oscar/Hermes and/or Codex [implementation]

# yellow-project-management

## Purpose

Yellow Project Management is the runtime reference skill for project identity, profile/work-context mapping, labels, cron-project binding, typo-safe project resolution, and project self-registration proposals.

## When to use

Use this skill before:

- working on any project/repo/path;
- interpreting a project name, acronym, label, or typo;
- creating/modifying cron prompts related to projects;
- reporting project status;
- cross-project references;
- deciding which repo/path/profile/work-context applies;
- touching unregistered repos/workstreams/persistent automations.

## Core concepts

- Profile = competence/work context.
- Project = concrete repo/mission/work item.
- External target = server, VM, VPS, service, API, dashboard, account, container host, or managed runtime.
- Current governed work context: `oscar-dev` mapped to Hermes `default` runtime profile.
- Project Register = reference register for project identity (not runtime authority).
- Profile Register = reference register for profile/work-context mapping (not runtime authority).
- External Access Register = reference register for external-target authority metadata (not runtime authority).
- Project-to-target relationship is many-to-many.
- A project does not exclusively own an external target unless explicitly documented.
- Unknown PCL defaults to `PCL-2 Private`.
- Unknown authority defaults to no operational authority.
- Unknown or ambiguous project reference must stop execution.

## Register reference files

Runtime register root (runtime-agent):
- Active Yellow runtime registers live under `<runtime-register-root>`.
- Legacy `<runtime-register-root>` is historical/deployed snapshot only and must not be treated as active register root.
- Unless a task explicitly states another reviewed register root, relative register paths resolve under `<runtime-register-root>`.

- `docs/security/governance-levels-reference.md`
- `config/project-register.yaml`
- `config/profile-register.yaml`
- `docs/projects/project-register.md`
- `docs/projects/profile-register.md`
- `docs/security/external-access-register.md`
- `AGENTS.md`

## Must do

- Consult `docs/security/governance-levels-reference.md` before applying ADAL/CDEL/ESAL/PCL-linked project decisions.
- Resolve `canonical_id` before operational action.
- Use registered label in reports/messages.
- Verify owning profile/work-context.
- If project/workstream is unregistered, propose a Project Register update before operational use.
- For projects involving external targets/services, ensure referenced targets are governed via External Access Register.
- If project-to-target mapping is unknown or ambiguous, propose register updates instead of inventing linkage.
- External Package references must be honored when present; package context informs implementation boundaries but does not grant authority.
- Include `profile_id`, `canonical_id`, `label`, `PCL`, workspace path, reporting channel, allowed actions, and forbidden actions in cron prompts.
- Stop on unknown/ambiguous project references.
- For runtime operations, apply runtime-first discipline: inspect/validate live runtime state first, then persist validated findings into the appropriate repo layer.
- Do not use or imply “source of truth/source-of-truth” language for runtime-agent runtime doctrine. Use: runtime state, backup snapshot, staging repo.
- Treat runtime, deployed snapshot, and git worktree as separate layers; do not infer runtime state from repo state alone.
- For register/export/audit tasks, use a mandatory three-layer check sequence: (1) live runtime state and active services/skills, (2) deployed snapshot layer (`<runtime-register-root>` when present), then (3) staging/worktree (`<private-workspace-path>`). Report drift explicitly by layer.
- For runtime-agent Option D role split: `oscar-backup` is Oscar-owned runtime backup/rollback snapshots, `private-control-repo` is temporary Oscar-specific control/skill staging, and reusable Yellow development belongs in a separate `yellow-suite` repo.
- Do not push repo changes for runtime mechanisms that are not deployed/validated in runtime.
- Do not develop `private-control-repo` abstractly when task intent is runtime operations; keep repo state synchronized to validated runtime behavior.
- Do not invent missing classifications; unresolved authority remains no operational authority and unresolved confidentiality remains `PCL-2 Private`.
- Proposal does not equal permission: proposed register, project, access, or skill changes are governance preparation only until approved by the Governance Authority or explicitly delegated Authorized Operator.
- Treat typos as risks, not invitations to guess.
- Throttle repeated missing-info requests by maintaining one pending proposal per session/topic.

## Must not do

- Mix project contexts.
- Act on deferred contexts unless the Governance Authority or an explicitly delegated Authorized Operator reactivates them.
- Create/modify/run project cron automation without Yellow Control governance approval.
- Invent workspace paths or remotes.
- Continue operational actions when project identity/authority remains unresolved.


---
name: yellow-skill-registry
description: Informational governance skill for skill inventory, lifecycle state tracking, and pending-review reporting.
version: 0.1.0
platforms: [linux]
metadata:
  hermes:
    tags: [governance, skill-registry, lifecycle, inventory, reporting]
    related_skills: [yellow-control-governance, yellow-project-management]
---
Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking [architecture + governance], Oscar/Hermes and/or Codex [implementation]

# yellow-skill-registry

## Purpose

Yellow Skill Registry is the runtime reference skill for informational skill inventory, lifecycle dashboarding, and pending-review visibility.

This skill is informational in Phase 2 and is not an enforcement allowlist.

## When to use

Use this skill before:

- governance reporting on available/proposed/runtime-created skills;
- introducing new persistent skills into repo governance;
- deciding lifecycle state transitions (`proposed`, `active`, `archived`, `retired`, `pending_review`);
- auditing runtime-visible skills against repo-managed governance assets.

## Register reference files

Runtime register root (runtime-agent):
- Active Yellow runtime registers live under `<runtime-register-root>`.
- Legacy `<runtime-register-root>` is historical/deployed snapshot only and must not be treated as active register root.
- Unless a task explicitly states another reviewed register root, relative register paths resolve under `<runtime-register-root>`.

- `docs/security/governance-levels-reference.md`
- `config/skill-register.yaml`
- `docs/skills/skill-register.md`
- `docs/skills/yellow-skills.md`
- `AGENTS.md`

## Must do

- Consult `docs/security/governance-levels-reference.md` before applying ADAL/CDEL/ESAL/PCL-related labels in reports.
- Track canonical skill identity and lifecycle state.
- External Package assets are not skills by default; track them as governance context unless explicitly onboarded as skills.
- Report runtime-created or unregistered skills as `pending_review`.
- Distinguish desired repo state, deployed runtime state, and evidence sources.
- For register-contract audits, classify findings per layer: live runtime, deployed snapshot (`<runtime-register-root>`), and staging/worktree. Do not collapse these layers in reports.
- Minimum contract expectation for Yellow governance reporting must include references to: `config/project-register.yaml`, `config/profile-register.yaml`, `config/skill-register.yaml`, `docs/security/external-access-register.md`, and `docs/skills/skill-register.md`; missing/stale status must be reported explicitly.
- Unknown authority defaults to no operational authority and unknown confidentiality defaults to `PCL-2 Private`.
- Proposal does not equal permission: proposed register, project, access, or skill changes are governance preparation only until approved by the Governance Authority or explicitly delegated Authorized Operator.
- Do not invent missing classifications; mark uncertainty explicitly.
- Include confidence/risk grading in governance reports.
- Preserve author/assisted-by metadata and YAML front matter integrity checks for governed SKILL files.

## Must not do

- Treat register absence as automatic runtime block.
- Auto-activate, auto-deploy, or auto-retire skills without approval from the Governance Authority or explicitly delegated Authorized Operator.
- Delete or overwrite runtime skills opportunistically.


# Yellow skills: proposed repo-managed assets

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking [skills architecture], Oscar/Hermes and/or Codex [implementation]

## Purpose

This document defines the Yellow governance skill model and how skills are proposed, routed, and reviewed.

## Proposed vs active

- Skills stored in this repository are **proposed assets**.
- They are **not active** merely because they exist in Git.
- Runtime skills are loaded from `<runtime-register-root>` (or other configured skill directories).
- Deployment/activation of repo-managed skills requires explicit approval from the Governance Authority or explicitly delegated Authorized Operator and pre-apply backup.
- Existing runtime skills may include locally evolved behavior and must not be blindly overwritten.
- Runtime mutable evidence (including remote-audit artifacts) belongs under local runtime state paths and is not runtime register data in git.
- Deployment is additive/targeted in this phase.
- No deletion semantics are allowed (`rsync --delete` or wholesale replacement of `<runtime-register-root>` is forbidden).
- Unrelated existing runtime skills must be preserved.

## Yellow skills in Phase 2

- `yellow-control-governance`: external-target access governance (authority, ADAL/CDEL/ESAL, wrappers, External Packages Management, confidentiality, baseline audit, Persistent Automation Guard).
- `yellow-project-management`: project/workstream governance (Project Register, Profile Register, labels, canonical IDs, project-to-target references, typo-safe resolution, cron-project binding).
- `yellow-skill-registry`: informational skill inventory/lifecycle reporting and pending-review tracking; it does not grant project or external-target authority.
- External target and project mapping is many-to-many; unknown relationships must be proposed, not invented.

## Routing precedence

When multiple governance dimensions apply:

1. Evaluate authority/risk/confidentiality through `yellow-control-governance`.
2. Resolve project identity/context through `yellow-project-management`.
3. Record/report skill inventory/lifecycle through `yellow-skill-registry`.

## Acronym model

Canonical quick reference for ADAL/CDEL/ESAL/PCL:
- `docs/security/governance-levels-reference.md`

- **ADAL** = Agent Delegated Administration Level
- **CDEL** = Container Delegated Execution Level
- **ESAL** = External Service Access Level
- **PCL** = Project Confidentiality Level
- **PAM/IAM** = privileged access and identity/access management governance

These are governance concepts, not standalone skills.

## Skill Register relationship

- The Skill Register (`config/skill-register.yaml`) is informational/dashboard only in Phase 2.
- Register absence does not automatically forbid Hermes from seeing a skill.
- Runtime-created/unregistered skills must be reported as `pending_review` until adopted or removed.
- Lifecycle states supported: `active`, `proposed`, `archived`, `retired`, `pending_review`.

## Persistent Automation Guard placement

- Persistent Automation Guard is defined in Yellow Control Governance.
- Yellow Project Management references it whenever project/cron automation is involved.

## Development and runtime test workflow

- Skill development lifecycle and redeploy protocol: `docs/skills/yellow-skill-development-workflow.md`
- Generic runtime behavior tests: `docs/skills/yellow-skill-test-protocol.md`
- Repo `SKILL.md` files are the protected upstream repository and PR target for skill definitions; runtime edits must be reconciled back into repo before future deploy cycles.
- For mature runtimes, use `--prepare-merge` then targeted manual apply for reviewed `SKILL.md` proposals.



## Yellow Control vs External Packages Management

- **Hermes Yellow Control / `private-control-repo`**: global governance model, ADAL/CDEL/ESAL/PCL rules, Yellow skills, and register governance.
- **External Packages Management**: target-specific implementation packages (manifests, wrappers, sudoers snippets, install/rollback scripts, operational constraints).
- For private package repositories, authenticated access checks (`gh auth status`, `gh repo view`, `git ls-remote` over SSH) should be attempted before declaring package inaccessibility.
- If authenticated access succeeds during a requested dry-run simulation, continue the simulation flow automatically.
- External Packages are context and implementation boundaries; they are not permission by themselves.
- Wrapper existence does not equal permission; capability does not equal authority; proposal does not equal permission.
- External Package assets are not Hermes skills unless explicitly designed as skills and governed as such.

## Related governance docs

- `AGENTS.md`
- `docs/security/agent-pam-iam-adal-cdel-policy.md`
- `docs/security/external-access-register.md`
- `docs/security/governance-levels-reference.md`
- `docs/security/remote-server-baseline-audit.md`
- `docs/deployment-workflow.md`
- `docs/runtime-governance-sync.md`
- `config/project-register.yaml`
- `config/profile-register.yaml`
- `config/skill-register.yaml`
- `docs/skills/skill-register.md`


# Skill Register

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking [architecture + governance], Oscar/Hermes and/or Codex [implementation]

## Purpose

The Skill Register (`config/skill-register.yaml`) is the Phase 2 governance dashboard for skill inventory and lifecycle visibility.

It is **informational only** in Phase 2. It is not an enforcement allowlist.

## Scope and role

- Tracks registered skills with canonical identity and lifecycle state.
- Tracks runtime visibility/deployment status.
- Tracks risk/confidence for governance reporting.
- Supports future skill curator workflows.

## Required tracked fields

Each skill entry tracks:

- `canonical_id`
- `status` (`active`, `proposed`, `archived`, `retired`, `pending_review`)
- `runtime_status`
- `owner`
- `domain`
- `description`
- `routing_summary`
- `repo_path`
- `runtime_path`
- `lifecycle`
- `curator_state`
- `archived_at_utc`
- `archive_reason`
- `mutation_policy`
- report `confidence`/`risk` grade

## Runtime-created and unregistered skills

- Runtime-created skills are not auto-approved control-plane assets.
- Runtime-created or unregistered skills must be reported as `pending_review`.
- `pending_review` means review is required before adoption, archival, or removal.

## Phase 2 policy boundaries

- Register absence does not automatically forbid Hermes from seeing a skill.
- Proposal does not equal activation.
- Activation/modification/deployment of persistent skills requires explicit Governance Authority approval (or explicitly delegated Authorized Operator approval).

## Relationship to other governance registers

- External access targets and authority boundaries: `docs/security/external-access-register.md`
- Project/workstream identity: `config/project-register.yaml`
- Profile/work-context mapping: `config/profile-register.yaml`
- Runtime skill routing model: `docs/skills/yellow-skills.md`
- Skill external dependency onboarding snapshot: `docs/security/skill-external-dependency-register.md`

## Canonical coverage statement

Canonical register currently covers runtime-agent high-impact runtime skills and Yellow governance skills. Full enabled-skill external dependency coverage is future yellow-skill-registry work.

## Canonical high-impact skill coverage (current)

At minimum, canonical entries exist in `config/skill-register.yaml` for:

- yellow-control-governance (local)
- yellow-project-management (local)
- yellow-skill-registry (local)
- himalaya (builtin)
- himalaya-gmail-wrapper-and-send-fallback (local)
- codex (builtin)
- hermes-agent (builtin)
- github-auth (builtin)
- github-code-review (builtin)
- github-pr-workflow (builtin)
- github-repo-management (builtin)
- codebase-inspection (builtin)
- upstream-first-fork-execution (local)
- browser-failure-web-doc-fallback (local, if present)
- google-workspace (builtin, conditional external credentials)

Each canonical entry includes or cross-references:

- source (builtin/local)
- external dependencies
- ADAL impact
- allowed actions
- forbidden actions
- validation command
- human approval requirement
- runtime status
- canonical external service references

## Private forever

Real host identifiers, credentials, internal logs, and private infrastructure topology.
