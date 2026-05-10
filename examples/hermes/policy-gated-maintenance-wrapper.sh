#!/usr/bin/env bash
set -euo pipefail

# Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
# Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

MODE="dry-run"
if [[ "${1:-}" == "--live" ]]; then
  MODE="live"
fi

TIMESTAMP="$(date -u +%Y%m%d-%H%M%S)"
WORKDIR="${YELLOW_CONTROL_WORKDIR:-$(pwd)}"
STATE_DIR="${WORKDIR}/.yellow-control-state"
REPORT_DIR="${WORKDIR}/.yellow-control-reports"
mkdir -p "${STATE_DIR}" "${REPORT_DIR}"

BACKUP_FLAG="${STATE_DIR}/backup-ok.flag"
REPORT_FILE="${REPORT_DIR}/governance-report-${TIMESTAMP}.json"

requested_action="hermes-maintenance-update"
classification='{"ADAL":"required","ESAL":"none","PCL":"public-docs"}'

authority_gate="pass"
scope_gate="pass"
backup_gate="pass"

action_result="noop"
decision="allow"
rationale="dry-run mode"

if [[ "${MODE}" == "live" ]]; then
  rationale="live mode requested"
  if [[ ! -f "${BACKUP_FLAG}" ]]; then
    backup_gate="fail"
    decision="defer"
    rationale="missing mandatory backup checkpoint"
  fi
fi

if [[ "${MODE}" == "dry-run" ]]; then
  echo "[yellow-control] DRY RUN: no live update executed"
else
  if [[ "${decision}" == "allow" ]]; then
    echo "[yellow-control] LIVE: backup gate passed; running example maintenance step"
    # Example-only placeholder; replace with project-specific command.
    action_result="simulated-live-update"
  else
    echo "[yellow-control] LIVE: deferred due to backup gate"
    action_result="deferred"
  fi
fi

cat > "${REPORT_FILE}" <<JSON
{
  "timestamp_utc": "${TIMESTAMP}",
  "mode": "${MODE}",
  "requested_action": "${requested_action}",
  "classification": ${classification},
  "gate_results": {
    "authority_gate": "${authority_gate}",
    "scope_gate": "${scope_gate}",
    "backup_gate": "${backup_gate}"
  },
  "decision": "${decision}",
  "rationale": "${rationale}",
  "result": "${action_result}",
  "notification": "placeholder: send governance report to approved channel"
}
JSON

echo "[yellow-control] governance report: ${REPORT_FILE}"
