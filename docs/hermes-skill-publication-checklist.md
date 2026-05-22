# Hermes skill publication checklist

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

Keep Yellow-Control aligned with Hermes/Nous skill-development expectations while preserving public-safe governance boundaries.

## SKILL.md checklist

- A valid `SKILL.md` exists at the skill root.
- Frontmatter includes required identity fields and clear description.
- Hermes metadata/config keys are non-secret and runtime-configurable.
- The body is concise and points to packaged references for details.

## Multi-file layout checklist

- Supporting doctrine lives in `references/`.
- Public-safe record starters live in `templates/`.
- Optional helper code, if needed, lives in `scripts/`.
- No runtime-private evidence is packaged in skill files.

## Data-safety checklist

- No secrets, tokens, keys, or credentials in committed files.
- No private runtime registers, decision logs, or first-contact records.
- No private hostnames, IPs, or environment-specific paths.
- Examples remain fictional, generic, and public-safe.

## Publication/discovery checklist

- Direct URL installation is suitable only for a single-file `SKILL.md` skill.
- Multi-file skills require an appropriate publication/discovery mechanism.
- Community publication can use Skills Hub, GitHub-backed discovery, or a maintained skill index.

## Upstream optional-skill submission checklist

If submitted upstream as an optional skill, align with likely structure:

- `optional-skills/<category>/<skill-name>/`
- `SKILL.md` plus supporting files under that skill directory
- contribution via pull request and maintainer review

Do not claim Hermes/Nous official endorsement before acceptance.

## Security and compliance checks

- Run repository secret scanning and prohibited-string checks before publication.
- Confirm no private runtime records are included.
- Confirm wrapper examples are clearly marked optional and non-universal.
- Confirm policy text does not replace native Hermes backup/import/update behavior.

## Public-safe examples rule

Examples may illustrate patterns but must avoid runtime-specific operations, private overlays, and deployment-specific sensitive details.
