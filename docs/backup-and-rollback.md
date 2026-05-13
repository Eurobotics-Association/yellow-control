# Backup and rollback governance

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Backup and rollback controls protect persistent systems from irreversible or hard-to-debug agent changes.

## Backup checkpoint

A backup checkpoint is required before ADAL-2, CDEL-2, ESAL-2, or higher actions that can change persistent state.

| Field | Required content |
| --- | --- |
| checkpoint_id | Public-safe identifier for the backup or restore point. |
| target | Redacted target category, not private infrastructure detail. |
| owner_role | Accountable role for restore approval. |
| created_at | Date or timestamp in a public-safe format. |
| verification | How restore viability was checked. |

## Rollback plan

A rollback plan must include:

- trigger condition for rollback
- stop condition for failed execution
- ordered rollback steps
- recovery owner role
- validation checks after rollback
- telemetry record for outcome

## Default posture

If the agent cannot prove backup and rollback readiness, the decision is defer. If the requested action is high-impact and no rollback can exist, the decision is block unless a separate emergency governance procedure approves it.
