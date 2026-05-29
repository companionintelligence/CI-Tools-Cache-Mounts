# ANTIGRAVITY.md — CI-Tools-Cache-Mounts

## Context

**CI-Tools-Cache-Mounts** — **Infrastructure** layer of the Companion Intelligence platform (Lifescope Inc).

Architecture: `CI-Engineering/architecture/architecture.md`
Roadmap: `CI-Engineering/architecture/roadmap.md`

## Purpose

Docker cache mount configurations for CI build pipelines.

## Stack

- Docker BuildKit cache mounts
- Shell scripts

## Commands

```bash
# configuration only — no install
# no dev server
# no tests
```

## Rules

- Package manager: do not switch or mix.
- Destructive git operations (`reset --hard`, `clean -f`) require explicit user confirmation.
- Commits reference CI-Engineering issues.
- All content is **private and confidential** — Property of Lifescope Inc.
