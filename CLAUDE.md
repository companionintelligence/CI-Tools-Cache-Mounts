# CLAUDE.md — CI-Tools-Cache-Mounts

> **Private & Confidential — Property of Lifescope Inc. Do not distribute.**

## Platform role

**CI-Tools-Cache-Mounts** sits in the **Infrastructure** layer of the Companion Intelligence platform.

Architecture: `CI-Engineering/architecture/architecture.md`
Roadmap: `CI-Engineering/architecture/roadmap.md`
Issues: <https://github.com/companionintelligence/CI-Engineering/issues>

## What this repo does

Docker cache mount configurations for CI build pipelines.

## Stack

- Docker BuildKit cache mounts
- Shell scripts

## Key commands

```bash
# Install dependencies
# configuration only — no install

# Start development server / service
# no dev server

# Run tests
# no tests

# Build for production
# mount configs used by other repos
```

## Package manager

**bash** — use exclusively; do not mix with npm/yarn/pnpm/bun unless the repo explicitly requires it.

## Cross-repo connections

- Used by CI-Local-CICD and CI-Hub Docker builds



## Multi-agent safety

Multiple AI agents work these repos in parallel. Never use `git reset --hard`, `git clean -f`, or any destructive git command without explicit confirmation from the user.

## Confidentiality

Private & Confidential — Property of Lifescope Inc. Do not distribute.
