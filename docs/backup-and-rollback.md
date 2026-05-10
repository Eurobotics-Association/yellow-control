# Backup and rollback governance

Backup-first policy and rollback readiness.

## Backup policy

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking [canmore], Codex

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


Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking [deployment safety design], Oscar/Hermes and/or Codex [implementation]

# Deployment workflow

## Philosophy

`private-control-repo` governs reviewed control artifacts in git. Hermes runtime uses deployed copies from this repository and does not define governance source.

The operating model is one-way promotion:

1. Review and update governed files in git.
2. Pull the latest changes on the host checkout (for example `/opt/private-control-repo`).
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

- `runtime-governance`: SOUL/AGENTS/README + governed config/docs under `$HERMES_HOME/private-control-repo/...`
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
Sensitive differing files are backed up and staged for Oscar/Codex merge review with Robert approval before any apply decision.

For mature/non-newborn runtimes, do not use `--apply-staged` as a bulk operation on sensitive governance files unless all of the following are true:

1. staged candidates were reviewed;
2. clean merged proposals were produced where needed;
3. runtime-specific content was preserved or deliberately retired;
4. Robert explicitly approved apply;
5. backup and rollback path is known.

Sensitive governance paths include:

- `$HERMES_HOME/SOUL.md`
- `$HERMES_HOME/AGENTS.md`
- `$HERMES_HOME/README.md`
- `$HERMES_HOME/skills/*/SKILL.md`
- `$HERMES_HOME/private-control-repo/config/*.yaml`
- `$HERMES_HOME/private-control-repo/docs/security/*.md`
- `$HERMES_HOME/private-control-repo/docs/skills/*.md`

Missing runtime governance files may be copied during `--prepare-merge`.
Existing different sensitive files must be staged, not overwritten.
For `SOUL.md`, `AGENTS.md`, and `SKILL.md`, prefer targeted manual apply of reviewed merged proposals over generic `--apply-staged`.
This is especially important for skills because runtime skills may have evolved locally.

## Runtime evidence and audit artifacts

Remote-audit evidence and other mutable runtime artifacts are not deployed from git. Keep them under XDG state paths:

- `<runtime-state-root>/remote-audits/<target-id>/<timestamp>/`
- recommended files: `audit.tar.zst`, `audit.sha256`, `manifest.json`, `summary.md`, `findings.md`, `normalized-context.md`

`normalized-context.md` is the preferred compact context file for future work on the same target.

Raw audit tarballs and host-local sensitive logs must not be committed to git. Default retention is 3 months; longer retention for incident/security evidence requires Robert approval.

Monthly recurring audits are persistent automation and require explicit approval before cron/systemd creation.

Paths under `<runtime-register-root>` are not the preferred current evidence path.

## Mandatory pre-apply backup/checkpoint gate

Before any runtime deploy/re-apply touches files, `scripts/deploy.sh` must run `scripts/pre-apply-backup.sh`.

If pre-apply backup fails, deployment must stop.

Backup target:

- `<private-workspace-path>`

Security constraints:

- backup directory owner: `oscar:oscar`
- backup directory mode: `700`
- artifact mode: `600` where practical
- backups may contain sensitive runtime files and must never be committed, emailed, or sent to Telegram by default
- logs list file names/status only; no secret values

Backup scope includes, when present:

- private-control-repo git branch/HEAD/status/log and `git bundle --all`
- private-control-repo working tree tarball (excluding `.git`, `.env`, caches, `node_modules`, `__pycache__`, `*.pyc`)
- Hermes critical runtime files (`SOUL.md`, `config.yaml`, `.env`, `auth.json`, checkpoints metadata)
- Open WebUI critical runtime files (`open-webui.env`, user systemd unit, `webui.db`, `.webui_secret_key`)
- privileged config snapshots (`/etc/sudoers.d/oscar-agent`, `/etc/sudoers.d/private-control-repo`) via `sudo -n`
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

Author="F.M. Robert Vergnes / robert.vergnes@yahoo.fr"
Assisted_by="ChatGPT: GPT-5.5 Thinking [deployment safety design], Oscar/Hermes and/or Codex [implementation]"

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
  echo "ERROR: sudo -n preflight failed; non-interactive sudo is required before pre-apply backup. Remediation: restore oscar sudoers non-interactive access (for example /etc/sudoers.d/oscar-agent) and verify with: sudo -n true" >&2
  exit 1
fi

mkdir -p "$BACKUP_DIR"
chown oscar:oscar "$BACKUP_BASE" "$BACKUP_DIR" 2>/dev/null || true
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
  git branch --show-current >"${BACKUP_DIR}/private-control-repo-git-branch.txt"
  git rev-parse HEAD >"${BACKUP_DIR}/private-control-repo-git-head.txt"
  git status --short >"${BACKUP_DIR}/private-control-repo-git-status.txt"
  git log --oneline -20 >"${BACKUP_DIR}/private-control-repo-git-log.txt"
  git bundle create "${BACKUP_DIR}/private-control-repo-all.bundle" --all

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
    -czf "${BACKUP_DIR}/private-control-repo-workingtree.tar.gz" \
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
sudo_copy_if_present "/etc/sudoers.d/oscar-agent" "${BACKUP_DIR}/system/oscar-agent.sudoers"
sudo_copy_if_present "/etc/sudoers.d/private-control-repo" "${BACKUP_DIR}/system/private-control-repo.sudoers"
if [[ -d "<private-workspace-path> ]]; then
  tar -czf "${BACKUP_DIR}/system/systemd-user-units.tar.gz" -C "<private-workspace-path> user
  chmod 600 "${BACKUP_DIR}/system/systemd-user-units.tar.gz" || true
else
  note_missing "<private-workspace-path>
fi

# 6) runtime report (no secret values)
OSCAR_UID="$(id -u oscar)"
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
  echo "[services-as-oscar]"
  sudo -u oscar XDG_RUNTIME_DIR="/run/user/${OSCAR_UID}" systemctl --user status hermes-gateway.service --no-pager || true
  sudo -u oscar XDG_RUNTIME_DIR="/run/user/${OSCAR_UID}" systemctl --user status open-webui.service --no-pager || true
  echo
  echo "[ports]"
  ss -ltnp | grep -E ':3000\b|:8642\b' || true
  echo
  echo "[processes]"
  ps -ef | grep -E 'hermes|open-webui' | grep -v grep || true
  echo
  echo "[docker-as-oscar]"
  sudo -iu oscar bash -lc 'docker ps -a || true'
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
- `ls -l /usr/local/bin/oscar-hermes-check /usr/local/bin/oscar-hermes-update /usr/local/bin/oscar-hermes-weekly-maintenance`

## Scheduler discovery
- `crontab -l || true`
- `sudo -n crontab -l -u root || true`
- `grep -RInE 'hermes|oscar-hermes|weekly' /etc/cron.d /etc/crontab /etc/cron.daily /etc/cron.weekly 2>/dev/null || true`
- `systemctl --user list-timers --all | grep -Ei 'hermes|oscar' || true`
- `systemctl --user list-unit-files | grep -Ei 'hermes|oscar' || true`
- `systemctl list-timers --all | grep -Ei 'hermes|oscar' || true`

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

## Rollback policy

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking [canmore], Codex

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

## Checkpoint expectations

Pre-action checkpoint is required; post-action verification must be recorded.
