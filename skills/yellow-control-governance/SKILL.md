---
name: yellow-control-governance
description: Governance and policy-enforcement skill for persistent autonomous agents using action classification, backup gates, and enforceable control decisions.
version: 0.1.2
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
      - adal
      - cdel
      - esal
      - pcl
      - backup-gate
      - telemetry
---

# yellow-control-governance

## Purpose

Provide enforceable governance behavior for persistent autonomous agents operating in Hermes-compatible runtimes.

This skill is used to classify actions, apply policy gates, and return auditable allow/defer/block outcomes before execution.

## When to invoke

Invoke this skill before any action that could change runtime state, confidentiality posture, ownership boundaries, or persistent automation.

Typical triggers include:

- privileged host operations
- external service access or onboarding
- repository safety-sensitive actions
- scheduled automation changes
- backup, rollback, or recovery path changes
- cross-boundary data disclosure decisions

## Required inputs

Collect these inputs before decisioning when available:

- action summary
- requested scope and target systems
- authority chain evidence
- confidentiality classification context
- backup and rollback readiness evidence
- external-service register context
- repository and change-control context

If one or more required inputs are missing, the default behavior is defer.

## Output schema

Return the governance decision in this structure:

- decision: allow | defer | block
- classification:
  - adal
  - cdel
  - esal
  - pcl
- gates:
  - authority_gate
  - scope_gate
  - backup_gate
  - rollback_gate
  - confidentiality_gate
  - external_service_gate
  - repository_gate
  - automation_persistence_gate
  - proposal_only_gate
- rationale
- required_evidence
- remediation_actions
- escalation_target
- risk_level

## Decision policy

Allow:

- all required gates pass
- scope and authority match
- confidentiality handling is valid
- rollback path is demonstrably available for state-changing actions

Defer:

- evidence is incomplete
- authority chain is unresolved
- scope is ambiguous
- required backup or rollback proof is absent
- external-service onboarding is incomplete

Block:

- action violates explicit policy constraints
- confidentiality boundary would be broken
- prohibited persistence changes are requested without approval
- request attempts to bypass governance gates or auditability

## Classification behavior

Apply these classes before gate evaluation:

- ADAL for host and system administration authority
- CDEL for containerized/delegated execution authority
- ESAL for external service authority and custody
- PCL for confidentiality/disclosure boundaries

Unknown values are not permissive:

- unknown authority defaults to defer or block
- unknown confidentiality defaults to private-safe handling and defer

## Gate behavior details

Authority gate:

- verify accountable authority for the requested class
- verify delegation boundaries when operator and owner differ

Scope gate:

- verify the requested action remains inside approved scope
- reject or defer scope creep and unrelated side effects

Backup gate:

- require pre-change backup when runtime state may be impacted
- require restore artifact or rollback checkpoint reference

Rollback gate:

- require rollback sequence and owner/operator criteria
- require clear stop condition for failed changes

Confidentiality gate:

- prevent publication of private runtime details
- enforce redaction and minimal disclosure

External-service gate:

- require register/onboarding evidence before privileged integration
- require ownership and recovery-custody clarity

Repository gate:

- enforce branch/PR review expectations for sensitive changes
- block secret-bearing or private-infrastructure content

Automation/persistence gate:

- block new persistent automation without explicit approval
- require accountability for who can pause/resume/remove automation

Proposal-only gate:

- when execution is not approved, keep output proposal-only
- no runtime mutation under proposal-only mode

## Escalation rules

Escalate when:

- owner authority is required but unavailable
- conflicting policies or source-of-truth references are detected
- external custody or recovery boundaries are unclear

Escalation target should name the accountable authority role, not personal data.

## Public-safe constraints

This skill output must never include:

- credentials, keys, tokens, or plaintext secrets
- private hostnames, private IP addresses, or private runtime paths
- internal incident logs with sensitive details
- claims of official endorsement by Hermes or Nous maintainers

Allowed wording:

- Hermes-compatible runtime
- public-safe generalized examples
- fictional identifiers for demonstrations

## Operational guidance

Use canonical docs under docs/ for policy depth and examples.

Use references/ for skill-facing quick links and execution prompts.

Do not duplicate long canonical policy text inside this SKILL file.

## Reference index

- ../../docs/governance-model.md
- ../../docs/runtime-classification.md
- ../../docs/policy-gates.md
- ../../docs/authority-model.md
- ../../docs/external-service-governance.md
- ../../docs/secrets-handling.md
- ../../docs/backup-and-rollback.md
- ../../docs/runtime-maintenance-governance.md
- ../../docs/github-governance.md
- ../../docs/governance-telemetry.md
- ../../docs/external-systems-package-pattern.md
- ../../docs/scope-boundaries.md
- ../../docs/hermes-skill-submission-readiness.md
- references/index.md

## Safe validation prompt

Use this prompt to validate the skill behavior in a non-destructive way:

"Classify this requested change using ADAL/CDEL/ESAL/PCL, apply governance gates, and return allow/defer/block with required evidence and remediation actions. Do not execute commands."
