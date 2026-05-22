# Backup and rollback governance

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Backup and rollback governance ensures that governed actions can be stopped, reversed, or recovered when they affect persistent state.
It applies before risky external access, privileged administration, first external server contact, runtime governance changes, repository automation, package installation, service changes, and recovery-custody changes.
A backup is not useful unless the restoration path and recovery owner are known.
A rollback plan is not useful unless it has a trigger, stop condition, and validation method.
Yellow-Control governs backup readiness; it does not implement backup tooling.

## Native Hermes backup boundary

Hermes provides native mechanisms for local checkpoint hygiene, backup archives, imports, and update backups.
Use `hermes checkpoints` for local rollback/checkpoint status and `hermes checkpoints prune --retention-days 30 --max-size-mb 500` as the default Yellow-Control governance recommendation for local checkpoint pruning.
Use `hermes backup` for Hermes backup archives, `hermes backup -o <path>` for an owner-approved output path, and `hermes backup --quick --label <name>` when a quick labeled snapshot is appropriate for the risk class.
Hermes backup archives are restored with `hermes import <zipfile>`.
For Hermes updates, use `hermes update --backup`, or configure `updates.pre_update_backup: true` in Hermes config when owner policy requires a full backup before every update.
Consult `hermes-backup-snapshot-policy.md` for Yellow-Control's Hermes-specific backup governance.

Do not create a backup command under Yellow-Control, wrapper script, cron job, or systemd timer.
Do not replace native Hermes backup, checkpoint pruning, import, or update backup behavior.
Do not store Hermes backup archives or raw `~/.hermes/checkpoints/` shadow stores in this public repository or in the packaged public skill.


## Autonomy and local enforcement layering

Yellow-Control decides and records whether backup evidence is required for a requested action.
Owner-approved local policy gates and wrappers may enforce backup/readiness behavior on the target runtime.
Wrappers must remain narrow in scope and gate only their own known mutation flows.
Local-only backup is degraded break-glass evidence unless explicitly owner-approved with logged reason.
Public Yellow-Control must not ship private backup scripts, private backup repository paths, or runtime-private enforcement artifacts.

## Checkpoint pruning is not backup archive retention

`hermes checkpoints` manages the local `~/.hermes/checkpoints/` shadow store used by `/rollback`.
Checkpoint pruning is local rollback hygiene, not backup archive retention.
Hermes backup archives exclude `checkpoints/`, so pruning the checkpoint store does not retain or rotate backup archives.
GitHub and GitLab backup repositories are for backup archives, manifests, and metadata, not raw checkpoint shadow stores.

Backup archive retention is mandatory because unbounded archive growth can fill disk, artifact storage, or repository storage.
If no retention mechanism exists, Yellow-Control must defer new recurring backup-producing automation until retention is approved.
If storage is near an owner-defined threshold, Yellow-Control must defer or block non-emergency backup-producing actions and report through telemetry.

## Default Yellow-Control backup hygiene

Default Yellow-Control governance recommends local checkpoint pruning with `hermes checkpoints prune --retention-days 30 --max-size-mb 500`, monthly full Hermes backup archive creation to a private approved target, event-triggered native Hermes backup before a new external server, high-impact service, runtime governance change, installed governance skill change, and risky privileged action, plus `hermes update --backup` or `updates.pre_update_backup: true` for Hermes updates.
Backup archive retention must be approved before recurring backup-producing automation is allowed.

## Backup gate

The backup gate asks whether a suitable checkpoint exists before mutation.
Required evidence includes checkpoint identifier, target category, scope, owner role, date, validation method, and recovery custody reference.
For Hermes runtime state, suitable evidence should identify `hermes backup`, `hermes update --backup`, `updates.pre_update_backup: true`, or an owner-approved equivalent mechanism.
The checkpoint must be appropriate for the risk: a repository branch may be enough for documentation work, while service, host, Hermes runtime, or skill changes require a verified system, configuration, or Hermes-aware recovery path.
Evidence must be public-safe and must not expose private storage locations, unlock material, or real target details.
Missing backup evidence causes defer for ADAL-2, CDEL-2, ESAL-2, or higher work.
High-impact actions with no possible backup are blocked unless an approved emergency procedure exists.

## Backup-required moments

Require native Hermes backup or an owner-approved equivalent before:

- monthly full Hermes backup archive or scheduled checkpoint review;
- Hermes update;
- connection to a new external server;
- onboarding a new high-impact external service;
- runtime governance file changes;
- installed governance skill changes;
- successful first-contact onboarding when a new baseline is established.

Repository-only documentation edits may use a branch, commit, or pull request as a checkpoint when Hermes runtime state is not affected.
If the action changes Hermes configuration, auth, sessions, profiles, skills, memories, pairing, gateways, or long-lived automation, require Hermes-aware backup evidence.

## Backup target and sensitivity

Preferred private targets for backup archives, manifests, and metadata are a private repository named `hermes-backup` or `<hermes-instance-name>-backup`, an owner-approved private backup or artifact store, or a temporary private local directory only if no remote target exists yet.
Never store Hermes backups in public Yellow-Control or any public repository.
Never use GitHub or GitLab backup repositories for raw `~/.hermes/checkpoints/` shadow stores.
Treat Hermes backups as sensitive runtime artifacts because they may contain configuration, authentication state, sessions, profiles, skills, memories, pairing data, and credentials depending on runtime behavior and local configuration.
If using GitHub or GitLab, the target repository must be private and access-controlled.
Consider encryption or restricted artifact storage for backups containing secrets or recovery material.
Backup archives must have an owner-approved retention mechanism through private repository lifecycle, artifact storage lifecycle, approved maintenance process, or explicit approved pruning.

## Existing backup mechanism rule

If a custom backup mechanism, backup skill, cron job, systemd timer, or external backup system already exists, detect and report it.
Do not replace it silently.
Ask the accountable human authority whether to keep both mechanisms, use native Hermes backup as primary, use the existing mechanism as a storage or retention layer, or retire the custom mechanism.
Default preference is native Hermes backup first, with custom automation only when explicitly required by the owner.

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
For service, host, or Hermes runtime changes, require a stronger checkpoint and validation.
For secret or identity changes, require recovery-custody approval and revocation plan.
For destructive work, defer or block until emergency or owner-approved procedure exists.

## Before first external server contact

First contact can create risk even before mutation.
The server may be hostile, misidentified, compromised, or outside scope.
Before contact, record a public-safe checkpoint for the agent state, the intended command class, and the stop path.
For a Hermes runtime that will perform the contact, require native Hermes backup or an owner-approved equivalent unless the owner explicitly classifies the contact as lower risk.
Confirm the external-access register entry or draft entry.
Confirm that credentials can be revoked if the target is wrong.
Confirm that no secrets or private local data will be sent during discovery.
Confirm that evidence collection will summarize results rather than capture raw sensitive output.

## Before runtime governance change

Runtime governance changes include changes to skill files, wrappers, tool access, environment passthrough, credential-file mounting, persistent jobs, and policy gates.
These changes can affect future authority decisions.
Require a repository checkpoint, Hermes-aware backup when runtime state is affected, review path, rollback steps, and telemetry.
Do not make runtime governance changes that broaden scope without explicit approval.
Do not add external package implementation details as policy unless they are necessary governance references.

## External package governance

External package management is an implementation layer, not a Yellow-Control backup layer.
When a package, connector, CLI, or SDK is needed for backup storage, artifact upload, SSH, repository automation, or service access, classify the package action separately with ADAL, CDEL, ESAL, PCL, backup, rollback, and telemetry.
Yellow-Control may govern whether package use is allowed, deferred, or blocked, but it must not implement target-specific package installation or replacement backup tooling.

## Retention governance

Backup archive retention is mandatory and governance-only.
Do not implement automated deletion logic in Yellow-Control.
Keep weekly snapshots for 3 months when weekly snapshots are produced.
After 3 months, keep the first snapshot of each month until 12 months old.
After 12 months, keep the first official calendar-quarter snapshot per quarter for up to 3 years.
Keep incident, legal, or security hold snapshots separately when explicitly marked.
Never delete the only known-good restore point.
Deletion requires an owner-approved retention policy or explicit approval.

## Weekly verification

Weekly verification should check and report that `hermes checkpoints` is available, checkpoint pruning exists and is periodically run, the latest monthly or event-triggered backup archive exists when required, the backup target is private and writable or usable, restore metadata or a manifest exists, backup archive retention exists, archive growth is not unbounded, storage is not near an owner-defined threshold, and failures are reported through the configured telemetry channel.
Weekly verification must not create cron jobs, systemd timers, shell scripts, backup implementations, checkpoint-pruning implementations, or deletion routines.

## Evidence template

| Field | Required content |
| --- | --- |
| checkpoint_id | Public-safe identifier for backup, branch, snapshot, or restore point. |
| mechanism | Public-safe command or mechanism label, such as `hermes checkpoints prune --retention-days 30 --max-size-mb 500`, `hermes backup`, `hermes backup -o <path>`, `hermes backup --quick --label <name>`, `hermes update --backup`, or owner-approved equivalent. |
| target_category | Redacted category such as repository, server, service, account, or runtime. |
| scope | What is protected and what is not protected. |
| created_at | Date or timestamp in public-safe format. |
| owner_role | Role accountable for restore approval. |
| recovery_custody_ref | Public-safe reference to recovery custody, not raw recovery material. |
| verification | How restore viability was checked. |
| manifest_ref | Public-safe restore metadata or manifest reference if available. |
| archive_retention_ref | Public-safe reference to the approved archive-retention mechanism when backup archives are produced. |
| rollback_steps_ref | Public-safe reference or inline safe summary of rollback steps. |
| stop_condition | Condition that stops execution before further harm. |
| validation_checks | How success or rollback success will be verified. |

## Backup telemetry

Backup telemetry must include the mechanism type, command or setting used, private target reference only, timestamp, pass/defer/block/fail result, snapshot identifier, archive identifier, checkpoint status reference, or path reference, restore metadata or manifest reference if available, archive-retention mechanism reference when archives are produced, next required backup, pruning check, retention review, or restore test, and remediation on failure.
Telemetry must not include backup archive contents, checkpoint store contents, tokens, secrets, keys, private hostnames, private addresses, credential paths, private runtime paths, or sensitive logs.

## Failure handling

If a command fails before mutation, stop and report the failure.
If a command fails after partial mutation, stop further mutation and evaluate rollback trigger.
If rollback succeeds, record the outcome and validation.
If rollback fails, escalate to recovery custodian and avoid improvising privileged fixes.
If secret exposure is suspected, stop output, preserve safe evidence, and follow secret exposure handling.
If remote behavior appears hostile, disconnect or cease interaction according to the approved stop path.

## Rollback readiness checklist

- native Hermes backup or owner-approved equivalent exists when Hermes runtime state is at risk;
- checkpoint pruning is documented separately from backup archive retention;
- checkpoint exists and matches target;
- private backup target is access-controlled;
- backup archive retention is approved when backup archives are produced;
- restore metadata or manifest reference exists when available;
- recovery owner is known;
- credential revocation path is known when external access is used;
- rollback steps are ordered and bounded;
- stop condition is clear;
- validation checks are defined;
- telemetry can be recorded safely;
- no secret or private operational data is included in public records.
