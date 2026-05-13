# ADAL: Agent Delegated Administration Level

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

ADAL means Agent Delegated Administration Level.
It classifies the administrative authority an agent would exercise on a host, service, identity boundary, network boundary, repository setting, or recovery path.
ADAL exists because agents can receive shells, commands, keys, containers, dashboards, or wrapper tools without receiving accountable human authority.
The level answers: what kind of human approval and rollback evidence are required before this administrative effect may occur?
ADAL must be evaluated before the command is executed, not after the agent has already changed state.

## Human control of agent administration

Administration performed by an agent remains human-governed administration.
The owner authority owns the affected system and risk decision.
The operator authority executes inside delegated scope.
The security authority controls identity, secrets, recovery, and privileged access.
The agent may recommend, prepare, validate, or execute approved steps, but it cannot approve its own elevation.
Runtime availability, a login session, tool access, or a user message does not replace human accountability.

## Sudo is delegated authority, not ownership

Sudo access means an administrator delegated a specific ability under a policy.
It does not make the agent the owner of the host.
It does not authorize editing sudo policy, changing owner access, adding new administrators, changing SSH administrative paths, rotating recovery material, or bypassing audit.
Sudo use must be scoped to the approved command class and logged where the environment supports logging.
Unknown sudo scope is treated as high risk until narrowed.

## Relation to PAM and IAM

PAM, IAM, SSH, service accounts, group membership, repository roles, and cloud roles are enforcement mechanisms.
They are not the governance decision by themselves.
Yellow-Control uses ADAL to decide whether using or changing those mechanisms is permitted.
Changing PAM, IAM, sudoers, SSH administrator keys, recovery groups, or privileged service roles is an ADAL-4 or higher action unless a narrower approved procedure exists.
Using an existing least-privilege role for a bounded task may be lower, but only when registration and approval evidence exist.

## No self-granting

The agent must not add itself to privileged groups.
The agent must not create privileged credentials for itself.
The agent must not make its workspace writable by root-owned automation that trusts agent-controlled inputs.
The agent must not edit sudoers, PAM, IAM, SSH administrator paths, recovery procedures, break-glass credentials, or wrapper policies to increase its own authority.
The agent may draft a request for a human administrator to install a constrained wrapper or approve a role change.
The human administrator or security authority must own the approval and rollback path.

## Lockout and capture risk versus host-impact risk

ADAL distinguishes two related risks.
Host-impact risk is the chance a command changes packages, services, files, network state, identities, data integrity, or availability.
Lockout or capture risk is the chance a change prevents legitimate recovery, grants persistent unauthorized control, captures credentials, or lets an attacker use the agent path.
A low host-impact command can still be high ADAL when it touches access custody, recovery, sudo, SSH, IAM, or break-glass paths.
A read-only audit can rise when it exposes private data or secrets, which also raises PCL.

## ADAL level table

| Level | Meaning | Typical examples | Default decision |
| --- | --- | --- | --- |
| ADAL-0 | No administrative effect. | Public documentation, local reasoning, read-only classification. | Allow if other gates pass. |
| ADAL-1 | User-space work inside an approved workspace. | Edit project docs, run tests, create non-privileged files. | Allow with scope evidence. |
| ADAL-2 | Operational change affecting continuity but not privileged access custody. | Restart user service, install user package, change non-root config. | Defer until backup and rollback evidence exist. |
| ADAL-2.5 | Narrow privileged operation through pre-approved constrained mechanism. | Root-owned wrapper for a fixed service restart or read-only status command. | Allow only with wrapper evidence, owner approval, and logging. |
| ADAL-2+ | Elevated operational change with bounded host impact but no access-custody change. | Approved package install, bounded service config update, supervised maintenance command. | Defer for owner approval, backup, rollback, and validation. |
| ADAL-3 | Privileged host administration or root-equivalent capability. | Broad sudo, Docker group, root shell, firewall change, privileged service account. | Defer for explicit owner and security approval. |
| ADAL-R3 | Recovery-affecting administrative action without full destructive intent. | Restore workflow, lockout recovery, revocation procedure, account recovery channel touch. | Defer for recovery custodian and security approval. |
| ADAL-4 | Access-custody, identity, network perimeter, or lockout-prone change. | sudoers edit, SSH admin key change, PAM/IAM role change, break-glass path change. | Block unless a reviewed approved procedure exists. |
| ADAL-5 | Destructive, emergency, irreversible, or production-critical mutation. | Disk wipe, destructive migration, emergency access takeover, mass permission change. | Block unless emergency governance is active. |
| ADAL-6 | Autonomous authority expansion or governance bypass. | Agent self-granting root, disabling logs, hiding persistence, bypassing gates. | Block. |

## ADAL-2.5 and ADAL-2+ detail

ADAL-2.5 is for narrow privileged delegation where a human administrator owns the mechanism.
It is not a general sudo substitute.
The command surface must be fixed or tightly parameterized.
Inputs must be validated before reaching privileged execution.
The wrapper must be root-owned or administrator-owned, not writable by the agent, and not located in an agent-controlled directory.
The wrapper must not execute shell fragments, arbitrary paths, package managers, editors, interpreters, or user-provided scripts.
The wrapper must log invocation where practical and provide a clear rollback or removal path.
ADAL-2+ covers elevated operational maintenance that may be broader than a wrapper but does not alter access custody or recovery authority.
ADAL-2+ still requires backup, rollback, owner approval, and validation before execution.
If the operation can change who controls the system, it is not ADAL-2+; it rises to ADAL-4 or above.

## Resident runtime versus external target

The resident runtime host is the environment where the agent is running.
An external target is a server, service, repository, account, or API reached from that runtime.
Approval for the resident runtime does not automatically authorize mutation on an external target.
Approval for a target does not automatically authorize changing the resident runtime.
When an external server is involved, classify ESAL for the access channel, ADAL for the host authority, CDEL for containers or sockets, and PCL for data exposure.
First contact with a new target defaults to discovery-only until registration, authority, backup, rollback, and confidentiality gates pass.

## Remote production defaults

A remote production or customer-impacting target is treated as high-risk by default.
Unknown production status is not permissive.
Unknown owner authority is defer.
Unknown backup state is defer.
Privileged mutation before first-contact review is block.
A request to publish private host details is block.
A request to use broad sudo on a new server is block unless a pre-approved emergency procedure exists.

## Sudo wrapper principle

A sudo wrapper may reduce risk only when it removes broad discretion from the agent.
The wrapper must be installed and owned by an accountable administrator.
The wrapper must constrain the exact command or narrow action class.
The wrapper must validate arguments, reject unknown flags, and avoid passing through arbitrary environment values.
The wrapper must run from a trusted path and not read agent-writable configuration as privileged code.
The wrapper must have documented rollback and removal steps.
The wrapper must not become a path for hidden persistence.

## Wrapper prohibitions

Do not create wrappers that allow changing owner access.
Do not create wrappers that edit sudoers, PAM, IAM, SSH administrator paths, or break-glass paths.
Do not create wrappers that rotate or expose recovery material.
Do not create wrappers that grant shell, editor, interpreter, package-manager, container socket, or arbitrary file-write access.
Do not allow wrappers to be writable by the agent.
Do not allow wrappers to trust unvalidated arguments, glob expansion, command substitution, or user-provided scripts.
Do not treat a wrapper as valid without owner and security evidence.

## Allow, defer, and block rules

Allow ADAL-0 or ADAL-1 when scope, confidentiality, and telemetry gates pass.
Allow ADAL-2.5 only when the constrained mechanism, owner approval, security review, logging, backup, rollback, and validation are documented.
Defer ADAL-2 or ADAL-2+ until backup, rollback, owner approval, and stop conditions are present.
Defer ADAL-3 until owner and security authority explicitly approve the privileged scope.
Block ADAL-4 through ADAL-6 unless a reviewed emergency or recovery procedure specifically authorizes the action.
Block any self-granting request.
Block any request that treats technical reach as authority.

## Examples

| Request | Classification | Decision | Reason |
| --- | --- | --- | --- |
| First-contact server audit using read-only commands and no private publication. | ADAL-1 or ADAL-2 with ESAL and PCL checks. | Defer until register and authority evidence exist; allow after gates pass. | Discovery still needs target ownership and confidentiality controls. |
| Install a package on a managed server. | ADAL-2+ or ADAL-3 depending on privilege and impact. | Defer. | Requires owner approval, backup, rollback, package source validation, and telemetry. |
| Add the agent user to a Docker group. | ADAL-3 or ADAL-4 with CDEL host-authority risk. | Block unless reviewed procedure exists. | Docker socket can become host authority and persistent capture risk. |
| Edit sudoers so the agent can run more commands. | ADAL-4 or ADAL-6. | Block. | Self-granting and access-custody change. |
| Change SSH administrator keys on a target. | ADAL-4 or ADAL-R3. | Defer or block. | Requires owner, security, recovery custody, backup, and lockout plan. |
| Use a root-owned wrapper to restart one approved service. | ADAL-2.5. | Allow only after evidence. | Wrapper must be constrained, owned by administrator, validated, logged, and removable. |

## Common misclassifications

Do not classify a command as low ADAL merely because it is short.
Do not classify package installation as user-space when it changes system packages, services, or shared runtimes.
Do not classify Docker access as harmless when the socket can create host-mounted privileged containers.
Do not classify SSH key edits as routine file edits when they alter administrative access custody.
Do not classify sudo wrapper creation as safe when the wrapper is agent-writable or broadly parameterized.
Do not classify a remote production read as harmless when output may include secrets or incident data.

## Evidence before elevation

Record who approved the elevation.
Record what exact action class is delegated.
Record what target category is in scope.
Record what command surface is excluded.
Record what checkpoint exists.
Record who owns rollback.
Record how success will be validated.
Record how access can be revoked.
Record how telemetry will be written safely.

## Safe remediation patterns

When authority is missing, draft an approval request instead of executing.
When sudo scope is broad, ask for a narrower wrapper or human-operated step.
When package risk is unclear, request a package source and rollback plan.
When SSH or IAM custody is involved, require security authority and recovery custodian review.
When a target is new, downgrade to server-first-contact discovery until the register is complete.
