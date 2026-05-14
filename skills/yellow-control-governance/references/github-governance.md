# GitHub and repository governance

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

GitHub, GitLab, and similar repository services are external-access targets.
Repository automation can alter public content, release artifacts, branch history, issues, pull requests, secrets, workflows, and organization settings.
This reference governs repository workflows without adding project-management or skill-registry sprawl.
Use it with ESAL, PCL, policy gates, and secrets handling.

## Relationship to standard Hermes GitHub skills

Yellow-Control does not replace standard Hermes GitHub skills or repository-operation skills.
Those skills remain responsible for authentication, issues, pull requests, repository operations, code review behavior, and platform-specific workflows.
Yellow-Control gates whether those operations are allowed, deferred, or blocked.
It classifies account type, repository authority, fork, branch, upstream, protected-branch risk, confidentiality, backup needs, approval needs, and telemetry readiness.
If a standard Hermes GitHub skill can perform an operation but Yellow-Control gates are missing, the operation must defer or block.

## Account classes

An agent-owned account is provisioned for automated repository work and should have least privilege.
An organization account belongs to the organization and may carry protected authority.
A client account belongs to another authority domain and requires explicit client-approved scope.
A human personal account must not be borrowed for routine agent automation.
The account class must be recorded in the external-access register.

## Fork, branch, and pull request workflow

Prefer an agent-owned fork or branch for changes.
Create focused commits with public-safe content.
Open a pull request for review when repository policy requires review.
Do not treat ability to push as authority to merge.
Do not treat a successful local test as review approval.
Do not merge without the role that owns merge authority.

## Direct push versus pull request

Direct push may be acceptable for an approved agent branch in a repository that allows it.
Direct push to protected branches requires explicit authority and should usually be blocked for the agent.
Pull requests provide review, discussion, CI, and rollback evidence.
For public governance policy, prefer pull requests unless the maintainer explicitly delegates direct push to a non-protected branch.
Even when direct push is allowed, secret and public-safety gates still apply.

## Protected branches

Protected branches represent repository-level governance.
The agent must not disable branch protection.
The agent must not bypass required reviews.
The agent must not alter status-check requirements unless owner and maintainer authority approve that repository policy change.
A protected branch setting change is ESAL-4 and may also affect authority custody.
Missing merge authority means defer, not improvise.

## Repository backup artifacts

Hermes backups are sensitive runtime artifacts and must not be pushed to public repositories.
If GitHub or GitLab is used as a backup target, the repository must be private, access-controlled, and owner-approved, with encryption or restricted artifact storage considered when backups may contain secrets.
Yellow-Control may govern the repository authority and retention policy, but it does not implement backup upload or deletion.

## No secret push

Never push credentials, private keys, recovery material, private target records, raw logs, private host details, or private runtime paths.
Scan changed files before commit when feasible.
If a secret is discovered after commit, stop and follow secret exposure handling.
Do not hide exposure by force-pushing without security approval.
Public examples must use fictional identifiers and role names.

## Force-push restrictions

Force-push rewrites history and can erase review context.
Do not force-push shared branches without explicit maintainer authority.
Do not force-push protected branches.
Do not use force-push to conceal unsafe content.
If cleanup is required after exposure, defer to maintainer and security authority.
A local amend before sharing may be acceptable when repository workflow permits it.

## Merge authority

Merge authority belongs to the maintainer or owner role defined by repository policy.
The agent may prepare a merge only when explicitly delegated.
The agent may not infer merge authority from branch access, passing tests, or authoring the change.
Merging policy or security changes requires review evidence.
Release tags and publication require separate authority and are out of scope unless specifically approved.

## Allow examples

Allow local edits and tests on an approved branch.
Allow pushing an agent branch when the repository register permits it and no secrets are present.
Allow opening a pull request with public-safe description and validation summary.

## Defer examples

Defer direct push to a shared branch when branch policy is unclear.
Defer merge when reviewer or maintainer approval is missing.
Defer workflow changes when their secret and permission impact is unknown.

## Block examples

Block pushing secrets.
Block disabling branch protections for convenience.
Block using a borrowed human account.
Block force-pushing shared history to hide mistakes.
Block claiming official service approval without evidence.
