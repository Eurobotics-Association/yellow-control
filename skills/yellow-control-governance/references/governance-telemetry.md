# Governance telemetry

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Governance telemetry records Yellow-Control decisions, gates, evidence references, and outcomes in a public-safe form.
It lets a human reviewer understand why an agent allowed, deferred, or blocked a governed action.
Telemetry is not a secret store and not a raw log archive.
It must preserve accountability without exposing private operational state.

## Decision record fields

A decision record should include a public-safe decision identifier.
It should include task summary.
It should include target category.
It should include ADAL, CDEL, ESAL, and PCL classification.
It should include gates evaluated.
It should include gate result for each gate.
It should include final decision.
It should include missing evidence.
It should include required approval.
It should include rollback or checkpoint requirement.
It should include telemetry outcome summary.

## Classification recording

Record the highest plausible ADAL when impact is unclear.
Record CDEL when containers, runners, sockets, or delegated execution are involved.
Record ESAL when an external service, server, API, repository, account, or webhook is involved.
Record PCL for information read, written, transmitted, logged, or published.
Do not record raw private data as classification evidence.
Use references such as “register entry exists” or “backup evidence reference present.”

## Gate recording

For each core gate, record pass, defer, block, or not applicable.
Core gates are authority, classification and scope, backup and rollback, external access register, confidentiality and publication, automation and persistence, repository or GitHub when applicable, and telemetry.
For defer, record what evidence is missing.
For block, record the policy reason.
Do not include secret values, private host details, raw logs, or hidden operational paths.

## Evidence references

Evidence references should be public-safe labels.
Examples include branch name when public-safe, checkpoint identifier, register entry identifier, review identifier, approval role, or first-contact summary reference.
Do not include private storage locations, credential paths, raw account identifiers, or recovery channel details.
If evidence itself is private, record that a private evidence reference exists and identify the responsible role.

## Missing approval

When approval is missing, telemetry should state which role is missing.
Examples: owner authority missing, security authority missing, recovery custodian missing, maintainer review missing, or merge authority missing.
Do not name private individuals unless the repository policy explicitly permits public naming.
A missing approval usually produces defer.
A request to bypass missing approval produces block.

## Rollback requirement

Telemetry should record whether a checkpoint is required, whether it exists, who owns rollback, and what validation class applies.
Do not record private backup locations or restore secrets.
If no rollback can exist, record whether an emergency procedure is approved.
If rollback is missing for a risky action, the decision is defer or block.

## Final decision

The final decision is allow, defer, or block.
Allow records why the action is within scope.
Defer records the next safe evidence or approval step.
Block records the violated policy and a safe remediation path.
All three decisions should be useful to a human reviewer.
The agent must not execute mutation for defer or block.

## No secrets in telemetry

Telemetry must not include credentials, private keys, recovery codes, session material, secret-bearing logs, private hostnames, private addresses, private runtime paths, or raw confidential data.
If a secret appears in telemetry draft, stop and redact before publishing.
If a secret was already published, follow suspected exposure handling.
Use role names and evidence references instead of raw details.

## Minimal record template

```yaml
decision_id: "public-safe-id"
task_summary: "public-safe summary"
target_category: "repository | server | service | local | other"
classification:
  adal: ""
  cdel: ""
  esal: ""
  pcl: ""
gates_evaluated: []
gate_results: {}
decision: "allow | defer | block"
missing_evidence: []
required_approval: []
rollback_checkpoint_requirement: ""
telemetry_summary: "public-safe outcome"
```
