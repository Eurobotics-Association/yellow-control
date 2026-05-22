# Runtime deployment pattern

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

This document explains how to deploy the public Yellow-Control skill package on a real Hermes runtime while keeping runtime-private enforcement and evidence outside this repository.

## Deployment boundary: public package vs private overlay

Yellow-Control is a public-safe governance doctrine and installable Hermes-compatible skill package.
The public repository provides:

- `skills/yellow-control-governance/SKILL.md` as the skill entry point;
- `skills/yellow-control-governance/references/` as packaged doctrine;
- `skills/yellow-control-governance/templates/` as public-safe record templates.

A real runtime still requires a private runtime overlay owned by the operator.
That private overlay may include runtime-specific AGENTS/SOUL adaptation, private registers, decision logs, private backup targets, and owner-approved enforcement mechanisms.

## Deployment phases

1. Install or copy `skills/yellow-control-governance/` into a Hermes-compatible skill location.
2. Verify the installed package contains `SKILL.md`, `references/`, and `templates/`.
3. Configure private runtime register paths for external-access register, governance decision records, and server-first-contact records.
4. Adapt private runtime AGENTS.md and SOUL.md only on the target runtime, not in this public repository.
5. Configure or identify an owner-approved backup/checkpoint mechanism for runtime-changing actions.
6. Optionally install a private local policy gate and private narrow wrappers as runtime implementation details.
7. Validate with dry-run governance prompts before production use.

## Sanitized runtime validation lessons

A real-runtime validation showed these architectural lessons:

- installing the public skill package alone is not sufficient for production governance;
- a private runtime overlay is required for local custody, evidence, and enforcement;
- wrappers must remain narrow and gate only their own known mutation flow;
- central local policy gates enforce backup/readiness controls;
- the agent still decides and records risk classification and whether backup evidence is required;
- if uncertain or if a specific event label is unsupported, fall back to a generic pre-runtime-change event and include the original risk context in the reason string.

## Hermes update governance lesson

Yellow-Control does not replace native Hermes update.
Yellow-Control does not ship any private Hermes update wrapper as the standard deployment mechanism.
Hermes update governance is a backup/readiness decision, not a public wrapper requirement.
A real runtime may satisfy the requirement through native Hermes backup/update behavior, an owner-approved local policy gate, or a private narrow-scope update wrapper.
If a local wrapper is used, it must gate only its own update flow and must not become the universal backup-governance engine.
Wrapper implementation remains private runtime overlay unless generalized as a public-safe example.
Public Yellow-Control documents this pattern and does not deploy private runtime wrappers.

A sanitized runtime lesson: during real validation, a local update wrapper required repair because service-manager visibility differed from actual runtime gateway/process state.
This demonstrates why wrappers are private implementation layers that must be validated locally and should not be assumed portable across runtimes.

## What must not be copied into the public repository

Do not add:

- private runtime paths or hostnames;
- private logs, decision evidence, or raw operational traces;
- backup repository names, backup archive locations, or runtime-specific backup internals;
- live runtime registers or decision records;
- production wrappers, unless rewritten as generic public-safe examples;
- secrets, tokens, keys, or credential material.

## Validation checklist

Before considering runtime deployment ready:

- skill package files are present and readable in the Hermes runtime;
- private register paths are configured;
- AGENTS/SOUL runtime alignment is complete and owner-reviewed;
- backup/readiness evidence exists for runtime-changing operations;
- any local gate/wrapper remains narrow in scope and documented as private overlay;
- dry-run prompts produce allow/defer/block decisions with public-safe telemetry.
