# External server operations control plane

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

This document explains how Yellow-Control governs external server operations for sysadmins, sysops, and cyberops when Hermes runtimes perform real work through SSH, API, repository, dashboard, or service-account access.

## Control-plane model for external server work

Yellow-Control separates technical reach from accountable authority.
A session, key, token, or command path can permit technical action, but governance authority must be established and recorded before mutation.

External server work is governed by a human-controlled decision flow with ADAL/CDEL/ESAL/PCL classification, gate checks, and explicit allow/defer/block outcomes.

## Required flow before mutation

1. Register or draft an external-access entry in the external-access register.
2. Perform `server-first-contact` discovery only (no mutation).
3. Classify ADAL, CDEL, ESAL, and PCL for the requested operation.
4. Check authority, allowed actions, forbidden actions, backup/rollback readiness, recovery custody, confidentiality constraints, and telemetry requirements.
5. Return allow, defer, or block.
6. Execute approved operational work only after allow.

## SSH governance baseline

- SSH key/session access is technical reach, not authority.
- No broad sudo by default.
- No sudo shell.
- No package install during first contact unless separately approved.
- No SSH admin-path change (for example sudoers, PAM/IAM-related SSH trust, access-control path, or key-trust path changes) without high-ADAL review.

## Elevation governance baseline

A constrained wrapper can reduce risk only if it is:

- owner-installed;
- not agent-writable;
- narrow in allowed actions;
- logged for governance telemetry;
- removable without hidden lock-in.

Classify and gate before execution when tasks include package installation, service mutation, systemd changes, sudoers changes, PAM/IAM changes, SSH-key trust changes, Docker socket access, or recovery-path modifications.

## Backup and rollback controls

Risky mutation requires backup/readiness evidence before execution.
Local-only backup is treated as degraded or break-glass posture unless explicitly owner-approved for the specific operation.

## External package-management integration

External package-management repositories are separate/private implementation layers.
Yellow-Control may reference that private layer through `external_package_ref` in governance records.
Package install and package upgrade actions must be classified and approved separately from connectivity or first-contact discovery.

## Public-safe telemetry expectations

Record public-safe governance telemetry for:

- requested operation summary;
- ADAL/CDEL/ESAL/PCL classification;
- authority evidence and approval state;
- backup/rollback readiness state;
- allow/defer/block outcome and rationale.

Do not store credentials, raw secrets, private host internals, or private operational traces in public artifacts.
