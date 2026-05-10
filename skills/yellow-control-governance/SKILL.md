---
name: yellow-control-governance
description: Governance and policy-enforcement skill for persistent autonomous agents using action classification, backup gates, and enforceable control decisions.
version: 0.1.1
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

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

# yellow-control-governance

## Overview

Yellow-Control governance is a Hermes-compatible control skill for persistent autonomous agent operations where policy gates must be explicit, enforceable, and auditable.

## When to invoke

Invoke before:

- privileged, destructive, or persistent runtime actions;
- external-service onboarding or access expansion;
- runtime configuration, automation, or deployment changes;
- disclosure decisions involving non-public project material.

## Core procedure

1. Classify the action with ADAL, CDEL, ESAL, and PCL context.
2. Evaluate mandatory gates: authority, scope, backup readiness, confidentiality.
3. If live change is requested, require a valid backup and rollback checkpoint before execution.
4. If any required gate fails, block or defer and report explicit reasons.
5. Emit governance telemetry with decision, gate states, and required next action.

## Enforcement policy

- Do not treat policy as advisory when runtime enforcement is required.
- Unknown authority is treated as no authority.
- Missing backup checkpoint blocks live core-change execution.
- Missing confidentiality classification defaults to private handling until resolved.

## Reporting output (minimum)

- requested_action
- classification_summary
- gate_results
- decision (`allow`, `defer`, `block`)
- rationale
- required_follow_up

## References

- `references/policy-gates.md`
- `references/adal-esal-pcl.md`
- `references/backup-and-rollback.md`
- `references/governance-telemetry.md`
