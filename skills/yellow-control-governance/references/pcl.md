# PCL: Project Confidentiality Level

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

PCL means Project Confidentiality Level.
It classifies information handled by the agent so reading, writing, logging, transmitting, summarizing, committing, and publishing can be governed.
PCL applies to documentation, source code, configuration, logs, prompts, telemetry, command output, server files, account metadata, screenshots, and external service responses.
Unknown confidentiality defaults to private until safely classified lower.

## Default unknown equals private

If the agent cannot prove that information is public-safe, treat it as PCL-3 until classified.
Do not publish, quote, commit, or transmit unknown runtime material.
Do not assume a file is public because it is readable in a shell.
Do not assume a log is safe because it does not obviously look like a credential.
When in doubt, summarize at a higher level and ask for authority or redaction guidance.

## PCL level table

| Level | Meaning | Publication posture | Default decision |
| --- | --- | --- | --- |
| PCL-0 | Public-safe information intended for release. | May publish. | Allow if other gates pass. |
| PCL-1 | Low-sensitivity internal context that can be summarized. | Publish only after review or redaction. | Defer before publication. |
| PCL-2 | Operational details, private paths, non-secret logs, target metadata, or access context. | Do not publish raw; summarize or redact. | Defer for handling. |
| PCL-3 | Secrets, credentials, recovery data, sensitive identity data, private incident detail. | Never publish or echo. | Block publication and require secure handling. |
| PCL-4 | Regulated, legally restricted, or high-impact confidential material. | Use approved legal or security workflow only. | Block unless approved workflow applies. |

## Publication rules

Public repository content must remain PCL-0.
Examples must use fictional targets, role names, redacted identifiers, and non-secret placeholders.
Telemetry must avoid raw logs, private hostnames, private addresses, private runtime paths, credentials, recovery channels, account identifiers, and customer data.
Commit messages and pull request text must not include private operational state.
A public-safe summary may describe the class of evidence without exposing the evidence itself.

## Redaction rules

Redact private hostnames, private addresses, usernames tied to real systems, runtime paths, secret store locations, account IDs, session identifiers, log snippets, and command output that reveals private context.
Use role labels such as owner authority, operator, security authority, and recovery custodian.
Use fictional examples for templates.
Replace raw values with reference identifiers that point to secure systems outside public documentation.
Do not create redactions that are reversible by context.

## Private runtime data

Private runtime data includes local paths, shell history, environment values, service names, deployment topology, container IDs, job logs, issue metadata, dashboard content, and server responses.
The agent may use such data for classification when authorized, but should not write it into public docs or telemetry.
If a task requires private runtime data to proceed, defer and request a secure channel or a public-safe evidence reference.

## Secret and recovery data

Secrets include credentials, private keys, API keys, session cookies, signing material, recovery codes, unlock material, and derived secrets such as signed URLs or credential-bearing debug dumps.
Recovery data includes account recovery channels, emergency access paths, restore unlock material, and revocation procedures.
The agent must not ask users to paste secrets into public prompts.
The agent must not print or commit secrets.
Secret references may be recorded when they are non-sensitive labels that point to an approved secret manager.

## Examples

A public README paragraph is PCL-0.
A role table with no real names or private targets is PCL-0.
A private server hostname is PCL-2 or higher and should be redacted in public docs.
A raw log containing environment details is PCL-2 until reviewed and may be PCL-3 if it includes credentials.
A credential file or recovery phrase is PCL-3 or PCL-4 and must not be exposed to the model or repository.
A summary stating “backup evidence reference exists” can be PCL-0 if it omits the private reference content.

## Handling checklist

Classify before reading further when possible.
Minimize exposure to the agent when sensitive material is not necessary.
Prefer references over raw values.
Summarize rather than quote private output.
Stop and report if secret exposure is suspected.
Record telemetry without confidential content.

## Downgrading confidentiality

Only downgrade confidentiality when evidence shows the information is intended for the destination.
A maintainer may approve public documentation wording, but security authority is required to downgrade secret, recovery, or sensitive operational material.
If a redacted summary is enough, do not expose the raw data.
