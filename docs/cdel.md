# CDEL: Containerized Delegated Execution Level

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

CDEL classifies actions performed through containers, sandboxes, runners, hosted agents, or delegated execution environments.

| Level | Meaning | Default decision |
| --- | --- | --- |
| CDEL-0 | No delegated execution. | Not applicable. |
| CDEL-1 | Ephemeral execution with no persistent credentials or host mounts. | Allow if other gates pass. |
| CDEL-2 | Delegated execution with workspace writes or cached dependencies. | Defer until scope and cleanup are defined. |
| CDEL-3 | Delegated execution with persistent tokens, mounts, network reach, or scheduled recurrence. | Defer for owner and security approval. |
| CDEL-4 | Delegated execution that can alter host identity, recovery, or privileged infrastructure. | Block unless explicitly approved as administrative work. |

## Required handling

- Record the runner, scope, persistence, network reach, and cleanup plan.
- Treat unknown persistence as CDEL-3.
- Do not let delegated execution expand ADAL or ESAL authority silently.
