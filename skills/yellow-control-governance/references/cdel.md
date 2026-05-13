# CDEL: Container Delegated Execution Level

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

## Purpose

CDEL means Container Delegated Execution Level.
It classifies authority exercised through containers, sandboxes, runners, build agents, job systems, and delegated execution backends.
A container is not automatically safe because it looks isolated.
Container configuration can expose host files, host networks, process namespaces, credentials, package caches, deployment sockets, and orchestration authority.
CDEL must be classified together with ADAL, ESAL, and PCL before execution.

## Container and sandbox authority

Container authority is the set of effects the container can have outside its own filesystem.
This includes mounted host paths, network reach, forwarded credentials, Docker or Podman sockets, Kubernetes context, cloud metadata, CI variables, and runner permissions.
A low-privilege command inside a highly privileged container can still be high-risk.
A read-only analysis job can become sensitive when it mounts confidential logs or secrets.
The agent must inspect the execution boundary before trusting it.

## Docker socket risk

Access to a Docker socket or equivalent container-control socket can become host authority.
A process that can create containers with host mounts or privileged flags may be able to read host files, write host paths, control services, or escape intended constraints.
Membership in a container-control group can therefore raise ADAL as well as CDEL.
Requests to add the agent to such a group are not routine convenience changes.
Treat unknown socket access as CDEL-4 and ADAL-3 until constrained evidence exists.

## Privileged containers and host namespaces

Privileged containers, host PID namespace, host network namespace, host IPC namespace, device mounts, kernel capabilities, and writable root mounts can collapse the isolation boundary.
These configurations may be necessary for narrow administrative work, but they require human approval, rollback, and telemetry.
Do not use privileged containers for exploratory first contact.
Do not run untrusted server-supplied commands in a privileged container.
Do not pass secret-bearing mounts unless the confidentiality gate explicitly allows it.

## Host mounts

Host mounts determine what data and control surfaces the container can affect.
Read-only mounts may still disclose private data.
Writable mounts can alter repositories, service config, credentials, sockets, build outputs, and runtime state.
Mounting the workspace is usually lower risk than mounting system directories, but workspace contents can still include secrets or deployment material.
Mounting root, service directories, identity stores, SSH paths, or package manager paths raises both CDEL and ADAL.

## Secret-forwarded containers

Containers may receive secrets through environment passthrough, credential files, mounted secret stores, CI variables, cloud metadata, or runtime configuration.
Hermes documentation describes secure setup patterns where secrets are not shown to the model, but the execution environment may still receive them for tools that need them.
Yellow-Control requires secret references rather than plaintext values.
The agent must not print, commit, summarize, or include raw credential values in telemetry.
If a container may echo secrets through logs, classify PCL high and defer or block.

## CDEL level table

| Level | Meaning | Typical examples | Default decision |
| --- | --- | --- | --- |
| CDEL-0 | No delegated execution boundary. | Documentation only, local reasoning. | Allow if other gates pass. |
| CDEL-1 | User-space sandbox with no sensitive mounts, no privileged flags, and no secret forwarding. | Test container with disposable data. | Allow with scope evidence. |
| CDEL-2 | Container or runner can affect project workspace or non-secret build outputs. | Build job with workspace write access. | Defer until scope and rollback are clear. |
| CDEL-3 | Container receives secrets, service credentials, network reach, or deployment context. | CI job with deployment credential reference. | Defer for ESAL, PCL, and security approval. |
| CDEL-4 | Container has host-control surfaces. | Docker socket, privileged container, host mounts, host network/PID. | Defer for owner and security approval; often ADAL-3+. |
| CDEL-5 | Container can alter access custody, recovery, production state, or persistent automation. | Runner that rotates keys or changes cluster admin roles. | Block unless reviewed emergency procedure exists. |
| CDEL-6 | Container used to bypass governance or hide persistence. | Secret exfiltration job, self-preserving runner, unlogged privileged task. | Block. |

## Relation between CDEL and ADAL

CDEL describes the execution boundary.
ADAL describes administrative effect on hosts and authority systems.
A container with no host effect may be CDEL-1 and ADAL-0.
A container that restarts a host service through a socket may be CDEL-4 and ADAL-2.5 or ADAL-3.
A runner that changes IAM or SSH administrator keys may be CDEL-5 and ADAL-4.
Always report both when containers are involved.

## Why container access can become host authority

Container tooling often exposes management APIs that can create new containers, mount host paths, run as root, attach devices, or join host namespaces.
A user who can control those settings can often reach host files or services indirectly.
Therefore a request for “container access only” is not automatically low risk.
The agent must identify whether the delegated execution mechanism can modify the host, production service, repository, cloud account, or recovery path.

## Allow examples

A disposable test container with no secrets, no host mounts beyond the approved workspace, and no external write access may be allowed after scope and telemetry gates pass.
A read-only lint job in a CI runner may be allowed when repository policy permits it and no secrets are exposed.
A container that reads public documentation and produces local reports may be CDEL-1.

## Defer examples

A build job that writes artifacts to the workspace defers until rollback and repository gates are clear.
A runner that receives deployment credentials defers until ESAL registration, PCL handling, and security approval are documented.
A container using host network or a service socket defers until owner approval and risk classification are complete.

## Block examples

Block adding the agent to a container-control group to bypass sudo review.
Block privileged containers for first-contact exploration of an unknown target.
Block mounting identity stores or recovery material into unreviewed containers.
Block any container workflow that hides logs, persists without approval, or exfiltrates confidential data.

## Minimum evidence

Record runtime type, image or runner class, mount list category, network mode category, secret references, socket access, user identity, persistence behavior, rollback path, and telemetry identifier.
Use public-safe descriptions rather than private paths or raw secret locations.
