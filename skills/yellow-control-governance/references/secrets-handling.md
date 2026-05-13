# Secrets handling

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Secrets handling prevents credentials, recovery material, sensitive configuration, and derived secret data from entering prompts, logs, commits, examples, telemetry, or public documentation.
Yellow-Control uses secret references rather than plaintext secret values.
A secret can authorize external action, privileged administration, account recovery, or data access, so secret handling is part of both authority and confidentiality governance.

## No plaintext secrets

Do not ask a user to paste secret values into a normal prompt.
Do not print secret values from environment, files, command output, dashboards, or logs.
Do not commit secret values.
Do not place secret values in examples, templates, telemetry, issue text, pull request bodies, or comments.
Do not transform a secret into a hash, signed URL, debug dump, or partial reveal and treat it as safe without security approval.
Do not use screenshots or logs that show secret-bearing fields.

## Secret references

A secret reference is a public-safe label that points to approved custody outside the public repository.
It may identify a secret manager record, secure runtime setup, credential file category, SSH key custody reference, API credential reference, or recovery custody reference.
It must not reveal the secret value, private path, real account recovery channel, or sensitive endpoint.
The external-access register records secret references, not secrets.
Telemetry records whether the reference existed, not its value.

## Runtime injection

Hermes-compatible runtimes may securely pass configured environment values or credential files to tools without showing raw values to the model.
The model should refer to the configured reference and avoid commands that echo the value.
Environment variables and credential files are not to be displayed to the model.
If a command may print credential-bearing output, redirect, filter, or avoid the command.
If safe filtering cannot be guaranteed, defer for operator execution through a secure channel.

## Credential files

Credential files are secrets even when stored on disk.
Do not quote their paths in public docs when the path reveals private runtime structure.
Do not mount credential files into containers unless CDEL, ESAL, PCL, and security authority permit it.
Mount as read-only where possible.
Avoid forwarding credential files to unknown servers.
Remove temporary files and verify cleanup when the approved workflow requires it.

## Recovery custody

Recovery material includes account recovery channels, emergency codes, backup unlock material, revocation authority, and break-glass paths.
Treat recovery material as highly sensitive even if it is not a conventional credential.
Changing recovery custody requires owner and security approval.
Publishing recovery details is blocked.
Telemetry may record a recovery custody reference only when it is public-safe.

## Token and log leakage prevention

Logs often include command lines, headers, environment summaries, URLs, account identifiers, or error traces.
Review logs before summarizing or publishing.
Prefer high-level evidence summaries over raw logs.
Avoid verbose flags on commands that may reveal secrets.
Disable shell tracing for secret-handling commands.
Never use external paste services for secret-bearing logs.

## Suspected exposure

Stop printing or processing the exposed material.
Do not copy the secret into the response.
Record a public-safe incident summary.
Notify or defer to the security authority.
Revoke or rotate the credential through approved custody.
Remove exposed material from commits, logs, artifacts, or comments when authorized.
Review whether derived materials also require revocation.

## Allow, defer, block

Allow use of a secret reference when the register, authority, and runtime setup are approved.
Defer when a credential is needed but only plaintext submission is available.
Defer when log output may contain secrets and no redaction plan exists.
Block requests to reveal, commit, echo, publish, or bypass custody for secret material.
Block requests to change recovery channels without approved owner and security procedure.
