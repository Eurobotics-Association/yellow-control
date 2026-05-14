# Hermes backup and snapshot policy

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

This reference defines Yellow-Control governance for Hermes local checkpoints, Hermes backup archives, update backups, rollback readiness, retention, and verification.
It is governance only.
Yellow-Control does not implement, wrap, schedule, rotate, prune, or replace native Hermes mechanisms.

## Native Hermes mechanisms

Hermes provides distinct native mechanisms with different purposes:

| Mechanism | Native command or setting | Governance purpose |
| --- | --- | --- |
| Local rollback checkpoint store | `hermes checkpoints` | Inspect local checkpoint status for the shadow store used by `/rollback`. |
| Local checkpoint pruning | `hermes checkpoints prune --retention-days 30 --max-size-mb 500` | Default Yellow-Control governance recommendation for local checkpoint hygiene. |
| Hermes backup archive | `hermes backup` | Create a private backup zip archive of Hermes configuration, skills, sessions, and data. |
| Directed backup output | `hermes backup -o <path>` | Write a backup archive to an owner-approved private target path. |
| Quick labeled backup | `hermes backup --quick --label <name>` | Create a quick labeled snapshot when appropriate for the risk class. |
| Backup restore | `hermes import <zipfile>` | Restore an approved Hermes backup archive. |
| Update backup | `hermes update --backup` | Take a full pre-update backup before a Hermes update. |
| Default update backup setting | `updates.pre_update_backup: true` | Make full pre-update backup the default update behavior for high-value profiles. |

Hermes backup archives exclude `checkpoints/`.
Do not treat a backup archive as a copy of the local checkpoint shadow store.
Do not treat checkpoint pruning as backup archive retention.

## Checkpoint pruning is not backup archive retention

`hermes checkpoints` manages `~/.hermes/checkpoints/`, the local shadow store used by `/rollback`.
Checkpoint pruning is local rollback/checkpoint hygiene.
The default Yellow-Control governance recommendation is:

```sh
hermes checkpoints prune --retention-days 30 --max-size-mb 500
```

The retention days and size values are runtime-configurable by risk, storage size, profile value, and owner policy.
Yellow-Control should check that checkpoint pruning exists and is periodically run, but it must not implement pruning itself.
Yellow-Control must not store raw `~/.hermes/checkpoints/` shadow stores in GitHub, GitLab, artifact stores, or public Yellow-Control repositories.

Hermes backup archive retention is separate.
Backup archives created by `hermes backup` or `hermes backup -o <path>` need a Yellow-Control-approved or owner-approved retention mechanism in the private target where those archives are stored.
GitHub or GitLab backup repositories are for backup archives, manifests, and public-safe metadata, not raw checkpoint shadow stores.

## Default Yellow-Control backup hygiene

Default Yellow-Control governance recommends:

- local checkpoint pruning with `hermes checkpoints prune --retention-days 30 --max-size-mb 500`;
- monthly full Hermes backup archive creation to a private approved target;
- event-triggered native Hermes backup before connection to a new external server, onboarding a high-impact service, runtime governance change, installed governance skill change, and risky privileged action;
- native `hermes update --backup` or `updates.pre_update_backup: true` for Hermes updates;
- owner-approved archive retention for every recurring or event-triggered backup-producing workflow.

If no backup archive retention mechanism exists, Yellow-Control must defer new recurring backup-producing automation until retention is approved.
If storage is near an owner-defined threshold, Yellow-Control must defer or block non-emergency backup-producing actions and report through telemetry.
Emergency actions still require accountable authority and the safest available checkpoint or backup evidence.

## Backup-required moments

Require native `hermes backup` or a documented owner-approved equivalent before:

- monthly scheduled full Hermes backup archive;
- Hermes update unless `updates.pre_update_backup: true` already makes full pre-update backup the default;
- connection to a new external server;
- onboarding a new high-impact external service;
- runtime governance file changes;
- installed governance skill changes;
- risky privileged action;
- successful first-contact onboarding when a new baseline is established.

Repository-only documentation changes may use a repository branch or commit as the checkpoint when no Hermes runtime state is affected.
Runtime actions that affect Hermes configuration, auth, sessions, skills, pairing, profiles, memories, gateways, or long-lived automation require stronger Hermes-aware backup evidence.

## Backup target policy

Preferred private targets for backup archives, manifests, and metadata are:

- a private GitHub or GitLab repository named `hermes-backup` or `<hermes-instance-name>-backup`;
- an owner-approved private backup or artifact store;
- a temporary private local directory only if no remote target exists yet.

Never store Hermes backup archives in public Yellow-Control.
Never store Hermes backup archives in a public repository.
Treat Hermes backups as sensitive runtime artifacts because they may include configuration, authentication state, sessions, profiles, skills, memories, pairing data, and credentials depending on Hermes behavior and local configuration.
If using GitHub or GitLab, the repository must be private and access-controlled.
Encryption or restricted artifact storage should be considered for backups that may contain secrets or recovery material.

## Backup archive retention is mandatory

Backup archive retention is mandatory because unbounded archive growth can fill disk, artifact storage, or repository storage.
Retention can be enforced by a private GitHub or GitLab repository lifecycle policy, private artifact storage lifecycle, approved maintenance process, or explicit approved pruning.
Yellow-Control does not implement deletion logic itself.
Yellow-Control requires and verifies that an approved archive-retention mechanism exists before approving recurring backup-producing automation.

Governance retention rule:

- keep weekly snapshots for 3 months when weekly snapshots are produced;
- after 3 months, keep the first snapshot of each month until 12 months old;
- after 12 months, keep the first official calendar-quarter snapshot per quarter for up to 3 years;
- keep incident, legal, or security hold snapshots separately when explicitly marked;
- never delete the only known-good restore point;
- deletion requires an owner-approved retention policy or explicit approval.

## Existing backup mechanism rule

If a custom backup mechanism, backup skill, cron job, systemd timer, or external backup system already exists, detect and report it without replacing it silently.
Ask the accountable human authority whether to keep both mechanisms, use native Hermes backup as primary, use the existing mechanism only as a storage or retention layer, or retire the custom mechanism.
Default preference is native Hermes backup first.
Custom backup automation remains allowed only when explicitly required by the owner and documented as an implementation layer outside Yellow-Control.

## Weekly verification

Weekly verification should check and report whether:

- `hermes checkpoints` is available for local checkpoint status;
- local checkpoint pruning exists and is periodically run;
- the latest monthly or event-triggered backup archive exists when required;
- the backup target is private and writable or usable;
- restore metadata or a manifest exists;
- backup archive retention exists and archive growth is not unbounded;
- storage is not near an owner-defined threshold;
- failures are reported through the configured telemetry channel.

This verification is a readiness review.
It must not create cron jobs, systemd timers, shell scripts, backup commands, pruning implementations, or deletion routines.

## Backup telemetry

Backup telemetry must include:

- mechanism type: checkpoint pruning, backup archive, update backup, or owner-approved equivalent;
- command or setting used, such as `hermes checkpoints prune --retention-days 30 --max-size-mb 500`, `hermes backup`, `hermes backup -o <path>`, `hermes backup --quick --label <name>`, `hermes update --backup`, or `updates.pre_update_backup: true`;
- private target reference only, not secret values;
- timestamp;
- result pass, defer, block, or fail;
- snapshot identifier, archive identifier, checkpoint status reference, or path reference;
- restore metadata or manifest reference if available;
- retention mechanism reference for backup archives;
- next required backup, pruning check, retention review, or restore test;
- remediation on failure.

Telemetry must not include backup archive contents, checkpoint store contents, tokens, secrets, keys, private hostnames, private addresses, credential paths, private runtime paths, or sensitive logs.

## Governance boundary

Yellow-Control can require the backup gate to pass before a governed action.
Yellow-Control can record that `hermes checkpoints`, `hermes checkpoints prune`, `hermes backup`, `hermes update --backup`, `updates.pre_update_backup: true`, `hermes import <zipfile>`, or an owner-approved equivalent was used.
Yellow-Control cannot replace native Hermes backup, import, checkpoints, checkpoint pruning, update backup, GitHub skills, cron, service-manager behavior, artifact lifecycle behavior, or operator-managed storage.
