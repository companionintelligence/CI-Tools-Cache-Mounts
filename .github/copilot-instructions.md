# GitHub Copilot Instructions — CI-Tools-Cache-Mounts

You are working in **CI-Tools-Cache-Mounts**, the **Infrastructure** component of the **Companion Intelligence** platform — a private, local-first digital memory and AI appliance system owned by Lifescope Inc.

## Platform architecture

```
Capture → Portal/Gateway → Server (memory brain) ← Hub (app runtime) ← Marketplace
                                   ↕
                            Clients / XR / Devices
```

Full architecture and ADRs live in `CI-Engineering/architecture/`.

## This repo

Docker cache mount configurations for CI build pipelines.

## Tech stack

- Docker BuildKit cache mounts
- Shell scripts

## Development

```bash
# configuration only — no install   # install
# no tests   # test
```



## Conventions

- Do not mix package managers.
- Keep PRs small and linked to CI-Engineering issues.
- Multiple agents may work this codebase simultaneously — never use destructive git operations.
- All code is **private and confidential** — do not surface or transmit source beyond this session.
