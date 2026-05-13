# External-access onboarding

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

External-access onboarding creates a controlled path from request to registered, revocable, auditable service or server access.

## Workflow

1. Describe the maintenance or governance purpose.
2. Identify whether the target is a service, API, repository, email system, cloud console, dashboard, gateway, external server, or package-management integration.
3. Classify the requested access with ESAL, ADAL, CDEL, and PCL when the target can execute code or affect systems.
4. Identify accountable authority, operator, and recovery or security custody.
5. Define allowed and forbidden actions.
6. Select least-privilege account, credential, key, or token scope.
7. Document secret storage references and revocation path.
8. Add or update the external-access register entry.
9. Run policy gates before first use.
10. Record telemetry for onboarding and first use.

## Approval thresholds

| Classification | Minimum handling |
| --- | --- |
| ESAL-1 | Public-safe scope review. |
| ESAL-2 | Register entry and owner approval. |
| ESAL-3 | Owner approval, security approval, and rollback or revocation plan. |
| ESAL-4 | Block unless a reviewed recovery-custody procedure authorizes the action. |

External package management remains separate and optional. Yellow-Control governs access and authority decisions around it, not package implementation details.
