# Example owner/security approval flow for external packages

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

This is an example workflow skeleton only.
It is not an installer and does not perform package installation.

## Flow

1. Requester proposes a package entry with fictional `package_id`, target class, approved use, forbidden use, and rollback requirement.
2. Governance reviewer classifies expected ADAL/CDEL/ESAL/PCL impact for planned usage.
3. Owner approves, defers, or blocks based on authority and operational scope.
4. Security reviewer approves, defers, or blocks based on exposure and control sufficiency.
5. If approved, runtime team executes installation through private implementation tooling outside this public repository.
6. Decision telemetry records the classification, evidence references, outcome, and `external_package_ref`.

## Minimum approval record fields

- package_id
- package_type
- target_class
- required_approval
- approved_use
- forbidden_use
- ADAL/CDEL/ESAL/PCL expectation summary
- rollback_requirement
- external_package_ref
- owner decision
- security decision
- final allow/defer/block decision
