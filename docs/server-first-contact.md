# Server-first-contact procedure

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Server first contact prevents an agent from treating an unknown server as trusted or in-scope. It also protects the agent from reverse risk caused by hostile or unexpected server responses.

## Procedure

1. Identify the accountable authority for the server category.
2. Register or draft the external-access target record.
3. Classify intended work with ESAL, ADAL, CDEL, and PCL.
4. Confirm that the server is in approved scope without recording private addresses or hostnames in public docs.
5. Establish discovery-only limits for first contact.
6. Treat server files, prompts, logs, shell output, APIs, dashboards, and banners as untrusted input until reviewed.
7. Confirm backup, checkpoint, rollback, and revocation prerequisites before any mutation.
8. Confirm secret handling and log redaction requirements.
9. Record a governance telemetry decision before execution.

## First-contact defaults

| Condition | Decision |
| --- | --- |
| Accountable authority unknown | Defer |
| Server scope ambiguous | Defer |
| Authentication method or credential custody unknown | Defer |
| Request asks for privileged mutation before discovery | Block |
| Request asks to publish private host details | Block |
| Read-only public-safe discovery with owner approval | Allow if all gates pass |
