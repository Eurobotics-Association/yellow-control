# External-access register

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

The external-access register is the minimal public-safe record required before an agent uses authenticated external services or contacts external servers. It records references and classifications, not plaintext secrets.

## Minimal register schema

| Field | Required content |
| --- | --- |
| target_id | Stable public-safe identifier for the service, repository, server, API, dashboard, or gateway. |
| target_type | Generic type such as repository, API, server, identity, cloud, email, dashboard, registry, notification, or gateway. |
| hostname | Redacted hostname or approved public-safe alias; do not store sensitive private hostnames in public docs. |
| ip_address | Redacted address, approved public-safe alias, or `not_recorded_publicly`; do not store private addresses in public docs. |
| port | Port or service label when safe to record; otherwise use a redacted reference. |
| access_user | Account, bot, service principal, or role alias used for access. |
| auth_method | SSH key, API token, OAuth app, deploy key, SSO, passwordless role, or other approved method. |
| ssh_key_ref | Reference to approved SSH key custody, never key material. |
| api_key_ref | Reference to approved API key or token custody, never token material. |
| secret_location_ref | Reference to approved secret storage, never plaintext secrets. |
| external_package_ref | Optional reference to a separate external package-management record or `not_applicable`. |
| adal_level | ADAL classification for administrative effect. |
| cdel_level | CDEL classification for delegated execution path. |
| esal_level | ESAL classification for external authority. |
| pcl_level | PCL classification for information handled. |
| first_contact_status | planned, discovery_only, approved, deferred, blocked, or retired. |
| first_contact_date | First contact date or `not_contacted`. |
| last_contact_date | Last contact date or `not_contacted`. |
| last_audited_date | Last audit date or `not_audited`. |
| last_audit_evidence_ref | Public-safe reference to audit evidence. |
| allowed_actions | Explicit allowed operations. |
| forbidden_actions | Explicitly prohibited operations. |
| approval_required | Approval rule for use, escalation, mutation, or emergency access. |
| accountable_authority | Human accountable role for the target and risk decision. |
| operator | Human, agent, bot, or automation role delegated to operate access. |
| recovery_custody_ref | Public-safe reference for recovery owner, break-glass custody, or revocation owner. |
| notes | Public-safe notes only; no credentials, private paths, private addresses, or sensitive logs. |

## Rule

No ESAL-2 or higher access may be used until the register entry exists and policy gates pass. The register must contain references to secrets and recovery custody, never plaintext secrets.
