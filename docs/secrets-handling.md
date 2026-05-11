# Secrets handling

Public-safe secrets governance extraction.

## What must never be committed

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

## Redaction standards

Only placeholders and fictional values are allowed in public artifacts.

## Secret custody naming without values

Use role labels for custody ownership, never values.

## Public-safety scan rules

Scan for keys/tokens/password markers, private runtime identifiers, and private endpoints.

## Forbidden vs allowed examples

Forbidden: live token/private endpoint pair. Allowed: fictional identifier and redacted endpoint.
