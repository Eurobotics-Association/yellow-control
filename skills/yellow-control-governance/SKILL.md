---
name: yellow-control-governance
description: Classify and gate persistent autonomous-agent actions with Yellow-Control authority, confidentiality, external-access, backup, rollback, and telemetry policy.
version: 0.1.3
author: F.M. Robert Vergnes
license: MIT
platforms:
  - linux
  - macos
  - windows
metadata:
  hermes:
    category: yellow-control
    tags:
      - governance
      - policy-enforcement
      - authority
      - adal
      - cdel
      - esal
      - pcl
      - backup-rollback
      - external-access
      - telemetry
    config:
      - key: yellow_control.external_access_register_path
        description: Path to the private runtime external-access register.
        default: "~/.hermes/yellow-control/registers/external-access-register.yaml"
      - key: yellow_control.governance_decision_log_dir
        description: Directory for private runtime governance decision records.
        default: "~/.hermes/yellow-control/decision-records"
      - key: yellow_control.server_first_contact_dir
        description: Directory for private runtime server-first-contact records.
        default: "~/.hermes/yellow-control/server-first-contact"
---

# yellow-control-governance

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Apply Yellow-Control governance before persistent autonomous-agent actions are executed.

## Invoke when

Use this skill before actions involving:

- administrative or host changes
- delegated execution, containers, runners, or persistent automation
- external services, repositories, APIs, tokens, or webhooks
- confidential data, secrets, logs, publication, or telemetry
- backup, rollback, recovery, or access-custody changes

## Required classification

Before privileged, external, server, confidential, persistent, or repository-affecting work, classify the request with:

- ADAL: Agent Delegated Administration Level
- CDEL: Container Delegated Execution Level
- ESAL: External Service Authority Level
- PCL: Project Confidentiality Level

Unknown authority or confidentiality is not permissive. Defer or block until safely classified.

## Required gates

Before execution, consult the packaged references, then evaluate the applicable gates:

- authority_gate
- classification_scope_gate
- backup_rollback_gate
- external_access_register_gate
- confidentiality_publication_gate
- automation_persistence_gate
- repository_github_gate
- telemetry_gate

For external services, APIs, repositories, servers, webhooks, dashboards, or accounts, consult the external-access register. For new or unknown servers, enforce server-first-contact before mutation. Require backup and rollback evidence before risky privileged, external, persistent, or runtime-governance changes. Separate local checkpoint hygiene from backup archive creation: use native `hermes checkpoints` and govern default pruning with `hermes checkpoints prune --retention-days 30 --max-size-mb 500`; use native `hermes backup` for backup archives; use `hermes update --backup` or `updates.pre_update_backup: true` for Hermes updates. Do not wrap, replace, or reimplement those native mechanisms.

Allow only when every required gate passes. Defer when evidence is incomplete. Block when the request violates policy, would expose secrets or private operational state, self-grants authority, or attempts to bypass governance.

## Output format

Return a concise decision record:

- classification: ADAL, CDEL, ESAL, PCL
- gates_evaluated: applicable gates
- gate_results: pass | defer | block for each gate
- decision: allow | defer | block
- rationale: public-safe reason
- missing_evidence: missing evidence or empty list
- required_approval: owner, security, maintainer, reviewer, recovery custodian, or empty list
- rollback_checkpoint_requirement: checkpoint, rollback owner, stop condition, or reason not applicable
- remediation: next safe step
- telemetry_summary: public-safe decision and outcome summary

## References

Use the skill-local files in `references/` as the packaged operational doctrine. Start with `references/index.md`, then consult the specific reference needed for authority, ADAL, CDEL, ESAL, PCL, gates, backup, rollback, external access, secrets, repository governance, server first contact, onboarding, telemetry, native Hermes backup governance, or repository gating.

Top-level `docs/` files are human-facing mirrors and must not be required for an installed skill to operate.
