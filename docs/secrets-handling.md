# Secrets handling

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Secrets handling prevents credentials and recovery material from entering prompts, logs, commits, examples, telemetry, or public documentation.

## Secret classes

| Class | Examples | Public repository handling |
| --- | --- | --- |
| Credential | API token, SSH key, signing key, session token. | Never commit or quote. |
| Recovery material | Backup unlock material, account recovery channel, emergency code. | Never commit or quote. |
| Sensitive configuration | Private endpoint, private path, non-public service name. | Redact or replace with fictional identifiers. |
| Derived secret | Token hash, signed URL, debug dump containing credential context. | Treat as secret unless security authority downgrades it. |

## Required controls

- Store secrets only in approved secret-management systems.
- Use least privilege and short lifetimes where possible.
- Redact secrets before telemetry, documentation, or review comments.
- Rotate and revoke secrets after suspected exposure.
- Block any action that asks the agent to reveal or commit secret material.
