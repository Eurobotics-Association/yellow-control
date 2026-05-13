# Authority model

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

The authority model defines who may approve, delegate, execute, review, or recover governed agent actions. It applies before any runtime mutation or external-access action.

## Authority roles

| Role | Responsibility | May approve |
| --- | --- | --- |
| Owner authority | Accountable owner of the affected system, repository, or service. | Scope, risk acceptance, recovery custody, and destructive changes. |
| Operator authority | Human or automation actor performing the approved action. | Execution only inside delegated scope. |
| Security authority | Custodian for secrets, identity, confidentiality, and recovery channels. | Secret handling, privileged access, and disclosure controls. |
| Reviewer authority | Independent reviewer for sensitive policy or repository changes. | Review completion, not owner approval. |

## Evidence requirements

| Evidence | Required when | Gate affected |
| --- | --- | --- |
| Owner approval | Action changes persistent state, access, or custody. | authority_gate |
| Delegation boundary | Operator differs from owner or action runs through automation. | authority_gate |
| Scope statement | Any governed action is requested. | scope_gate |
| Recovery owner | Action can break access, identity, service continuity, or data integrity. | rollback_gate |
| Confidentiality classification | Action reads, writes, transmits, logs, or publishes data. | confidentiality_gate |

## Default posture

Missing or ambiguous authority is never permissive. Defer until the accountable role and delegation boundary are documented. Block requests that attempt to bypass owner, security, or reviewer controls.
