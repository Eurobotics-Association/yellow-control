# External-access register

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

The external-access register records public-safe metadata for external services, servers, APIs, repositories, dashboards, webhooks, and accounts.
It exists to separate authority proof from operational access.
A credential, shell, account session, or reachable endpoint is not enough.
The register tells the agent what target class exists, what actions are allowed, what actions are forbidden, which roles are accountable, and where secret references are held without exposing secrets.

## Register-first authority

Register-first means the agent confirms or drafts a target record before authenticated or mutating access.
For new targets, the record may begin as incomplete and force a defer decision.
For public unauthenticated reading, a full register may not be required if no private data is sent or received.
For servers, private APIs, repositories, accounts, and dashboards, missing registration defers access.
For privileged mutation, missing registration blocks execution until owner and security approval exist.

## No plaintext secrets

The register must never contain plaintext credentials, private keys, recovery codes, session cookies, or raw secret material.
It may contain secret references that point to an approved secret manager, local secure setup, or credential custody record.
The reference must be useful to the operator without revealing the value to the model or public repository.
Hermes-compatible runtimes may pass configured secrets to tools without showing them to the model; Yellow-Control still records only the reference and allowed use.

## Target types

Targets include servers, APIs, SaaS applications, GitHub or GitLab repositories, package registries, email systems, identity providers, cloud dashboards, monitoring dashboards, databases, messaging gateways, and webhooks.
A target can have multiple classifications.
A server may need ESAL for SSH or API access, ADAL for host administration, CDEL for container use, and PCL for logs or data.
A repository may need ESAL for hosted service authority, PCL for content, and repository gate evidence for branch and review rules.

## Required fields

| Field | Meaning |
| --- | --- |
| target_id | Public-safe unique identifier for the register entry. |
| target_type | Server, repository, API, SaaS, dashboard, webhook, identity provider, or other category. |
| hostname | Public-safe hostname category or redacted hostname reference. |
| ip_address | Public-safe address category or redacted address reference. |
| port | Port or port category when safe; otherwise redacted reference. |
| access_user | Role or account class used for access, not a private personal identity. |
| auth_method | Authentication method category such as SSH key reference, OAuth, app token, or SSO. |
| ssh_key_ref | Non-secret reference for SSH key custody if applicable. |
| api_key_ref | Non-secret reference for API credential custody if applicable. |
| secret_location_ref | Non-secret reference to approved secret storage or secure setup. |
| external_package_ref | Optional reference to approved CLI, SDK, connector, or package layer. |
| adal_level | Expected ADAL classification for approved actions. |
| cdel_level | Expected CDEL classification if delegated execution is involved. |
| esal_level | Expected ESAL classification for target access. |
| pcl_level | Expected PCL classification for handled data. |
| first_contact_status | not_started, discovery_only, completed, blocked, or not_applicable. |
| first_contact_date | Public-safe date of first-contact completion or blank. |
| last_contact_date | Public-safe last contact date or blank. |
| last_audited_date | Public-safe audit date or blank. |
| last_audit_evidence_ref | Non-secret evidence reference for audit summary. |
| allowed_actions | Public-safe list of approved action classes. |
| forbidden_actions | Public-safe list of prohibited action classes. |
| approval_required | Role approvals required before access or mutation. |
| accountable_authority | Role accountable for the target. |
| operator | Role or agent identity class executing the action. |
| recovery_custody_ref | Non-secret reference for recovery and revocation custody. |
| notes | Public-safe notes only. |

## Empty YAML template

```yaml
target_id: ""
target_type: ""
hostname: ""
ip_address: ""
port: ""
access_user: ""
auth_method: ""
ssh_key_ref: ""
api_key_ref: ""
secret_location_ref: ""
external_package_ref: ""
adal_level: ""
cdel_level: ""
esal_level: ""
pcl_level: ""
first_contact_status: "not_started"
first_contact_date: ""
last_contact_date: ""
last_audited_date: ""
last_audit_evidence_ref: ""
allowed_actions: []
forbidden_actions: []
approval_required: []
accountable_authority: ""
operator: ""
recovery_custody_ref: ""
notes: ""
```

## Fictional server example

```yaml
target_id: "srv-example-lab-001"
target_type: "server"
hostname: "example-lab-host.invalid"
ip_address: "redacted-private-address-ref"
port: "ssh-standard"
access_user: "agent-operator-role"
auth_method: "ssh-key-reference"
ssh_key_ref: "secret-ref/example-lab/ssh-agent-key"
api_key_ref: ""
secret_location_ref: "secret-store-ref/example-lab"
external_package_ref: "approved-ssh-client"
adal_level: "ADAL-1 for discovery; ADAL-2+ for approved maintenance"
cdel_level: "CDEL-0 unless containers are used"
esal_level: "ESAL-2 for authenticated discovery"
pcl_level: "PCL-2 for operational output"
first_contact_status: "discovery_only"
first_contact_date: "2026-01-15"
last_contact_date: "2026-01-15"
last_audited_date: ""
last_audit_evidence_ref: "evidence-ref/example-lab/first-contact-summary"
allowed_actions:
  - "read-only baseline audit"
forbidden_actions:
  - "broad sudo"
  - "sudo shell"
  - "Docker socket use"
approval_required:
  - "owner authority for mutation"
  - "security authority for privileged access"
accountable_authority: "server owner role"
operator: "governed agent role"
recovery_custody_ref: "recovery-ref/example-lab"
notes: "Fictional example; not a real target."
```

## Fictional GitHub or service example

```yaml
target_id: "repo-example-public-001"
target_type: "repository-service"
hostname: "github.example.invalid"
ip_address: "not_applicable"
port: "https-standard"
access_user: "agent-owned-account"
auth_method: "scoped-app-credential-reference"
ssh_key_ref: ""
api_key_ref: "secret-ref/example-repo/scoped-api"
secret_location_ref: "secret-store-ref/example-repo"
external_package_ref: "approved-git-client"
adal_level: "ADAL-1 for repository content edits"
cdel_level: "CDEL-1 for local tests"
esal_level: "ESAL-3 for branch and pull request workflow"
pcl_level: "PCL-0 public repository content only"
first_contact_status: "not_applicable"
first_contact_date: ""
last_contact_date: "2026-01-15"
last_audited_date: "2026-01-15"
last_audit_evidence_ref: "evidence-ref/example-repo/review-policy"
allowed_actions:
  - "push agent branch"
  - "open pull request"
forbidden_actions:
  - "direct protected branch push"
  - "force push shared branch"
  - "merge without maintainer authority"
approval_required:
  - "maintainer review before merge"
accountable_authority: "repository maintainer role"
operator: "agent-owned account"
recovery_custody_ref: "repository admin role"
notes: "Fictional example; no real service entry."
```

## Hermes retrieval without exposing secrets

A Hermes-compatible agent should read this register metadata and use secret references only as labels.
If the runtime securely injects environment variables or credential files into tools, the model still must not see raw values.
The agent should request or use only the named reference that the operator has configured securely.
Command output must be filtered so secrets are not echoed back into prompts, logs, commits, or telemetry.

## Missing metadata outcomes

Missing target identity usually causes defer.
Missing accountable authority causes defer for planning and block for mutation that bypasses authority.
Missing secret reference causes defer; a request to paste the secret into the model blocks.
Missing recovery custody causes defer for ordinary mutation and block for lockout-prone actions.
A mismatch between requested action and allowed actions causes block unless the owner updates the register through approved review.
