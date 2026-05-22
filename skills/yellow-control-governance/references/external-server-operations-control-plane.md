# External server operations control plane (skill reference)

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## When to consult

Consult this reference for external server SSH work, privileged server operations, package/service/systemd/sudo/wrapper changes, and external package-management integration decisions.

## SSH technical reach vs authority

SSH key/session access is technical reach only.
It is not authority by itself.
Require accountable approval and gate checks before mutation.

## First-contact default

For new or uncertain external servers, default to discovery-only first contact.
No mutation, no broad sudo, no sudo shell, and no package install unless separately approved.

## Elevation control rules

- No broad elevation by default.
- Classify ADAL/CDEL/ESAL/PCL before privileged execution.
- Constrained wrapper use is acceptable only when owner-installed, not agent-writable, narrow, logged, and removable.
- Classify and gate package install/upgrade, service mutation, systemd changes, sudoers or PAM/IAM edits, SSH trust/admin-path changes, Docker socket use, and recovery-path changes before execution.

## Package-management reference rule

Treat external package-management repositories as private implementation layers.
Use `external_package_ref` to reference approved package metadata without embedding private implementation details in public skill materials.
Connectivity approval does not automatically approve package install or upgrade; classify those actions separately.

## Allow/defer/block checklist

1. External-access entry exists (or drafted) and target identity is confirmed.
2. First-contact status is complete for new/uncertain servers.
3. ADAL/CDEL/ESAL/PCL classification is documented.
4. Allowed actions, forbidden actions, and approval authority are confirmed.
5. Backup/rollback readiness and recovery custody are confirmed.
6. Confidentiality constraints and telemetry obligations are confirmed.
7. Decision outcome is explicit: allow, defer, or block.
