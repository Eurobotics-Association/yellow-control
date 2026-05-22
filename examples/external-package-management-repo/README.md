# External package-management repository skeleton (example)

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

This directory is a public-safe example skeleton only.
It is not an installer.
It does not install packages.
It is not a real external package repository.

Real package-management repositories are private runtime implementation layers owned by operators.
Use fictional placeholders only when adapting these examples.

## Included example files

- `package-register.example.yaml`: example package metadata register with governance attributes.
- `targets.example.yaml`: example target classes and package-use constraints.
- `approval-flow.example.md`: example owner/security approval flow.

## Governance integration note

Yellow-Control may point to private package metadata using `external_package_ref` in external-access and decision records.
A reference does not authorize install/upgrade by itself; package actions require separate classification and approval.
