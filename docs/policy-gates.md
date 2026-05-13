# Policy gates

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Policy gates convert classification evidence into an enforceable allow, defer, or block decision.

## Gate table

| Gate | Pass condition | Defer condition | Block condition |
| --- | --- | --- | --- |
| authority_gate | Accountable owner and delegation are documented. | Authority chain is incomplete. | Request bypasses required authority. |
| scope_gate | Action matches approved scope and target. | Scope is ambiguous or too broad. | Action includes unrelated or hidden side effects. |
| backup_gate | Required checkpoint exists before mutation. | Backup evidence is missing or unverified. | Action rejects required backup controls. |
| rollback_gate | Rollback steps, owner, and stop condition exist. | Rollback is incomplete. | No viable rollback exists for high-impact work. |
| confidentiality_gate | PCL handling is valid for the destination. | Classification or redaction is incomplete. | Secret or private content would be exposed. |
| external_access_gate | ESAL registration and custody are complete. | External-access record is incomplete. | Integration would use unapproved custody or scope. |
| repository_gate | Branch, review, and public-safety checks are satisfied. | Review or validation is pending. | Secrets or private operational content would be committed. |
| persistence_gate | Persistent automation has explicit owner approval. | Persistence lifecycle is unclear. | Unapproved recurring or self-preserving automation is requested. |
| telemetry_gate | Decision and outcome telemetry can be recorded safely. | Telemetry fields are incomplete. | Request requires unauditable execution. |

## Decision rules

- Allow only when all required gates pass.
- Defer when evidence is missing but the request can become compliant.
- Block when the request violates policy, breaks confidentiality, or attempts to bypass governance.
