# GitHub governance

Public-safe repository governance.

## Repository controls


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

## Branch and PR discipline

Use patch branches and review gates; no history rewrite on public release tracks.

## Release governance

Tag/release only after safety and policy checks pass.
