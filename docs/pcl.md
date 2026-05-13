# PCL: Privacy and Confidentiality Level

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

PCL classifies information handled by the agent so disclosure, logging, and publication controls can be enforced.

| Level | Meaning | Default decision |
| --- | --- | --- |
| PCL-0 | Public-safe information intended for release. | Allow if other gates pass. |
| PCL-1 | Low-sensitivity internal context that can be summarized publicly. | Defer before publication; redact specifics. |
| PCL-2 | Operational details, private paths, service names, non-secret logs, or access context. | Defer; require redaction and need-to-know handling. |
| PCL-3 | Secrets, tokens, credentials, recovery channels, sensitive incidents, or private identity data. | Block publication and require secure handling. |
| PCL-4 | Regulated, legally restricted, or high-impact confidential material. | Block unless an approved legal/security workflow applies. |

## Required handling

- Unknown confidentiality defaults to PCL-3 until classified lower.
- Public repository content must remain PCL-0.
- Telemetry must record decisions without storing secrets or private operational state.
