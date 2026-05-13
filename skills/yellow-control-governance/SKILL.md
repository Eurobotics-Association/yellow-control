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

Classify every governed request with:

- ADAL: administrative delegation and authority level
- CDEL: containerized delegated execution level
- ESAL: external service authority level
- PCL: privacy and confidentiality level

Unknown authority or confidentiality is not permissive. Defer or block until safely classified.

## Required gates

Evaluate these gates before execution:

- authority_gate
- scope_gate
- backup_gate
- rollback_gate
- confidentiality_gate
- external_access_gate
- repository_gate
- persistence_gate
- telemetry_gate

Allow only when every required gate passes. Defer when evidence is incomplete. Block when the request violates policy, would expose secrets or private operational state, or attempts to bypass governance.

## Output format

Return a concise decision record:

- decision: allow | defer | block
- classification: ADAL, CDEL, ESAL, PCL
- gate_results: pass | defer | block for each required gate
- rationale: public-safe reason
- required_evidence: missing evidence or empty list
- rollback: checkpoint, rollback owner, rollback steps, or reason not applicable
- remediation: next safe step
- telemetry: public-safe decision identifier or proposed record

## References

Use the files in `references/` for quick links to canonical policy documents.
