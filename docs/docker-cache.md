# Docker Cache Strategy

## Two levels of “cache”

### 1) **Shared volume cache (current setup)**
Mount the shared Docker cache export (for example `/srv/cache/docker`) onto clients. This is best for:
- Build caches you control (e.g., BuildKit cache directories)
- Shared artifacts and large files across machines

**Pros:**
- Simple, fast, no extra services
- Works across macOS/Linux clients

**Cons:**
- **Not** a Docker image layer cache by itself
- Docker *does not* reuse layers from an arbitrary directory unless configured

#### Use with BuildKit (recommended)
Example: build with cache-to/cache-from on the shared NFS path.

```bash
docker buildx build \
  --cache-to type=local,dest=/mnt/cache/docker/buildkit \
  --cache-from type=local,src=/mnt/cache/docker/buildkit \
  -t myimage:latest .
```

---

### 2) **Registry proxy cache (optional upgrade)**
If you want **actual Docker image layer caching**, you can run a registry proxy on your cache server. This caches image layers pulled from Docker Hub/GHCR.

#### Example (docker registry proxy)
```yaml
# docker-compose.yml on the cache server
services:
  registry:
    image: registry:2
    ports:
      - "5000:5000"
    environment:
      REGISTRY_PROXY_REMOTEURL: https://registry-1.docker.io
    volumes:
      - /srv/cache/docker/registry:/var/lib/registry
```

Then on clients:
```json
// /etc/docker/daemon.json
{
  "registry-mirrors": ["http://CACHE_SERVER:5000"]
}
```

Restart Docker and pulls will be cached.

**Pros:**
- Real layer caching
- Speeds up `docker pull` and builds

**Cons:**
- Adds a service to manage
- Not officially supported for all registries

---

## Recommended approach
Start with **shared BuildKit cache** on `/srv/cache/docker`. If you see repeated network downloads for base images, add the registry mirror later.
