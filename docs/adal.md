# ADAL: Administrative Delegation and Authority Level

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

ADAL classifies host, operating-system, identity, network, sudo, and administrative actions. It answers one question before execution: which accountable human authority must approve this administrative effect?

## Authority principles

- A human accountable authority owns the target system and the risk decision.
- The agent may execute only inside delegated authority; it must not become its own approver.
- Sudo access is delegated administrative capability, not ownership.
- The agent must not add itself to privileged groups, change sudo policy for itself, create privileged credentials, or otherwise self-grant authority.
- Root-owned wrapper patterns are acceptable only when a human administrator owns the wrapper, constrains the command surface, logs use, and defines rollback or removal.
- The resident runtime host and an external target server are separate authority domains; approval on one does not automatically authorize mutation on the other.
- Remote server first contact starts as discovery-only unless the owner authority, scope, backup, rollback, and confidentiality gates are already satisfied.

## Levels

| Level | Meaning | Default decision |
| --- | --- | --- |
| ADAL-0 | No administrative effect. Read-only documentation, local planning, or public-safe classification. | Allow if other gates pass. |
| ADAL-1 | User-space change inside an approved workspace, with no service, identity, sudo, or shared-runtime effect. | Allow with scope evidence. |
| ADAL-2 | Service, package, scheduled-task, non-root configuration, or supervised operational change that can affect continuity. | Defer until backup and rollback evidence exist. |
| ADAL-3 | Privileged identity, sudo, root-owned wrapper, network, firewall, recovery, or root-equivalent change. | Defer for explicit owner and security approval. |
| ADAL-4 | Emergency, destructive, irreversible, access-lockout-prone, or recovery-custody-changing action. | Block unless an approved emergency procedure exists. |

## Required handling

- Classify the highest plausible ADAL level before execution.
- Treat unknown administrative impact as ADAL-3 until narrowed.
- Require backup and rollback checkpoints for ADAL-2 or higher.
- Require explicit security authority for ADAL-3 or higher.
- For external servers, combine ADAL with ESAL, CDEL, and PCL instead of treating SSH or API reach as sufficient authority.
