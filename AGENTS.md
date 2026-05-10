# AGENTS

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Mission

Maintain Yellow-control as a reusable governance layer for persistent autonomous agents.

## Operating constraints

- Patch, not reinvent.
- Preserve coherence between policy text, examples, and skill behavior.
- Keep examples generic and public-safe.
- Do not include secrets or private operational state.
- Treat policy gates as enforceable controls where runtime enforcement is required.

## Governance posture

- Classify actions with ADAL/CDEL/ESAL/PCL before execution.
- Require backup/rollback checkpoints before core runtime changes.
- Block or defer actions when required authority or prerequisites are missing.
- Produce governance telemetry for decisions, gates, and outcomes.

## Contribution baseline

- Keep all documentation in English.
- Preserve mandatory metadata lines in all documents.
- Keep SKILL.md concise and move details to references.
