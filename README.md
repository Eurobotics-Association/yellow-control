# Yellow-Control

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

Yellow-Control is a narrow, public-safe governance skill repository for persistent autonomous agents.

Status: v0.1.3 minimal Yellow-Control skill rebuild.

## Purpose

Yellow-Control defines the governance controls an agent must apply before it changes systems, crosses authority boundaries, handles confidential material, or integrates external services. It is intentionally limited to policy classification, policy gates, rollback readiness, external-access governance, secrets handling, GitHub governance, telemetry, and a Hermes-compatible `SKILL.md`.

## In scope

- authority model
- ADAL: Administrative Delegation and Authority Level
- CDEL: Containerized Delegated Execution Level
- ESAL: External Service Authority Level
- PCL: Privacy and Confidentiality Level
- policy gates
- backup and rollback governance
- external-access register
- server-first-contact procedure
- external-access onboarding
- secrets handling
- GitHub governance as an external-access workflow
- governance telemetry
- Hermes-compatible skill behavior

## Out of scope

- project-management governance
- skill-registry governance
- project, runtime, or skill registers
- dumped operational policy files
- runtime-specific private material
- external package implementation details


## Prerequisites and non-requirements

Yellow-Control is a governance layer, not a runtime installer or external package manager. Before using it for live agent work, confirm:

- a Hermes-compatible runtime is already installed and operating;
- Git is available for repository workflows;
- GitHub, GitLab, or a similar repository service is available if repository automation is used;
- the agent uses its own account, bot identity, or fork for Git automation instead of borrowing a human maintainer session;
- backup or checkpoint capability exists before risky actions;
- external package management is a separate and optional implementation layer;
- Telegram, OpenWebUI, gateway services, dashboards, and similar integrations are optional runtime integrations, not Yellow-Control requirements.

## Repository map

| Path | Purpose |
| --- | --- |
| `docs/authority-model.md` | Authority classes and required evidence. |
| `docs/adal.md` | Administrative authority levels for host and system operations. |
| `docs/cdel.md` | Delegated execution levels for containers and constrained runtimes. |
| `docs/esal.md` | External service authority and custody levels. |
| `docs/pcl.md` | Privacy and confidentiality levels. |
| `docs/policy-gates.md` | Mandatory allow/defer/block gates. |
| `docs/backup-and-rollback.md` | Backup checkpoints and rollback readiness. |
| `docs/external-access-register.md` | Minimal register schema for external access. |
| `docs/server-first-contact.md` | First-contact procedure for new servers. |
| `docs/external-access-onboarding.md` | Onboarding workflow for external services. |
| `docs/secrets-handling.md` | Public-safe secret handling rules. |
| `docs/github-governance.md` | GitHub access governed as external access. |
| `docs/governance-telemetry.md` | Decision, gate, and outcome telemetry. |
| `skills/yellow-control-governance/SKILL.md` | Hermes-compatible governance skill entry point. |

## Default decision posture

Yellow-Control is conservative by default:

1. Classify the action with ADAL, CDEL, ESAL, and PCL.
2. Evaluate mandatory policy gates.
3. Allow only when authority, scope, confidentiality, backup, rollback, external-access, and telemetry prerequisites are satisfied.
4. Defer when evidence is incomplete.
5. Block when the action violates policy or attempts to bypass governance.

## Public-safe rule

Do not commit credentials, tokens, private hostnames, private addresses, private runtime paths, internal incident records, or operational state. Use role names, fictional identifiers, and redacted examples.
