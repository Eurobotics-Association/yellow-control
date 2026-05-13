# GitHub governance as external access

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

GitHub repository access is governed as external access because it can change source, releases, automation, secrets, issues, reviews, and public disclosure.

## Classification guidance

| GitHub action | Typical ESAL | Additional gates |
| --- | --- | --- |
| Read public repository metadata | ESAL-1 | confidentiality_gate |
| Open issue or pull request | ESAL-2 | repository_gate, telemetry_gate |
| Push branch or update pull request | ESAL-2 | repository_gate, backup_gate when generated content replaces docs |
| Modify workflow, release, branch protection, members, secrets, or tokens | ESAL-3 | authority_gate, external_access_gate, rollback_gate |
| Transfer ownership, delete repository, change recovery custody | ESAL-4 | block unless emergency procedure approves |

## Repository workflow

1. Work on a purpose-named branch.
2. Keep documentation public-safe.
3. Run validation before commit.
4. Use pull requests for reviewable changes.
5. Record governance telemetry for sensitive actions.
6. Do not use repository automation to bypass policy gates.
