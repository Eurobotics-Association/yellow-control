# Yellow-Control packaged governance references

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

These files are the packaged skill references for the installable Yellow-Control Hermes skill.
They carry the operational governance doctrine inside `skills/yellow-control-governance/references/` so an installed copy remains self-contained.
Top-level `docs/` files may remain human-facing mirrors, but the skill-local references are the packaged doctrine the agent should consult at runtime.
SKILL.md stays concise by design; this directory contains the detailed policy text.

## Consultation order

Start with the requested action and identify whether it is privileged, external, confidential, persistent, repository-affecting, or server-facing.
Consult `authority-model.md` to identify accountable roles and whether context is authority proof.
Classify ADAL, CDEL, ESAL, and PCL using the four classification references.
If the task touches a new or uncertain external server, consult `server-first-contact.md` before any mutation.
If the task uses a service, server, API, repository, account, webhook, or dashboard, consult `external-access-register.md` and `external-access-onboarding.md`.
If the task can change persistent state, consult `backup-and-rollback.md`.
Evaluate the decision with `policy-gates.md`.
Use `secrets-handling.md`, `github-governance.md`, and `governance-telemetry.md` whenever those concerns apply.
Return allow, defer, or block with missing evidence, required approval, rollback requirement, and telemetry summary.

## Reference map

| Reference | Consult when |
| --- | --- |
| `authority-model.md` | Identifying human accountable authority, operator roles, maintainer roles, governed agent role, runtime role, no self-granting, break-glass, recovery custody, and emergency stop behavior. |
| `adal.md` | Classifying agent delegated administration, sudo, PAM, IAM, wrappers, host impact, lockout or capture risk, resident runtime changes, and external target administration. |
| `cdel.md` | Classifying containers, sandboxes, runners, Docker socket risk, privileged containers, host mounts, forwarded secrets, host network or PID namespace, and delegated execution. |
| `esal.md` | Classifying external services, APIs, SaaS, repositories, external servers, account custody, recovery custody, first contact, and external package references. |
| `pcl.md` | Classifying project confidentiality, default-private handling, publication, redaction, private runtime data, secret data, recovery data, and examples. |
| `policy-gates.md` | Applying authority, classification and scope, backup and rollback, external-access register, confidentiality, persistence, repository, and telemetry gates. |
| `backup-and-rollback.md` | Preparing checkpoints, rollback plans, stop conditions, validation checks, first-contact readiness, runtime governance rollback, and failure handling. |
| `external-access-register.md` | Creating or validating register entries, required fields, secret references, server examples, service examples, and missing metadata outcomes. |
| `server-first-contact.md` | Handling new or unknown servers, pre-contact checkpoint, authority, identity confirmation, hostile output risk, read-only baseline audit, and revoke path. |
| `external-access-onboarding.md` | Onboarding external targets through intake, classification, registration, approval, validation, execution handoff, and review. |
| `secrets-handling.md` | Handling no-plaintext-secret policy, secret references, runtime injection, credential files, recovery custody, log leakage, and suspected exposure. |
| `github-governance.md` | Governing GitHub or GitLab workflows, agent-owned accounts, forks, branches, pull requests, protected branches, force-push restrictions, and merge authority. |
| `governance-telemetry.md` | Recording decision records, classifications, gate results, evidence references, missing approval, rollback requirements, final decision, and safe telemetry. |

## Task-to-reference map

| Task type | Primary references |
| --- | --- |
| Local documentation or policy edit | `authority-model.md`, `pcl.md`, `policy-gates.md`, `github-governance.md`, `governance-telemetry.md` |
| Sudo, package, service, network, identity, or recovery change | `adal.md`, `authority-model.md`, `backup-and-rollback.md`, `policy-gates.md`, `secrets-handling.md` |
| Container, runner, CI, sandbox, or Docker socket work | `cdel.md`, `adal.md`, `pcl.md`, `backup-and-rollback.md`, `policy-gates.md` |
| External API, SaaS, repository service, webhook, or account work | `esal.md`, `external-access-register.md`, `external-access-onboarding.md`, `secrets-handling.md`, `policy-gates.md` |
| New or uncertain server contact | `server-first-contact.md`, `external-access-register.md`, `esal.md`, `adal.md`, `pcl.md`, `backup-and-rollback.md` |
| Publishing, logging, telemetry, or repository commits | `pcl.md`, `secrets-handling.md`, `github-governance.md`, `governance-telemetry.md` |
| Persistent automation or scheduled operation | `authority-model.md`, `policy-gates.md`, `backup-and-rollback.md`, `esal.md`, `cdel.md` |

## Packaged-reference rule

Use these skill-local files as the operational doctrine when the skill is installed.
Do not depend on repository-relative `docs/` paths at runtime.
Do not add private operational state, real target entries, or runtime-specific material to these packaged references.
Do not claim official Hermes or Nous approval; this repository provides a Hermes-compatible skill layout and public-safe governance doctrine.
