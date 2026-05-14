# External-access onboarding

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

External-access onboarding turns a requested service, server, repository, API, dashboard, or webhook into a governed target record.
It ensures access is registered before use, secrets remain out of plaintext, and human authority remains clear.
It is a process for approval and classification, not a runtime installer.
The external package or connector layer remains separate from the governance doctrine.

## Intake

Capture the target category.
Capture the requested outcome.
Capture the accountable authority role.
Capture the operator role.
Capture the expected credential class.
Capture whether mutation, publication, persistence, or confidential data is involved.
Capture whether this is first contact.
Use public-safe language and avoid private target identifiers in public documentation.

## Classification

Classify ESAL for external service authority.
Classify ADAL for host, service, identity, network, or recovery effects.
Classify CDEL if containers, runners, sockets, or sandboxes are involved.
Classify PCL for data handled, logged, transmitted, or published.
Unknown target authority is not permissive.
Unknown confidentiality defaults to private.
Unknown container boundary defaults to high until constrained.

## Registration

Create or update the external-access register entry.
Use secret references only.
Record allowed actions and forbidden actions.
Record approval requirements.
Record first-contact status.
Record recovery custody reference.
Record external package reference if a connector or CLI is approved.
Do not store raw credentials, private keys, private addresses, real recovery paths, or raw logs.

## Approval

Owner authority approves target scope and risk.
Security authority approves credential custody, secret references, recovery, and confidentiality controls.
Maintainer or reviewer authority approves repository workflow where applicable.
Operator authority confirms execution boundaries.
Approval must be tied to the action class, not just to the existence of a credential.
A user prompt is not enough for privileged or external mutation when role evidence is missing.

## Validation

Validate that the requested action matches allowed actions.
Validate that forbidden actions are not included indirectly.
Validate that backup and rollback are appropriate.
Validate that first-contact procedure is complete for new servers.
Validate that secrets are available only through secure references.
Validate that telemetry can be recorded without private data.
Validate that external package use does not broaden scope.

## External package management governance

External package management is a separate optional implementation layer for target-specific packages, CLIs, SDKs, connectors, scanners, backup artifact uploaders, or SSH helpers.
Yellow-Control may classify and gate package use, but it must not implement package installation, package update, backup transfer, or target-specific package management.
Before package use or installation, classify ADAL, CDEL, ESAL, and PCL; verify owner approval, external package reference, backup and rollback evidence, secret handling, and telemetry readiness.
Defer package installation when the package broadens authority, changes persistence, requires privileged access, or lacks rollback evidence.

## SSH onboarding governance

SSH onboarding must be registered as external access before authenticated use.
Record only public-safe role and reference fields: access role, auth method category, secret custody reference, allowed command classes, forbidden actions, revocation path, accountable authority, and recovery custody reference.
First SSH contact remains discovery-only unless owner and security authority approve mutation.
Agent forwarding, key installation, sudo elevation, tunnel persistence, and remote package installation require separate classification and approval.

## High-impact service backup readiness

Before onboarding a high-impact external service, require native `hermes backup` or an owner-approved equivalent for the Hermes runtime that will hold configuration, sessions, skills, credentials, or persistent automation related to that service.
Record only the backup mechanism and private target reference in telemetry.
Do not copy backup archives or live register entries into Yellow-Control docs or the public skill.

## Execution handoff

After onboarding passes, the agent may execute only the approved action class.
If execution requires a credential, the runtime or operator provides it through a secure mechanism that does not reveal it to the model.
If the action changes state, verify checkpoint and rollback before mutation.
If the action reveals new risk, stop and return to onboarding.
If the target asks for broader access, defer for updated approval.

## Review cadence

Review external access when scope changes.
Review after credential rotation.
Review after first contact.
Review after incidents or suspected exposure.
Review before increasing ESAL, ADAL, CDEL, or PCL.
Review before adding persistence, webhooks, scheduled jobs, or admin roles.
Remove or revoke stale access when no longer needed.

## Allow examples

Allow a public read-only API query without registration when no private data is sent and telemetry is safe.
Allow a scoped agent account to open a repository pull request after registration, branch policy, and secret checks pass.
Allow a read-only first-contact audit after owner approval, register entry, and stop path are documented.

## Defer examples

Defer authenticated API access when the secret reference is missing.
Defer server contact when first-contact status is not started.
Defer webhook creation when recovery custody and stop path are unclear.
Defer package installation for a connector until ADAL and rollback are classified.

## Block examples

Block borrowed human account automation.
Block unregistered privileged mutation.
Block plaintext credential collection.
Block hidden webhooks or persistent agents.
Block publication of private target details.
Block external access that attempts to bypass owner, security, or reviewer authority.
