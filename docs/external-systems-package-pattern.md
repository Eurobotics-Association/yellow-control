# External systems package pattern

Public-safe pattern using fictional targets only.

## Package structure

# External ADAL-2.5 first-connect checklist (runtime execution)

Use when Robert explicitly approves controlled diagnostics for an external host.

## Preconditions
- Read target package workflow under `oscar-external-systems-management/servers/<target>/`.
- Confirm host/user/port/key from approved task.
- Verify local key exists and has restricted mode (private key `600`).

## Execution sequence
1) Runtime backup before connection:
`/usr/local/bin/runtime-backup-tool --event pre-external-onboarding --reason "pre <target> ADAL-2.5 first-connect"`

2) First contact identity/reachability only over SSH as delegated user.

3) Run only package-approved wrapper command:
`sudo -n /usr/local/sbin/adal25-baseline-audit-wrapper`

4) Copy returned tarball into runtime evidence path only:
`<runtime-register-root>`

5) Lock evidence permissions:
- tarball: `chmod 600`
- local summary/trace files: `chmod 600`

6) Runtime backup after connection:
`/usr/local/bin/runtime-backup-tool --event post-external-onboarding --reason "post <target> ADAL-2.5 first-connect"`

## Forbidden reminders
- No arbitrary sudo, sudo shell, package installs, service restarts, Cloudron changes, or host config changes.
- No secrets in reports.
- No doctrine reinterpretation during execution.


Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking [governance + verification], Oscar/Hermes and/or Codex [execution]

# External onboarding completion verification (local-only)

Use this after an approved ADAL-2.5 first-connect has already run. Do not reconnect to target host for this step.

## Goal
Prove local Yellow-control onboarding closure with auditable artifacts and backup coverage.

## Required checks
1) Package provenance
- Confirm local package/clone path used.
- Confirm required package files were read (README, first-connect workflow, sudoers policy file, wrapper file).

2) Active runtime register entry
- Check `<runtime-register-root>`.
- Extract target-specific entry only.
- Verify it includes: target label, IP/host, user, key path (if governed), external-systems source reference, ADAL-2.5 controlled diagnostics wording, wrapper-limited sudo/no broad sudo, evidence path, and forbidden actions.
- If missing, mark onboarding incomplete and propose minimal register patch.

3) Local evidence inventory
- List files under `<runtime-register-root>`.
- Report filename, mode, size, sha256.
- Do not print raw evidence content unless explicitly required and safe.

4) Compacted summary artifact
- Check for `summary*.md`, `context*.md`, `first-connect-summary*.md`, or `onboarding-summary*.md` in evidence directory.
- If missing and task allows, create one from already-collected local evidence only (no reconnect):
  - target identity
  - timestamp
  - package source
  - commands executed
  - audit tarball hash
  - key findings
  - Cloudron status summary
  - remaining warnings
  - forbidden actions not executed
  - next recommended step

5) Backup coverage
- Identify latest `oscar-backup` snapshot stamp/commit/push status.
- Confirm backup includes runtime register path.
- Confirm whether evidence path and/or compacted summary are included.
- If evidence paths are excluded by backup scope, explicitly report that and ensure a compact summary is available in a backed-up governed location when required by policy/task.

## Action rule
- If a summary was newly created, run:
  `/usr/local/bin/runtime-backup-tool --event post-external-onboarding --reason "post <target> onboarding completion summary"`

## Reporting format
Include:
- completion verdict (complete vs partial)
- missing steps
- corrective action taken
- final recommendation before next connection stage

## Pitfalls observed
- First-connect can succeed while onboarding remains incomplete if runtime register target entry was never added.
- Evidence may exist locally but not be covered by backup snapshots depending on backup include scope.
- Avoid claiming full onboarding completion without both register presence and backup visibility checks.


# Proposal package redaction adversarial tests

Use this when preparing proposal-only shell script packages that include redaction logic and review artifacts.

## Goal
Catch leak regressions before install review by testing wrapper redaction functions offline with adversarial samples.

## Required checks
1) Run `bash -n` on all proposal scripts.
2) Run a control-character scan on scripts (reject bytes <32 except tab/newline/carriage return).
3) Execute offline adversarial redaction tests against every wrapper with a `redact()` function.
4) Run no-secret scan on package contents.

## Adversarial sample classes
Include at minimum:
- Authorization/Bearer
- Cookie/Set-Cookie
- token/access_token/refresh_token/api_key/access_key/secret_key/client_secret/password
- database_url
- URI secrets: postgres:// mysql:// mongodb:// redis://
- oauth/smtp credential-like fields
- multiline-ish fragments

## Failure policy
- If any sample value survives redaction, fail package generation and patch scripts before reporting.
- Do not mark install-ready when redaction tests fail.

## No-secret scan interpretation
If a test fixture intentionally embeds synthetic secrets for adversarial validation:
- Keep fixture clearly under `tests/` and document intent.
- Exclude only that fixture path from no-secret pass/fail gating.
- Still scan all other files normally.
- Report the exclusion explicitly in validation output.

## Reporting format
Validation section should state:
- adversarial redaction test executed: pass/fail
- control-character scan: pass/fail
- no-secret scan: pass (with explicit fixture exclusion if used)
- remaining limitations (regex-based redaction caveat + recommend host-side adversarial replay before install)

## Proposal-only package rules

Proposal bundles may include wrappers, templates, and checklists; no real credentials or production host details.

## ADAL-2.5 wrapper pattern

Use temporary task-scoped wrappers with explicit allowlist and bounded sudo.

## First-connect audit workflow

Baseline check, evidence collection, permission verification, summary artifact, and governance review.

## Sudoers/wrapper safety concept

No static broad sudo grants; require time-bounded grants and revocation path.

## Redaction/adversarial tests

Run tests to ensure private identifiers are removed while logic remains intact.
