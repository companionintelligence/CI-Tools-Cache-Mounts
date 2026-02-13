# Cache + Model Infrastructure Docs

This folder documents how the **beta-1** NFS cache server integrates with Docker image workflows and Ollama model storage across the Tailscale network.

## Contents
- [Docker Cache Strategy](./docker-cache.md)
- [Ollama Model Cache](./ollama-cache.md)
- [Operations & Troubleshooting](./ops.md)

## Topology (summary)
- **Server:** beta-1 (Ubuntu 24.04)
- **Tailscale IP:** `100.124.211.75`
- **NFS exports:**
  - `/srv/cache/docker`
  - `/srv/cache/ollama`
- **Client mount points:**
  - macOS: `/Volumes/cache-docker`, `/Volumes/cache-ollama`
  - Linux: `/mnt/cache/docker`, `/mnt/cache/ollama`

## Why NFS?
NFS gives a simple, fast, multi-client shared storage layer across Tailscale. It’s well-suited for:
- Docker **volume-level** caches (build context, custom caches)
- Shared **Ollama** model storage

If you want true **Docker registry layer caching**, use the registry proxy approach documented in [Docker Cache Strategy](./docker-cache.md).
