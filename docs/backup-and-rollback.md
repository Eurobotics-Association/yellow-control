# Backup and rollback governance

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Backup and rollback governance ensures that governed actions can be stopped, reversed, or recovered when they affect persistent state.
It applies before risky external access, privileged administration, first external server contact, runtime governance changes, repository automation, package installation, service changes, and recovery-custody changes.
A backup is not useful unless the restoration path and recovery owner are known.
A rollback plan is not useful unless it has a trigger, stop condition, and validation method.

## Backup gate

The backup gate asks whether a suitable checkpoint exists before mutation.
Required evidence includes checkpoint identifier, target category, scope, owner role, date, validation method, and recovery custody reference.
The checkpoint must be appropriate for the risk: a repository branch may be enough for documentation work, while service or host changes require a verified system or configuration recovery path.
Evidence must be public-safe and must not expose private storage locations, unlock material, or real target details.
Missing backup evidence causes defer for ADAL-2, CDEL-2, ESAL-2, or higher work.
High-impact actions with no possible backup are blocked unless an approved emergency procedure exists.

## Rollback gate

The rollback gate asks whether the agent knows how to return to a safe state.
Required evidence includes rollback owner, ordered rollback steps, stop condition, trigger condition, validation checks, maximum safe execution window, and escalation path.
Rollback must be realistic for the requested change.
Rollback must not require credentials that are unavailable to the recovery custodian.
Rollback must not depend on the agent retaining uncontrolled privileged access.
If rollback changes access custody, classify that rollback path with ADAL and ESAL too.

## Before risky action

Before package installation, service restart, configuration update, webhook creation, repository setting change, external API mutation, or privileged wrapper use, verify backup and rollback evidence.
For low-risk documentation edits, a Git commit or branch may serve as checkpoint.
For service or host changes, require a stronger checkpoint and validation.
For secret or identity changes, require recovery-custody approval and revocation plan.
For destructive work, defer or block until emergency or owner-approved procedure exists.

## Before first external server contact

First contact can create risk even before mutation.
The server may be hostile, misidentified, compromised, or outside scope.
Before contact, record a public-safe checkpoint for the agent state, the intended command class, and the stop path.
Confirm the external-access register entry or draft entry.
Confirm that credentials can be revoked if the target is wrong.
Confirm that no secrets or private local data will be sent during discovery.
Confirm that evidence collection will summarize results rather than capture raw sensitive output.

## Before runtime governance change

Runtime governance changes include changes to skill files, wrappers, tool access, environment passthrough, credential-file mounting, persistent jobs, and policy gates.
These changes can affect future authority decisions.
Require a repository checkpoint, review path, rollback steps, and telemetry.
Do not make runtime governance changes that broaden scope without explicit approval.
Do not add external package implementation details as policy unless they are necessary references.

## Evidence template

| Field | Required content |
| --- | --- |
| checkpoint_id | Public-safe identifier for backup, branch, snapshot, or restore point. |
| target_category | Redacted category such as repository, server, service, account, or runtime. |
| scope | What is protected and what is not protected. |
| created_at | Date or timestamp in public-safe format. |
| owner_role | Role accountable for restore approval. |
| recovery_custody_ref | Public-safe reference to recovery custody, not raw recovery material. |
| verification | How restore viability was checked. |
| rollback_steps_ref | Public-safe reference or inline safe summary of rollback steps. |
| stop_condition | Condition that stops execution before further harm. |
| validation_checks | How success or rollback success will be verified. |

## Failure handling

If a command fails before mutation, stop and report the failure.
If a command fails after partial mutation, stop further mutation and evaluate rollback trigger.
If rollback succeeds, record the outcome and validation.
If rollback fails, escalate to recovery custodian and avoid improvising privileged fixes.
If secret exposure is suspected, stop output, preserve safe evidence, and follow secret exposure handling.
If remote behavior appears hostile, disconnect or cease interaction according to the approved stop path.

## Rollback readiness checklist

- checkpoint exists and matches target;
- recovery owner is known;
- credential revocation path is known when external access is used;
- rollback steps are ordered and bounded;
- stop condition is clear;
- validation checks are defined;
- telemetry can be recorded safely;
- no secret or private operational data is included in public records.
