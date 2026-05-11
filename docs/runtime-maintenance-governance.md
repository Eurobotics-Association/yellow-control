# Runtime maintenance governance

Public-safe governance for maintenance lifecycle.

## Weekly maintenance governance pattern

#!/usr/bin/env bash
# Author: F.M. the owner Vergnes / robert.vergnes@yahoo.fr
# Assisted-by: ChatGPT: GPT-5.5 Thinking [canmore]
set -euo pipefail

MODE="check-only"
DRY_RUN="${DRY_RUN:-0}"
AUTO_UPDATE="0"
CHECK_ONLY="0"
for arg in "$@"; do
 case "$arg" in
 --dry-run) DRY_RUN="1" ;;
 --auto-update) AUTO_UPDATE="1" ;;
 --check-only) CHECK_ONLY="1" ;;
 *) echo "Unknown argument: $arg" >&2; exit 2 ;;
 esac
done
if [[ "$AUTO_UPDATE" == "1" ]]; then MODE="auto-update"; fi
if [[ "$CHECK_ONLY" == "1" ]]; then MODE="check-only"; fi
if [[ "$DRY_RUN" == "1" ]]; then MODE="${MODE} (dry-run)"; fi

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
HERMES_BIN="${HERMES_BIN:-$HERMES_HOME/hermes-agent/venv/bin/hermes}"
REPO_DIR="${REPO_DIR:-<private-workspace-path>
CHECK_SCRIPT="$REPO_DIR/scripts/hermes-weekly-update-check.sh"
VALIDATOR_SCRIPT="$REPO_DIR/scripts/validate-himalaya-gmail-wrapper.sh"
LOG_DIR="$HERMES_HOME/logs"
TS="$(date -u +%Y%m%dT%H%M%SZ)"
LOG_PATH="$LOG_DIR/hermes-weekly-maintenance-$TS.log"
SUMMARY_PATH="$LOG_DIR/hermes-weekly-maintenance-latest.summary.md"
BACKUP_DIR="$HERMES_HOME/backups/pre-hermes-update-$TS"

mkdir -p "$LOG_DIR"
: > "$LOG_PATH"
exec > >(tee -a "$LOG_PATH") 2>&1

status=0
defer_reason=""
notify_status=""

load_kv_env_file(){
 local f="$1"
 [[ -f "$f" ]] || return 1
 set -a
 # shellcheck disable=SC1090
 . "$f"
 set +a
 return 0
}

notify_operator(){
 local level="$1"
 local detail="$2"
 local msg
 msg="[agent-hermes-weekly-maintenance] ${level} | mode=${MODE} | reason=${defer_reason:-none} | detail=${detail} | log=${LOG_PATH}"

 notify_status="none"

 load_kv_env_file "$HERMES_HOME/.env" >/dev/null 2>&1 || true
 load_kv_env_file "$HERMES_HOME/config/telegram.env" >/dev/null 2>&1 || true

 local bot_token="${TELEGRAM_BOT_TOKEN:-}"
 local chat_id="${TELEGRAM_CHAT_ID:-${TELEGRAM_HOME_CHANNEL:-}}"
 local thread_id="${TELEGRAM_THREAD_ID:-}"

 if [[ -n "$bot_token" && -n "$chat_id" ]]; then
 say "NOTIFY: attempting telegram"
 local curl_rc=0
 if [[ -n "$thread_id" ]]; then
 curl -fsS -X POST "https://api.telegram.org/bot${bot_token}/sendMessage" \
 --data-urlencode "chat_id=${chat_id}" \
 --data-urlencode "message_thread_id=${thread_id}" \
 --data-urlencode "text=${msg}" >/dev/null || curl_rc=$?
 else
 curl -fsS -X POST "https://api.telegram.org/bot${bot_token}/sendMessage" \
 --data-urlencode "chat_id=${chat_id}" \
 --data-urlencode "text=${msg}" >/dev/null || curl_rc=$?
 fi
 if [[ "$curl_rc" -eq 0 ]]; then
 notify_status="telegram"
 say "NOTIFY: telegram sent"
 return 0
 fi
 say "NOTIFY: telegram failed rc=$curl_rc"
 else
 if [[ -n "$bot_token" && -z "$chat_id" ]]; then
 say "NOTIFY: telegram token present but chat destination missing"
 elif [[ -z "$bot_token" && -n "$chat_id" ]]; then
 say "NOTIFY: telegram chat destination present but token missing"
 else
 say "NOTIFY: telegram not configured"
 fi
 fi

 if [[ -x "<private-workspace-path> ]]; then
 load_kv_env_file "$HERMES_HOME/.env" >/dev/null 2>&1 || true
 load_kv_env_file "$HERMES_HOME/config/email.env" >/dev/null 2>&1 || true
 local notify_to="${OSCAR_OPERATOR_EMAIL:-${OSCAR_EMAIL_TO:-${OSCAR_EMAIL_FROM:-}}}"
 if [[ -n "$notify_to" ]]; then
 say "NOTIFY: attempting smtp-email wrapper"
 if <private-workspace-path> \
 --to "$notify_to" \
 --subject "Oscar Hermes weekly maintenance: ${level}" \
 --body "$msg" >/dev/null; then
 notify_status="email"
 say "NOTIFY: smtp-email sent"
 return 0
 fi
 say "NOTIFY: smtp-email failed"
 else
 say "NOTIFY: email recipient not configured"
 fi
 else
 say "NOTIFY: smtp-email wrapper missing"
 fi

 notify_status="none"
 return 1
}

say(){ echo "$*"; }
run(){ "$@"; }
run_maybe(){ if [[ "$DRY_RUN" == "1" ]]; then say "DRY RUN: $*"; else "$@"; fi }
has_skill(){
 local name="$1"
 "$HERMES_BIN" skills inspect "$name" >/dev/null 2>&1
}

check_preflight(){
 say "== Preflight =="
 [[ -x "$HERMES_BIN" ]] || { say "FAIL: Hermes binary missing at $HERMES_BIN"; return 1; }
 say "OK: Hermes binary present"

 if git -C "$HERMES_HOME/hermes-agent" diff --quiet && git -C "$HERMES_HOME/hermes-agent" diff --cached --quiet; then
 say "OK: Hermes git tree clean"
 else
 say "DEFER: Hermes git tree not clean"
 defer_reason="Hermes git tree dirty"
 return 2
 fi

 if "$HERMES_BIN" config check >/dev/null 2>&1; then
 say "OK: config check"
 else
 say "WARN: config check non-zero (will run migrate in maintenance flow)"
 fi

 systemctl --user is-active --quiet hermes-gateway.service || { say "DEFER: hermes-gateway.service not active"; defer_reason="gateway inactive"; return 2; }
 say "OK: gateway active"
 systemctl --user is-active --quiet open-webui.service || { say "DEFER: open-webui.service not active"; defer_reason="openwebui inactive"; return 2; }
 say "OK: OpenWebUI active"

 has_skill "yellow-control-governance" || { say "DEFER: yellow-control-governance skill not visible"; defer_reason="yellow skill missing"; return 2; }
 has_skill "yellow-project-management" || { say "DEFER: yellow-project-management skill not visible"; defer_reason="yellow skill missing"; return 2; }
 has_skill "yellow-skill-registry" || { say "DEFER: yellow-skill-registry skill not visible"; defer_reason="yellow skill missing"; return 2; }
 say "OK: Yellow skills visible"

 if [[ -x "$VALIDATOR_SCRIPT" ]]; then
 "$VALIDATOR_SCRIPT" >/dev/null 2>&1 || { say "DEFER: Himalaya read-path validator non-zero"; defer_reason="himalaya read-path failed"; return 2; }
 say "OK: Himalaya read-path validator"
 else
 say "DEFER: validator script missing: $VALIDATOR_SCRIPT"
 defer_reason="validator missing"
 return 2
 fi

 local avail_kb
 avail_kb="$(df -Pk "$HERMES_HOME" | awk 'NR==2{print $4}')"
 say "Disk available KB: $avail_kb"
 if [[ "${avail_kb:-0}" -lt 1048576 ]]; then
 say "DEFER: low disk space (<1GB)"
 defer_reason="low disk"
 return 2
 fi

 # Hermes core update only needs Hermes upstream/origin reachability.
 # Do not hard-require private runtime governance repository fork/upstream reachability unless a separate
 # git-maintenance mode is active.
 if git -C "$HERMES_HOME/hermes-agent" ls-remote --heads origin main >/dev/null 2>&1; then
 say "OK: Hermes upstream/origin reachability"
 else
 say "DEFER: Hermes upstream/origin reachability check failed"
 defer_reason="hermes origin unreachable"
 return 2
 fi

 if git -C "$REPO_DIR" ls-remote --heads origin main >/dev/null 2>&1; then
 say "OK: private runtime governance repository fork reachability"
 else
 say "WARN: private runtime governance repository fork reachability check failed (non-blocking for Hermes auto-update)"
 fi

 if git -C "$REPO_DIR" ls-remote --heads upstream main >/dev/null 2>&1; then
 say "OK: private runtime governance repository upstream reachability"
 else
 say "WARN: private runtime governance repository upstream reachability check failed (non-blocking for Hermes auto-update)"
 fi

 return 0
}

check_active_work(){
 say "== Active-work safety =="
 local cron_out kanban_out
 cron_out="$("$HERMES_BIN" cron list 2>&1 || true)"
 echo "$cron_out" | sed -n '1,20p'
 if echo "$cron_out" | grep -Eiq '\b(running|in_progress|executing|locked)\b'; then
 say "Raw cron list output (defer evidence):"
 printf '%s\n' "$cron_out"
 say "DEFER: active cron work detected"
 defer_reason="active cron work"
 return 2
 fi

 kanban_out="$("$HERMES_BIN" kanban list 2>&1 || true)"
 echo "$kanban_out" | sed -n '1,20p'
 if echo "$kanban_out" | grep -Eiq 'running|claimed|in_progress'; then
 say "DEFER: active kanban work detected"
 defer_reason="active kanban work"
 return 2
 fi

 say "OK: no obvious active risky work"
 return 0
}

backup_state(){
 say "== Backup =="
 run_maybe mkdir -p "$BACKUP_DIR"
 if [[ "$DRY_RUN" == "1" ]]; then
 say "DRY RUN: backup directory would be $BACKUP_DIR"
 return 0
 fi

 git -C "$HERMES_HOME/hermes-agent" status --short > "$BACKUP_DIR/git-status-before.txt" || true
 git -C "$HERMES_HOME/hermes-agent" rev-parse HEAD > "$BACKUP_DIR/hermes-head-before.txt" || true
 "$HERMES_BIN" --version > "$BACKUP_DIR/hermes-version-before.txt" 2>&1 || true
 "$HERMES_BIN" skills list > "$BACKUP_DIR/skills-list-before.txt" 2>&1 || true
 "$HERMES_BIN" config check > "$BACKUP_DIR/config-check-before.txt" 2>&1 || true
 systemctl --user status hermes-gateway.service --no-pager -l > "$BACKUP_DIR/gateway-status-before.txt" 2>&1 || true
 systemctl --user status open-webui.service --no-pager -l > "$BACKUP_DIR/openwebui-status-before.txt" 2>&1 || true
 if [[ -f "$HOME/.config/himalaya/config.toml" ]]; then
 cp "$HOME/.config/himalaya/config.toml" "$BACKUP_DIR/himalaya-config.toml"
 fi
 if [[ -f "$VALIDATOR_SCRIPT" ]]; then
 cp "$VALIDATOR_SCRIPT" "$BACKUP_DIR/validate-himalaya-gmail-wrapper.sh"
 fi
 if [[ -f "$HERMES_HOME/.env" ]]; then
 stat "$HERMES_HOME/.env" > "$BACKUP_DIR/hermes-env-metadata.txt" 2>&1 || true
 sha256sum "$HERMES_HOME/.env" > "$BACKUP_DIR/hermes-env-sha256.txt" 2>&1 || true
 fi
 say "Backup written: $BACKUP_DIR"
}

do_update_flow(){
 say "== Update flow =="
 if [[ "$DRY_RUN" == "1" ]]; then
 say "DRY RUN: would run $HERMES_BIN update"
 say "DRY RUN: would run $HERMES_BIN config migrate && $HERMES_BIN config check"
 say "DRY RUN: would restart hermes-gateway.service"
 return 0
 fi

 "$HERMES_BIN" update
 "$HERMES_BIN" config migrate
 "$HERMES_BIN" config check
 systemctl --user restart hermes-gateway.service
 sleep 3
 systemctl --user is-active --quiet hermes-gateway.service
}

validate_post(){
 say "== Post-validation =="
 "$HERMES_BIN" --version || return 1
 "$HERMES_BIN" config check || return 1
 "$HERMES_BIN" skills list > /tmp/hermes-skills-list.$$ 2>&1 || return 1
 "$HERMES_BIN" skills inspect yellow-control-governance >/dev/null 2>&1 || return 1
 "$HERMES_BIN" skills inspect yellow-project-management >/dev/null 2>&1 || return 1
 "$HERMES_BIN" skills inspect yellow-skill-registry >/dev/null 2>&1 || return 1
 grep -F "github-" /tmp/hermes-skills-list.$$ >/dev/null || return 1
 "$VALIDATOR_SCRIPT" >/dev/null 2>&1 || return 1
 systemctl --user is-active --quiet open-webui.service || return 1
 systemctl --user is-active --quiet hermes-gateway.service || return 1
 rm -f /tmp/hermes-skills-list.$$ || true
}

write_summary(){
 cat > "$SUMMARY_PATH" <<EOF
# Hermes weekly maintenance summary
- Timestamp (UTC): $TS
- Mode: $MODE
- Status: $1
- Defer reason: ${defer_reason:-none}
- Log: $LOG_PATH
- Backup: $BACKUP_DIR
EOF
 say "Summary path: $SUMMARY_PATH"
}

say "Hermes weekly maintenance wrapper"
say "Mode: $MODE"

if [[ "$AUTO_UPDATE" != "1" ]]; then
 "$CHECK_SCRIPT"
 rc=$?
 write_summary "check-only rc=$rc"
 say "Log path: $LOG_PATH"
 exit $rc
fi

rc=0
check_preflight || rc=$?
if [[ "$rc" -ne 0 ]]; then
 if [[ "$rc" -eq 2 ]]; then
 write_summary "deferred"
 say "Maintenance result: DEFERRED"
 notify_operator "DEFERRED" "preflight guard blocked update" || true
 say "Notification method: ${notify_status}"
 say "Deferred safely: $defer_reason"
 say "Log path: $LOG_PATH"
 exit 0
 fi
 write_summary "failed-preflight"
 say "Maintenance result: FAILED"
 notify_operator "FAILED" "preflight failed" || true
 say "Notification method: ${notify_status}"
 say "Log path: $LOG_PATH"
 exit 1
fi

rc=0
check_active_work || rc=$?
if [[ "$rc" -ne 0 ]]; then
 if [[ "$rc" -eq 2 ]]; then
 write_summary "deferred"
 say "Maintenance result: DEFERRED"
 notify_operator "DEFERRED" "active-work guard blocked update" || true
 say "Notification method: ${notify_status}"
 say "Deferred safely: $defer_reason"
 say "Log path: $LOG_PATH"
 exit 0
 fi
 write_summary "failed-active-work-check"
 say "Maintenance result: FAILED"
 notify_operator "FAILED" "active-work check failed" || true
 say "Notification method: ${notify_status}"
 say "Log path: $LOG_PATH"
 exit 1
fi

backup_state

do_update_flow

if validate_post; then
 write_summary "success"
 say "Maintenance result: SUCCESS"
 notify_operator "SUCCESS" "update/check completed successfully" || true
 say "Notification method: ${notify_status}"
else
 write_summary "post-validate-failed"
 say "Maintenance result: FAILED"
 notify_operator "FAILED" "post-validation failed" || true
 say "Notification method: ${notify_status}"
 status=1
fi

say "Log path: $LOG_PATH"
exit "$status"


#!/usr/bin/env bash
# Author: F.M. the owner Vergnes / robert.vergnes@yahoo.fr
# Assisted-by: ChatGPT: GPT-5.5 Thinking [canmore]
set -euo pipefail

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
LOG_DIR="${HERMES_WEEKLY_LOG_DIR:-$HERMES_HOME/logs}"
TS_LOG="$(date -u +%Y%m%dT%H%M%SZ)"
LOG_PATH="${LOG_DIR}/hermes-weekly-update-check-${TS_LOG}.log"

mkdir -p "$LOG_DIR"
: > "$LOG_PATH"
exec > >(tee -a "$LOG_PATH") 2>&1

hermes_detected="false"
hermes_bin_source="unknown"
hermes_bin=""

# Optional guarded Git maintenance mode (disabled by default).
# Enable with --git-maintenance or WEEKLY_GIT_MAINTENANCE=1.
git_maintenance_mode="${WEEKLY_GIT_MAINTENANCE:-0}"
dry_run_mode="${WEEKLY_GIT_MAINTENANCE_DRY_RUN:-${DRY_RUN:-0}}"

for arg in "$@"; do
 case "$arg" in
 --git-maintenance) git_maintenance_mode="1" ;;
 --dry-run) dry_run_mode="1" ;;
 esac
done

# Project defaults from register (private runtime governance repository)
UPSTREAM_REMOTE="${UPSTREAM_REMOTE:-upstream}"
FORK_REMOTE="${FORK_REMOTE:-origin}"
UPSTREAM_BASE_REF="${UPSTREAM_BASE_REF:-upstream/main}"
PR_BASE_BRANCH="${PR_BASE_BRANCH:-main}"
BRANCH_PREFIX="${BRANCH_PREFIX:-maintenance/hermes-weekly}"
TS_UTC="$(date -u +%Y%m%d-%H%M)"
MAINT_BRANCH="${MAINT_BRANCH:-${BRANCH_PREFIX}-${TS_UTC}}"

# Allowlist: only these files may be auto-committed by weekly maintenance.
OSCAR_MAINT_ALLOWLIST_REGEX="${OSCAR_MAINT_ALLOWLIST_REGEX:-^(docs/hermes-update-policy\.md|scripts/hermes-weekly-update-check\.sh|scripts/agent-hermes-weekly-maintenance\.sh|docs/operating-model\.md|policy/github-safety\.md|scripts/templates/agent-hermes-weekly-maintenance\.service|scripts/templates/agent-hermes-weekly-maintenance\.timer)$}"

redact_path() {
 local p="$1"
 p="${p/#$HOME/~}"
 p="${p/#${HERMES_HOME}/\$HERMES_HOME}"
 printf '%s' "$p"
}

detect_hermes() {
 local candidate=""

 if [[ -n "${HERMES_BIN:-}" && -x "${HERMES_BIN}" ]]; then
 hermes_bin="${HERMES_BIN}"
 hermes_bin_source="env"
 hermes_detected="true"
 return 0
 fi

 if candidate="$(command -v hermes 2>/dev/null || true)" && [[ -n "$candidate" && -x "$candidate" ]]; then
 hermes_bin="$candidate"
 hermes_bin_source="path-command"
 hermes_detected="true"
 return 0
 fi

 candidate="${HERMES_HOME}/hermes-agent/venv/bin/hermes"
 if [[ -x "$candidate" ]]; then
 hermes_bin="$candidate"
 hermes_bin_source="venv-hermes-home"
 hermes_detected="true"
 return 0
 fi

 candidate="$HOME/.hermes/hermes-agent/venv/bin/hermes"
 if [[ -x "$candidate" ]]; then
 hermes_bin="$candidate"
 hermes_bin_source="venv-default"
 hermes_detected="true"
 return 0
 fi

 candidate="$HOME/.local/bin/hermes"
 if [[ -x "$candidate" ]]; then
 hermes_bin="$candidate"
 hermes_bin_source="local-bin"
 hermes_detected="true"
 return 0
 fi

 return 1
}

run_secret_scan_cached() {
 if git diff --cached --name-only | grep -E '(^|/)\.env($|\.)|(^|/)secrets?($|/)|id_rsa|id_ed25519|\.pem$|\.p12$|\.key$|credentials' >/dev/null 2>&1; then
 echo "Secret scan: FAIL (sensitive filename/path pattern detected in staged files)." >&2
 return 1
 fi

 if git diff --cached -U0 | grep -Ei '(^\+.*(api[_-]?key|token|secret|password|passwd|authorization)\s*[:=]\s*[^ ]+)|(^\+.*AKIA[0-9A-Z]{16})|(^\+.*ghp_[A-Za-z0-9]{36,})' >/dev/null 2>&1; then
 echo "Secret scan: FAIL (secret-like content pattern detected in staged diff)." >&2
 return 1
 fi

 echo "Secret scan: OK"
}

run_secret_scan_filelist() {
 local files="$1"

 if printf '%s\n' "$files" | grep -E '(^|/)\.env($|\.)|(^|/)secrets?($|/)|id_rsa|id_ed25519|\.pem$|\.p12$|\.key$|credentials' >/dev/null 2>&1; then
 echo "Secret scan (dry-run): FAIL (sensitive filename/path pattern detected in candidate files)." >&2
 return 1
 fi

 while IFS= read -r f; do
 [[ -n "$f" ]] || continue
 if ! git diff -U0 -- "$f" | grep -E '^\+' | grep -vE '^\+\+\+' | grep -Ei '(api[_-]?key|token|secret|password|passwd|authorization)\s*[:=]\s*[^ ]+|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{36,}' >/dev/null 2>&1; then
 continue
 fi
 echo "Secret scan (dry-run): FAIL (secret-like content pattern detected in candidate diff for $f)." >&2
 return 1
 done <<<"$files"

 echo "Secret scan (dry-run): OK"
}

run_guarded_git_maintenance() {
 local branch="${MAINT_BRANCH}"
 local dirty_files outside_allowlist commit_sha

 echo ""
 echo "Guarded Git maintenance mode: ENABLED"

 if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
 echo "Git maintenance: abort (not inside a git work tree)." >&2
 return 2
 fi

 if [[ "$dry_run_mode" == "1" ]]; then
 echo "Git maintenance: DRY RUN mode enabled."

 if git remote get-url "$UPSTREAM_REMOTE" >/dev/null 2>&1; then
 echo "DRY RUN remote check: upstream remote '$UPSTREAM_REMOTE' found"
 else
 echo "Git maintenance: abort (missing upstream remote '$UPSTREAM_REMOTE')." >&2
 return 2
 fi

 if git remote get-url "$FORK_REMOTE" >/dev/null 2>&1; then
 echo "DRY RUN remote check: fork remote '$FORK_REMOTE' found"
 else
 echo "Git maintenance: abort (missing fork remote '$FORK_REMOTE')." >&2
 return 2
 fi

 if git show-ref --verify --quiet "refs/remotes/${UPSTREAM_BASE_REF}"; then
 echo "DRY RUN base ref check: ${UPSTREAM_BASE_REF} present locally"
 else
 echo "DRY RUN base ref check: ${UPSTREAM_BASE_REF} missing locally; would run: git fetch ${UPSTREAM_REMOTE} --prune"
 fi

 dirty_files="$(git status --porcelain | awk '{print $2}' || true)"
 if [[ -z "$dirty_files" ]]; then
 echo "DRY RUN classification: no dirty files; no commit candidate"
 else
 outside_allowlist="$(printf '%s\n' "$dirty_files" | grep -Ev "$OSCAR_MAINT_ALLOWLIST_REGEX" || true)"
 echo "DRY RUN allowlist regex: $OSCAR_MAINT_ALLOWLIST_REGEX"
 if [[ -n "$outside_allowlist" ]]; then
 echo "Git maintenance: abort (dirty files outside allowlist)." >&2
 printf 'Outside allowlist:\n%s\n' "$outside_allowlist" >&2
 return 4
 fi
 run_secret_scan_filelist "$dirty_files"
 echo "DRY RUN candidate files:"
 printf ' %s\n' $dirty_files
 fi

 echo "DRY RUN branch naming: ${branch}"
 echo "DRY RUN PR target: <org>/<private-governance-repo>:${PR_BASE_BRANCH} <- <agent-fork-owner>:${branch}"
 echo "DRY RUN final decision: eligible for guarded commit/push/PR only if non-dry-run mode is enabled and scans pass"
 echo "DRY RUN: no commit/push/PR performed"
 return 0
 fi

 git fetch "$UPSTREAM_REMOTE" --prune
 git fetch "$FORK_REMOTE" --prune

 if ! git switch -C "$branch" "$UPSTREAM_BASE_REF"; then
 echo "Git maintenance: abort (cannot switch to maintenance branch; check local working tree state)." >&2
 return 3
 fi

 dirty_files="$(git status --porcelain | awk '{print $2}' || true)"
 if [[ -z "$dirty_files" ]]; then
 echo "Git maintenance: nothing to commit."
 return 0
 fi

 outside_allowlist="$(printf '%s\n' "$dirty_files" | grep -Ev "$OSCAR_MAINT_ALLOWLIST_REGEX" || true)"
 if [[ -n "$outside_allowlist" ]]; then
 echo "Git maintenance: abort (dirty files outside allowlist)." >&2
 printf 'Outside allowlist:\n%s\n' "$outside_allowlist" >&2
 return 4
 fi

 while IFS= read -r f; do
 [[ -n "$f" ]] || continue
 git add -- "$f"
 done <<<"$dirty_files"

 if git diff --cached --quiet; then
 echo "Git maintenance: nothing staged after allowlist filtering."
 return 0
 fi

 run_secret_scan_cached

 git commit -m "chore(maintenance): weekly hermes policy/workflow sync ${TS_UTC}"
 commit_sha="$(git rev-parse HEAD)"

 git push "$FORK_REMOTE" "$branch"

 if gh auth status >/dev/null 2>&1; then
 if gh pr view --repo <org>/<private-governance-repo> "$branch" >/dev/null 2>&1; then
 gh pr edit --repo <org>/<private-governance-repo> "$branch" \
 --title "chore: weekly Hermes maintenance sync (${TS_UTC})" \
 --body "Automated weekly maintenance sync from Oscar fork branch ${branch}.\n\nPolicy guards enforced:\n- allowlist-only file commit\n- no secret-like staged content\n- no merge action\n\nPlease review before merge."
 echo "PR status: existing PR updated for branch $branch"
 else
 gh pr create --repo <org>/<private-governance-repo> \
 --base "$PR_BASE_BRANCH" \
 --head "<agent-fork-owner>:$branch" \
 --title "chore: weekly Hermes maintenance sync (${TS_UTC})" \
 --body "Automated weekly maintenance sync from Oscar fork branch ${branch}.\n\nPolicy guards enforced:\n- allowlist-only file commit\n- no secret-like staged content\n- no merge action\n\nPlease review before merge."
 echo "PR status: new PR opened for branch $branch"
 fi
 else
 echo "GitHub auth unavailable; local/remote branch kept: $branch"
 echo "Next command: gh auth status"
 fi

 echo "Git maintenance report:"
 echo " fork_remote=${FORK_REMOTE}"
 echo " upstream_remote=${UPSTREAM_REMOTE}"
 echo " branch=${branch}"
 echo " commit=${commit_sha}"
 echo " push=completed"
 echo " merge=not-performed"
}

detect_hermes || true

if [[ "$hermes_detected" != "true" ]]; then
 echo "Hermes weekly update check"
 echo "Status: no callable Hermes binary found."
 echo "Searched sources: HERMES_BIN, PATH, \$HERMES_HOME venv, default <runtime-register-root> venv, ~/.local/bin/hermes"
 echo "Log path: $(redact_path "$LOG_PATH")"
 exit 2
fi

safe_hermes_bin="$(redact_path "$hermes_bin")"
status=0

echo "Hermes weekly update check"
echo "Detected Hermes: ${safe_hermes_bin} (source=${hermes_bin_source})"

version_output="$($hermes_bin --version 2>&1 || true)"
if [[ -n "$version_output" ]]; then
 echo "Version output: $version_output"
else
 echo "Version output: unavailable"
 status=1
fi

if [[ "$version_output" =~ [Uu]pdate[[:space:]]+available|new[[:space:]]+version|out[[:space:]]+of[[:space:]]+date ]]; then
 echo "Update signal: update appears available."
 status=1
else
 echo "Update signal: no explicit update signal detected in --version output."
fi

if "$hermes_bin" config check >/dev/null 2>&1; then
 echo "Config check: OK"
else
 echo "Config check: review recommended (command returned non-zero)."
 status=1
fi

if "$hermes_bin" skills check >/dev/null 2>&1; then
 echo "Skills check: OK"
else
 echo "Skills check: review recommended (command returned non-zero)."
 status=1
fi

if systemctl --user is-active --quiet hermes-gateway.service; then
 echo "Gateway service check: ACTIVE"
else
 echo "Gateway service check: NOT ACTIVE"
 status=1
fi

if systemctl --user is-active --quiet open-webui.service; then
 echo "OpenWebUI service check: ACTIVE"
else
 echo "OpenWebUI service check: NOT ACTIVE"
 status=1
fi

if ./scripts/validate-himalaya-gmail-wrapper.sh >/dev/null 2>&1; then
 echo "Himalaya read-path validator: OK"
else
 echo "Himalaya read-path validator: review recommended (non-zero)."
 status=1
fi

if [[ "$git_maintenance_mode" == "1" ]]; then
 if ! run_guarded_git_maintenance; then
 status=1
 fi
else
 echo "Guarded Git maintenance mode: DISABLED (set WEEKLY_GIT_MAINTENANCE=1 or use --git-maintenance to enable)."
fi

echo ""
echo "Manual update command (when needed):"
echo " cd <runtime-register-root> && source venv/bin/activate && hermes update"
echo "Scheduled guarded auto-update is handled by /usr/local/bin/agent-hermes-weekly-maintenance --auto-update"
echo "Log path: $(redact_path "$LOG_PATH")"

exit "$status"


#!/usr/bin/env bash
set -euo pipefail

usage() {
 cat <<'USAGE'
Usage: ./scripts/check-runtime-drift.sh [soul|policy|prompts|all]
USAGE
}

if [[ $# -ne 1 ]]; then
 usage
 exit 2
fi

SCOPE="$1"
case "$SCOPE" in
 soul|policy|prompts|all) ;;
 *) usage; exit 2 ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"

log() {
 printf '[drift] %s\n' "$1"
}

NO_DRIFT=0
HAS_DRIFT=1
MISUSE=2

check_file() {
 local src="$1"
 local dst="$2"

 if [[ ! -f "$src" ]]; then
 log "ERROR missing governed source: ${src}"
 return $MISUSE
 fi

 if [[ ! -f "$dst" ]]; then
 log "DRIFT missing runtime file: ${dst}"
 return $HAS_DRIFT
 fi

 if cmp -s "$src" "$dst"; then
 log "OK ${dst}"
 return $NO_DRIFT
 fi

 log "DRIFT content differs: ${dst}"
 return $HAS_DRIFT
}

check_soul() {
 check_file "${REPO_ROOT}/profiles/global/SOUL.md" "${HERMES_HOME}/SOUL.md"
}

check_policy() {
 local source_dir="${REPO_ROOT}/policy"
 local target_dir="${HERMES_HOME}/policy"

 if [[ ! -d "$source_dir" ]]; then
 log "ERROR missing governed source directory: ${source_dir}"
 return $MISUSE
 fi

 shopt -s nullglob
 local files=("${source_dir}"/*.md)
 shopt -u nullglob
 if [[ ${#files[@]} -eq 0 ]]; then
 log "ERROR no governed policy markdown files found in ${source_dir}"
 return $MISUSE
 fi

 local rc=$NO_DRIFT
 local src dst
 for src in "${files[@]}"; do
 dst="${target_dir}/$(basename "$src")"
 if ! check_file "$src" "$dst"; then
 local file_rc=$?
 if [[ $file_rc -eq $MISUSE ]]; then
 rc=$MISUSE
 elif [[ $rc -ne $MISUSE ]]; then
 rc=$HAS_DRIFT
 fi
 fi
 done

 return $rc
}

check_prompts() {
 local source_dir="${REPO_ROOT}/prompts"
 local target_dir="${HERMES_HOME}/prompts"

 if [[ ! -d "$source_dir" ]]; then
 log "ERROR missing governed source directory: ${source_dir}"
 return $MISUSE
 fi

 shopt -s nullglob
 local files=("${source_dir}"/*.md)
 shopt -u nullglob
 if [[ ${#files[@]} -eq 0 ]]; then
 log "ERROR no governed prompt markdown files found in ${source_dir}"
 return $MISUSE
 fi

 local rc=$NO_DRIFT
 local src dst
 for src in "${files[@]}"; do
 dst="${target_dir}/$(basename "$src")"
 if ! check_file "$src" "$dst"; then
 local file_rc=$?
 if [[ $file_rc -eq $MISUSE ]]; then
 rc=$MISUSE
 elif [[ $rc -ne $MISUSE ]]; then
 rc=$HAS_DRIFT
 fi
 fi
 done

 return $rc
}

run_scope() {
 case "$1" in
 soul) check_soul ;;
 policy) check_policy ;;
 prompts) check_prompts ;;
 esac
}

log "repo root: ${REPO_ROOT}"
log "runtime home: ${HERMES_HOME}"

if [[ "$SCOPE" != "all" ]]; then
 run_scope "$SCOPE"
 exit $?
fi

overall=$NO_DRIFT
for sub_scope in soul policy prompts; do
 if ! run_scope "$sub_scope"; then
 sub_rc=$?
 if [[ $sub_rc -eq $MISUSE ]]; then
 overall=$MISUSE
 elif [[ $overall -ne $MISUSE ]]; then
 overall=$HAS_DRIFT
 fi
 fi
done

if [[ $overall -eq $NO_DRIFT ]]; then
 log 'all governed runtime files match'
elif [[ $overall -eq $HAS_DRIFT ]]; then
 log 'drift detected'
else
 log 'misuse or missing governed source detected'
fi

exit $overall



# Hermes weekly update policy

governed agent / Hermes-compatible runtime should be checked weekly for updates.

## Governance stance

- Weekly guarded runtime maintenance is approved.
- Runtime schedule uses user systemd (not Hermes cron).
- Guarded auto-update flow must pass preflight/active-work safety checks before running `hermes update`.

## Weekly check should report

- Hermes version.
- Whether update appears available.
- Config migration needs (`hermes config check`, and if needed later `hermes config migrate` by explicit approval).
- Skills status (`hermes skills check`, and if needed later `hermes skills update` by explicit approval).

Use:

```bash
./scripts/hermes-weekly-update-check.sh
```

The script now writes a timestamped log for every run:

- log directory: `<private-workspace-path>`
- log file: `<private-workspace-path>`

The command still streams useful output to stdout for interactive runs.

## Guarded weekly Git maintenance (fork/PR-only)

The weekly maintenance wrapper supports an optional guarded Git mode for Oscar autonomous maintenance work:

```bash
./scripts/hermes-weekly-update-check.sh --git-maintenance
# or: WEEKLY_GIT_MAINTENANCE=1 ./scripts/hermes-weekly-update-check.sh

# dry-run simulation only (no commit/push/PR):
./scripts/hermes-weekly-update-check.sh --git-maintenance --dry-run
# or: WEEKLY_GIT_MAINTENANCE=1 WEEKLY_GIT_MAINTENANCE_DRY_RUN=1 ./scripts/hermes-weekly-update-check.sh
# or: DRY_RUN=1 ./scripts/hermes-weekly-update-check.sh --git-maintenance
```

Policy implemented by the script:

- Oscar may commit/push only to its own fork branch (`origin` by default).
- Oscar may open/update PRs toward Eurobotics upstream when `gh auth status` succeeds.
- Oscar must not merge PRs.
- Oscar must not force-push.
- Oscar must not rewrite upstream history.
- If dirty files are outside the maintenance allowlist, abort.
- If secret scan on candidate/staged changes fails, abort and do not push.
- In dry-run mode, remote/allowlist/secret/PR-target logic is simulated and no commit/push/PR occurs.
- If GitHub auth is unavailable, keep branch and print exact next command (`gh auth status`).

Default allowlisted files for autonomous maintenance commits:

- `docs/hermes-update-policy.md`
- `scripts/hermes-weekly-update-check.sh`
- `docs/operating-model.md`
- `policy/github-safety.md`
- `scripts/agent-hermes-weekly-maintenance.sh`

Notes:

- Runtime backups must never be committed.
- `.env` and credentials must never be committed.
- Raw runtime logs should usually not be committed.
- Maintenance logs/reports may be committed only if explicitly non-secret and intentionally tracked.

## Runtime external dependency gate alignment

- Hermes core update reachability checks must use configured Hermes `origin` remote only.
- Do not hardcode unauthenticated private GitHub HTTPS checks in runtime guards.
- private runtime governance repository fork/upstream reachability checks are non-blocking for Hermes auto-update and only blocking inside explicit git-maintenance/PR workflows.
- Non-interactive runtime scripts must never prompt for GitHub username/password.

## Runtime scheduling model

Hermes runtime maintenance is scheduled via **user systemd timer**, not Hermes cron:

- service: `~/.config/systemd/user/agent-hermes-weekly-maintenance.service`
- timer: `~/.config/systemd/user/agent-hermes-weekly-maintenance.timer`
- schedule: `OnCalendar=Sat *-*-* 01:00:00 Europe/Paris`
- mode: guarded auto-update (`ExecStart=/usr/local/bin/agent-hermes-weekly-maintenance --auto-update`)

Runtime systemd deployment state is authoritative for actual weekly execution. Repository scripts/templates are source material, not proof of deployed runtime state by themselves.

Runtime wrapper command:

- `/usr/local/bin/agent-hermes-weekly-maintenance --check-only`
- `/usr/local/bin/agent-hermes-weekly-maintenance --dry-run --auto-update`
- `/usr/local/bin/agent-hermes-weekly-maintenance --auto-update`

Template sources are stored in repo:

- `scripts/templates/agent-hermes-weekly-maintenance.service`
- `scripts/templates/agent-hermes-weekly-maintenance.timer`
- `scripts/agent-hermes-weekly-maintenance.sh`

## Manual update flow (approved path)

When an update is approved:

```bash
cd <runtime-register-root>
source venv/bin/activate
hermes update
```

After update, run:

```bash
hermes config check
hermes skills check
./scripts/fp-bootstrap.sh --check
```

If gateway is enabled later, verify gateway status after update.


# Hermes weekly maintenance: observability + active-work guard hardening

When maintaining `/usr/local/bin/agent-hermes-weekly-maintenance`, keep the existing safety model but prevent false defers and silent outcomes.

## Guard pattern

Problem observed: `hermes cron list` marks enabled schedules as `[active]`, which is not equivalent to currently running work.

Use strict running-state detection for defer decisions:

- Preferred regex: `\b(running|in_progress|executing|locked)\b`
- Avoid broad `active` matching in defer guards.

## Required defer evidence

If deferring on cron activity:

1. Log at least the first section of cron output for context.
2. Log full raw `hermes cron list` output as defer evidence.
3. Record final classified result as `DEFERRED`.

## Required final classification + operator visibility

Every scheduled run should classify and notify:

- `SUCCESS`: check/update flow completed
- `DEFERRED`: blocked by safety guard
- `FAILED`: preflight/check/update/post-validation error

Notification order:

1. Telegram channel if configured (`TELEGRAM_BOT_TOKEN` + `TELEGRAM_CHAT_ID`, optional thread)
2. Existing SMTP wrapper fallback (`<private-workspace-path>`) if configured

Never print secrets in logs or messages.

Also log notification transport outcome explicitly (`telegram`, `email`, or `none`) so silent defers/failures are operator-visible even when one channel is unavailable.

## Backup integration audit add-on (post-patch, no runtime change)

After observability patching, run a read-only backup-integration audit before proposing any backup coupling changes:

1. Confirm `runtime-backup` repo presence and cleanliness under `<private-workspace-path>`.
2. Confirm runtime backup tool presence (`/usr/local/bin/runtime-backup-tool`).
3. Check whether weekly maintenance script calls backup wrapper directly or only local backup directory logic.
4. Inspect user/system timers and recent journals for backup execution evidence (do not run destructive backup actions).
5. Classify result explicitly as `OK`, `PARTIAL`, `MISSING`, or `NEEDS HUMAN REVIEW`.

If weekly maintenance lacks explicit `runtime-backup-tool` invocation but backup tooling exists, classify as `PARTIAL` and propose smallest optional wiring patch; do not modify backup config without approval.

## Safe validation pattern (no live update)

- Syntax: `bash -n /usr/local/bin/agent-hermes-weekly-maintenance`
- Dry-run: `/usr/local/bin/agent-hermes-weekly-maintenance --dry-run --auto-update`
- Forced DEFER simulation using wrapper override:
 - set `HERMES_BIN` to a small shim that returns `running` for `cron list`
 - run dry-run wrapper
 - verify `DEFERRED`, raw cron evidence logging, and notification attempt logs

## Non-goals

- Do not weaken other guards (gateway/service/skill/disk/reachability checks)
- Do not execute live `hermes update` without explicit approval

## Update checks

Run non-destructive checks first; apply updates only with checkpoint readiness.

## Runtime drift checks

Detect and report policy drift between expected controls and runtime behavior.

## Pre-apply backup checks

Checkpoint before runtime-changing operations.

## Post-maintenance report expectations

Report SUCCESS/DEFERRED/FAILED with rationale and evidence references.

## Hermes-compatible caution

Use current Hermes docs for exact version commands; avoid untested command promises.
