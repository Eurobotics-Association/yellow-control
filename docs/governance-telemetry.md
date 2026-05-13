# Governance telemetry

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Governance telemetry records why an action was allowed, deferred, or blocked without storing secrets or private operational state.

## Minimal telemetry record

| Field | Description |
| --- | --- |
| decision_id | Stable public-safe identifier. |
| timestamp | Decision time. |
| action_summary | Redacted summary of requested action. |
| classification | ADAL, CDEL, ESAL, and PCL values. |
| gates | Pass, defer, or block result for each required gate. |
| decision | allow, defer, or block. |
| rationale | Short public-safe reason. |
| required_evidence | Missing or required evidence, if deferred. |
| remediation | Next safe step. |
| outcome | Executed, not executed, rolled back, or superseded. |

## Telemetry rules

- Record decisions before execution for governed actions.
- Record outcomes after execution or rollback.
- Do not store credentials, private addresses, private paths, or sensitive logs.
- Prefer role names over personal or private operational identifiers.
