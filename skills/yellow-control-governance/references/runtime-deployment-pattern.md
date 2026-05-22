# Runtime deployment pattern (skill-local)

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Deployment boundary

The public skill package provides doctrine and templates.
Runtime-private enforcement and records remain outside the public repository.

## Private overlay rule

A real runtime requires a private overlay for local custody and enforcement, including private register locations, private decision logs, and owner-approved runtime controls.

## AGENTS.md and SOUL.md adaptation rule

Adapt AGENTS.md and SOUL.md only in the target runtime context.
Do not commit runtime-specific AGENTS/SOUL operational state to the public repository.

## Backup governance autonomy model

Yellow-Control decides and records whether backup/readiness evidence is required for the requested risk.
Owner-approved local gates and runtime controls may enforce required backup/checkpoint behavior.
Local-only backup is degraded break-glass evidence unless owner-approved and explicitly logged with reason.

## Wrapper scope rule

Wrappers are optional private runtime implementation details.
Each wrapper must gate only its own known mutation flow and must not act as the universal backup-governance engine.

## Universal fallback event rule

If uncertain, or if a specific event label is unsupported, use a generic pre-runtime-change event and include original risk context in the reason string.

## Hermes update governance lesson

Yellow-Control does not replace native Hermes update and does not ship a private update wrapper as standard deployment.
Hermes update governance is a backup/readiness decision, not a public wrapper requirement.
A runtime may satisfy this through native Hermes backup/update behavior, an owner-approved gate, or a private narrow update wrapper.
If a wrapper exists, it must remain scoped to its own update flow.
Wrapper implementation is private overlay unless generalized as a public-safe example.
Public Yellow-Control documents the pattern and does not deploy private wrappers.

A sanitized runtime lesson: local wrapper behavior may diverge from true gateway/process state even when service-manager status appears normal.
Therefore wrapper logic must be validated locally and treated as runtime-private implementation.

## Validation checklist

- `SKILL.md`, `references/`, and `templates/` are present after installation.
- Private register paths are configured for the runtime.
- Runtime AGENTS/SOUL adaptations are private and owner-reviewed.
- Backup/readiness gate behavior is confirmed for risky/runtime-changing actions.
- Any wrapper remains narrow-scope and non-universal.
- Dry-run governance prompts produce coherent allow/defer/block outputs.
