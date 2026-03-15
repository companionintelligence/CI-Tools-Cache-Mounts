# Cache + Model Infrastructure Docs

This folder documents how a shared NFS cache server can integrate with Docker image workflows and model storage across a VPN or LAN.

## Contents
- [Docker Cache Strategy](./docker-cache.md)
- [Ollama Model Cache](./ollama-cache.md)
- [Operations & Troubleshooting](./ops.md)

## Topology (summary)
- **Server:** any reachable hostname or IP in `cache-mounts.conf`
- **Default NFS export root:** `/srv/cache`
- **Default caches:** `docker`, `ollama`, `npm`, `huggingface`
- **Client mount points:**
  - macOS: `/Volumes/cache-<name>`
  - Linux: `/mnt/cache/<name>`

## Why NFS?
NFS gives a simple, fast, multi-client shared storage layer across Tailscale. It’s well-suited for:
- Docker **volume-level** caches (build context, custom caches)
- Shared **Ollama** model storage
- Shared package/model caches such as **npm** and **Hugging Face**

If you want true **Docker registry layer caching**, use the registry proxy approach documented in [Docker Cache Strategy](./docker-cache.md).
