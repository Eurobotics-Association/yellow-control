# ESAL: External Service Authority Level

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

ESAL classifies authority over external services and access targets, including services, APIs, GitHub or GitLab, email systems, cloud consoles, dashboards, package registries, notification channels, and external servers.

## Levels

| Level | Meaning | Default decision |
| --- | --- | --- |
| ESAL-0 | No external service access. | Not applicable. |
| ESAL-1 | Public read access or unauthenticated metadata lookup. | Allow if confidentiality gate passes. |
| ESAL-2 | Authenticated read or scoped write with non-critical impact. | Defer until registered and scoped. |
| ESAL-3 | Administrative write, token management, webhook, CI, release, membership, server login, or dashboard control. | Defer for owner and security approval. |
| ESAL-4 | Ownership transfer, recovery-channel change, billing custody, destructive external action, or emergency recovery action. | Block unless a reviewed recovery procedure approves it. |

## Servers as external access targets

An external server is both an access target and an administrative target. Classify server work with all four dimensions:

| Dimension | Question |
| --- | --- |
| ESAL | What external access path, account, key, API, or network service is being used? |
| ADAL | What administrative effect can occur on the target server? |
| CDEL | Is execution delegated through a runner, container, gateway, or resident agent? |
| PCL | What private system details, logs, credentials, or operational data may be exposed? |

## First-contact and reverse-risk caution

First contact with an unknown or hostile server is discovery-only by default. The agent must verify scope, owner authority, authentication method, logging posture, and rollback options before mutation. Reverse risk matters: a server can attack the agent through hostile prompts, files, shells, APIs, logs, or responses, so unknown targets require conservative PCL handling and constrained execution.

External package management is a separate implementation layer. Yellow-Control may govern whether package-management access is allowed, but it does not define package-manager implementation details.

## Required handling

- Register every ESAL-2 or higher integration before use.
- Identify owner authority, recovery custody, token scope, account scope, and revocation path.
- Treat unknown token, account, key, or server capability as ESAL-3 until narrowed.
