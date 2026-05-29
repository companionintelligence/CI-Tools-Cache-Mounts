# AGENTS.md — CI-Tools-Cache-Mounts

## Platform context

CI-Tools-Cache-Mounts is the **Infrastructure** layer component of the Companion Intelligence platform — a private, local-first digital memory system.

Full architecture: `CI-Engineering/architecture/architecture.md`

## Repo summary

Docker cache mount configurations for CI build pipelines.

## Stack

- Docker BuildKit cache mounts
- Shell scripts

## Setup & commands

```bash
# configuration only — no install   # install
# no dev server   # dev
# no tests   # test
# mount configs used by other repos   # build
```



## Git discipline

- Never `git reset --hard` or `git clean -f` without user confirmation.
- Commit messages: imperative mood, ≤ 72 chars.
- Reference CI-Engineering issues in PRs (e.g. `Closes companionintelligence/CI-Engineering#32`).

## Confidentiality

Private & Confidential — Property of Lifescope Inc. Do not distribute.
