# Governance telemetry

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Governance telemetry records Yellow-Control decisions, gates, evidence references, and outcomes in a public-safe form.
It lets a human reviewer understand why an agent allowed, deferred, or blocked a governed action.
Telemetry is not a secret store and not a raw log archive.
It must preserve accountability without exposing private operational state.

## Public template and private runtime records

The packaged public template lives at `skills/yellow-control-governance/templates/governance-decision-record.template.yaml`. It provides a public-safe YAML shape for decision records using fictional placeholders.

Live governance decision records are private runtime state. By default, Hermes skill config declares `yellow_control.governance_decision_log_dir` as `~/.hermes/yellow-control/decision-records`, and operators may configure another private directory. Live decision records, private evidence references that reveal sensitive custody, private runtime paths, raw logs, real target identifiers, and confidential operational notes must not be committed to the public repository or packaged into the public skill.

Telemetry published in this repository must be limited to public-safe summaries and schema examples. Runtime telemetry should retain enough private evidence for accountable review without exposing secrets to the model or public docs.

## Decision record fields

A decision record should include a public-safe decision identifier.
It should include task summary.
It should include target category.
It should include ADAL, CDEL, ESAL, and PCL classification.
It should include gates evaluated.
It should include gate result for each gate.
It should include final decision.
It should include missing evidence.
It should include required approval.
It should include rollback or checkpoint requirement.
It should include telemetry outcome summary.

## Classification recording

Record the highest plausible ADAL when impact is unclear.
Record CDEL when containers, runners, sockets, or delegated execution are involved.
Record ESAL when an external service, server, API, repository, account, or webhook is involved.
Record PCL for information read, written, transmitted, logged, or published.
Do not record raw private data as classification evidence.
Use references such as “register entry exists” or “backup evidence reference present.”

## Gate recording

For each core gate, record pass, defer, block, or not applicable.
Core gates are authority, classification and scope, backup and rollback, external access register, confidentiality and publication, automation and persistence, repository or GitHub when applicable, and telemetry.
For defer, record what evidence is missing.
For block, record the policy reason.
Do not include secret values, private host details, raw logs, or hidden operational paths.

## Evidence references

Evidence references should be public-safe labels.
Examples include branch name when public-safe, checkpoint identifier, register entry identifier, review identifier, approval role, or first-contact summary reference.
Do not include private storage locations, credential paths, raw account identifiers, or recovery channel details.
If evidence itself is private, record that a private evidence reference exists and identify the responsible role.

## Missing approval

When approval is missing, telemetry should state which role is missing.
Examples: owner authority missing, security authority missing, recovery custodian missing, maintainer review missing, or merge authority missing.
Do not name private individuals unless the repository policy explicitly permits public naming.
A missing approval usually produces defer.
A request to bypass missing approval produces block.

## Rollback requirement

Telemetry should record whether a checkpoint is required, whether it exists, who owns rollback, and what validation class applies.
Do not record private backup locations or restore secrets.
If no rollback can exist, record whether an emergency procedure is approved.
If rollback is missing for a risky action, the decision is defer or block.

## Backup and readiness telemetry

When a backup or checkpoint gate applies, telemetry must record whether the event concerns local checkpoint pruning, backup archive creation, update backup, restore/import, or an owner-approved equivalent.
For local rollback/checkpoint hygiene, use public-safe mechanism labels such as `hermes checkpoints`, `hermes checkpoints prune --retention-days 30 --max-size-mb 500`, and configured runtime values when they differ.
For Hermes backup archives, use public-safe mechanism labels such as `hermes backup`, `hermes backup -o <path>`, `hermes backup --quick --label <name>`, or owner-approved equivalent.
For Hermes updates, use public-safe mechanism labels such as `hermes update --backup` or `updates.pre_update_backup: true`.
Telemetry must record private target reference only, timestamp, pass/defer/block/fail result, snapshot identifier, archive identifier, checkpoint status reference, or path reference, restore metadata or manifest reference if available, archive-retention mechanism reference when archives are produced, next required backup, pruning check, retention review, or restore test, and remediation on failure.
Do not include backup archive contents, checkpoint store contents, tokens, secrets, keys, private hostnames, private addresses, credential paths, private runtime paths, or sensitive logs.
Telemetry may record checkpoint-pruning status and backup-archive-retention status as governance findings, but Yellow-Control does not implement pruning or deletion logic.
If no archive-retention mechanism exists, telemetry must report defer for new recurring backup-producing automation until retention is approved.
If storage is near an owner-defined threshold, telemetry must report defer or block for non-emergency backup-producing actions.

## Telemetry readiness

Before a governed action, verify that telemetry can be recorded safely.
If the configured telemetry channel is unavailable, classify whether the action can proceed with local private decision records or must defer.
High-impact actions should defer when no safe decision record, backup result, rollback owner, or remediation record can be captured.
Telemetry readiness does not authorize mutation by itself; it only confirms the governance outcome can be reviewed.

## Final decision

The final decision is allow, defer, or block.
Allow records why the action is within scope.
Defer records the next safe evidence or approval step.
Block records the violated policy and a safe remediation path.
All three decisions should be useful to a human reviewer.
The agent must not execute mutation for defer or block.

## No secrets in telemetry

Telemetry must not include credentials, private keys, recovery codes, session material, secret-bearing logs, private hostnames, private addresses, private runtime paths, or raw confidential data.
If a secret appears in telemetry draft, stop and redact before publishing.
If a secret was already published, follow suspected exposure handling.
Use role names and evidence references instead of raw details.

## Minimal record template

Use `skills/yellow-control-governance/templates/governance-decision-record.template.yaml` as the packaged YAML starter. The abbreviated shape is:

```yaml
decision_id: "public-safe-id"
task_summary: "public-safe summary"
target_category: "repository | server | service | local | other"
classification:
  adal: ""
  cdel: ""
  esal: ""
  pcl: ""
gates_evaluated: []
gate_results: {}
decision: "allow | defer | block"
missing_evidence: []
required_approval: []
rollback_checkpoint_requirement: ""
telemetry_summary: "public-safe outcome"
```
