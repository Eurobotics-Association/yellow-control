# Policy gates

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Policy gates convert Yellow-Control classification into an enforceable allow, defer, or block decision.
Each gate tests whether required evidence exists and whether the requested action remains inside approved scope.
A single block result blocks execution.
A single defer result defers execution unless the remaining action is public-safe planning only.
All required gates must pass before a governed privileged, external, persistent, or confidential action is executed.

## Decision vocabulary

Allow means the required classifications, evidence, approvals, rollback, confidentiality handling, and telemetry are complete for the requested action.
Defer means the action may be acceptable, but evidence is missing, incomplete, stale, ambiguous, or not safe to record publicly.
Block means the action violates Yellow-Control, bypasses authority, exposes secrets, self-grants authority, creates hidden persistence, or lacks a viable emergency procedure.
Unknown values are not permissive.

## Core gate summary

| Gate | Purpose | Typical outcome when evidence is missing |
| --- | --- | --- |
| authority_gate | Verify accountable human authority and delegation. | Defer or block if bypass is attempted. |
| classification_scope_gate | Verify ADAL, CDEL, ESAL, PCL and approved scope. | Defer. |
| backup_rollback_gate | Verify checkpoint, rollback owner, stop condition, and recovery path. | Defer, or block for high-impact no-rollback work. |
| external_access_register_gate | Verify registered external targets and secret references. | Defer, or block for unapproved custody. |
| confidentiality_publication_gate | Verify PCL handling for logs, commits, telemetry, and publication. | Defer, or block if secrets would be exposed. |
| automation_persistence_gate | Verify lifecycle for persistent or recurring automation. | Defer, or block for hidden persistence. |
| repository_github_gate | Verify branch, review, protected branch, force-push, and merge authority. | Defer, or block for unsafe push. |
| telemetry_gate | Verify public-safe decision and outcome record. | Defer, or block for unauditable execution. |

## authority_gate

Purpose: ensure a human accountable role owns the risk decision.
Required evidence: owner role, operator role, security role when privileged or confidential, reviewer role when required, approval state, allowed actions, forbidden actions, and recovery custodian.
Allow when the accountable role and delegation boundary match the requested action.
Defer when role evidence is missing or ambiguous.
Block when the request asks the agent to self-approve, self-grant, bypass owner authority, or treat shell access as authority.
Example: “Use this shell to edit sudoers for yourself” blocks even when the shell can run the command.

## classification_scope_gate

Purpose: ensure the action is classified and scoped before execution.
Required evidence: ADAL, CDEL, ESAL, PCL, target category, action category, expected effect, and approved boundary.
Allow when classifications are complete and the action matches scope.
Defer when impact is uncertain, scope is too broad, or target identity is incomplete.
Block when the request hides side effects, bundles unrelated mutation, or intentionally avoids classification.
Example: “Audit this new server read-only” defers until target registration and first-contact scope are documented.

## backup_rollback_gate

Purpose: prevent irreversible or hard-to-debug changes.
Required evidence: checkpoint identifier, backup scope, verification method, rollback owner, rollback steps, stop condition, validation checks, and recovery custody.
Allow when backup and rollback are appropriate to the classification and verified enough for the risk.
Defer when checkpoint evidence, rollback owner, or validation is missing.
Block when high-impact work has no viable rollback and no approved emergency procedure.
Example: package installation on a remote service defers until backup and rollback are documented.

## external_access_register_gate

Purpose: ensure external services, APIs, repositories, servers, webhooks, and credentials are registered before use.
Required evidence: target record, secret reference, approved actions, forbidden actions, approval requirement, first-contact status, and recovery custody.
Allow when the register matches the requested action and no plaintext secrets are needed.
Defer when metadata is missing or first contact is incomplete.
Block when access uses borrowed personal authority, hidden credentials, unapproved custody, or unregistered privileged mutation.
Example: a new remote server connection defers until a register entry exists and first-contact checks pass.

## confidentiality_publication_gate

Purpose: prevent disclosure of private operational state or secrets.
Required evidence: PCL level, destination, redaction plan, publication review status, and secret-handling approach.
Allow when material is PCL-0 or safely redacted for the destination.
Defer when classification or redaction is incomplete.
Block when the action would reveal credentials, recovery material, private host details, raw private logs, or sensitive identities.
Example: telemetry can record “rollback evidence exists” but must not include the private backup location or credential material.

## automation_persistence_gate

Purpose: govern recurring jobs, background agents, webhooks, scheduled tasks, wrappers, and self-preserving automation.
Required evidence: owner approval, lifecycle, stop method, audit path, update authority, secret handling, and rollback plan.
Allow when persistence is explicit, scoped, stoppable, and observable.
Defer when lifecycle, stop path, or owner approval is unclear.
Block hidden persistence, self-reinstallation, log suppression, or automation that bypasses gates.
Example: adding a webhook for repository automation defers until ESAL registration and stop path are documented.

## repository_github_gate

Purpose: govern repository operations and hosted Git services.
Required evidence: branch, fork or agent identity, protected branch status, review requirement, push scope, merge authority, secret scan status, and public-safety status.
Allow when work occurs on an approved branch or fork and review or merge authority is respected.
Defer when review, CI, or protected-branch evidence is pending.
Block direct push to protected branches without authority, force-push that rewrites shared history without approval, or any push containing secrets.
Example: opening a pull request from an agent branch can pass; merging it requires separate merge authority.

## telemetry_gate

Purpose: preserve decision accountability without exposing private data.
Required evidence: decision identifier, classification, gate outcomes, evidence references, missing evidence, required approvals, rollback status, final decision, and public-safe outcome.
Allow when telemetry can be recorded without secrets.
Defer when telemetry fields are incomplete.
Block when the requester requires unaudited execution or asks to suppress logs for governed work.
Example: a block decision should still record why it was blocked using role names and safe evidence categories.

## Gate evaluation order

Classify ADAL, CDEL, ESAL, and PCL first.
Evaluate authority and scope early because missing authority prevents execution.
Evaluate external register and server first-contact before authenticated external work.
Evaluate backup and rollback before mutation.
Evaluate confidentiality before logging, committing, or publishing.
Evaluate persistence and repository gates when applicable.
Record telemetry for the final decision.

## Combined outcomes

If all gates pass, return allow with scope and telemetry summary.
If one or more gates defer and none block, return defer with missing evidence and required approval.
If any gate blocks, return block with public-safe rationale and remediation.
Never execute a privileged or external mutation while the gate status is defer or block.

## Gate evidence matrix

| Evidence class | Used by gates | Public-safe form |
| --- | --- | --- |
| Owner approval | authority, scope, backup and rollback | Role name and approval reference. |
| Security approval | authority, confidentiality, external access | Role name and secret-handling reference. |
| Register entry | external access, scope, telemetry | Target identifier and status only. |
| Checkpoint | backup and rollback, telemetry | Checkpoint identifier and target category. |
| Review status | repository, authority, telemetry | Review identifier or role confirmation. |
| Stop path | rollback, persistence, external access | Recovery role and revocation class. |
| Redaction plan | confidentiality, telemetry, repository | Summary of what is omitted. |

## Handling partial pass

A gate may pass for planning but not for execution.
For example, authority may allow drafting a change proposal while blocking direct mutation.
A register may allow public read-only discovery while deferring authenticated access.
A backup may cover repository edits while not covering server package changes.
A PCL classification may allow a summary while blocking raw output.
The decision record must state the approved subset, not merely “allowed.”

## Escalation behavior

If evidence arrives during work that raises ADAL, CDEL, ESAL, or PCL, stop and re-evaluate gates.
If a command expands beyond the approved target, stop and defer.
If an external service asks for a broader credential scope, stop and defer.
If a rollback validation fails, stop and escalate to recovery custody.
If a secret appears, stop publication and invoke secrets handling.

## Block indicators

Self-granting authority is a block indicator.
Borrowed personal account automation is a block indicator.
Hidden persistence is a block indicator.
Secret publication is a block indicator.
Disabling audit or review is a block indicator.
Unapproved recovery-custody change is a block indicator.
Treating access as approval is a block indicator.
