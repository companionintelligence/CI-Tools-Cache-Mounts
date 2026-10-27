<h1 align="center">Cache Mounts (NFS over VPN or LAN)</h1>

<p align="center"><strong>Automates mounting shared NFS cache exports across macOS and Linux clients over Tailscale, VPN, or LAN.</strong></p>

<p align="center"><a href="https://github.com/companionintelligence/CI-Tools-Cache-Mounts">Source</a></p>


## Configure the cache server
Create a local config file before running the scripts:

```bash
cp ./cache-mounts.conf.example ./cache-mounts.conf
```

Set at least:
- `CACHE_SERVER`: hostname or IP reachable on your VPN/LAN
- `CACHE_NAMES`: caches to mount, separated by spaces or commas (defaults to `docker ollama npm huggingface`)
- `CACHE_EXPORT_BASE`: export root on the server (defaults to `/srv/cache`)

You can also override individual exports or mount points with variables such as:
- `CACHE_EXPORT_DOCKER`
- `CACHE_EXPORT_HUGGINGFACE`
- `CACHE_MOUNT_HUGGINGFACE`

## Default cache layout
- Exports: `/srv/cache/<name>`
- Linux mounts: `/mnt/cache/<name>`
- macOS mounts: `/Volumes/cache-<name>`

Out of the box, the example config covers:
- Docker caches
- Ollama models
- npm caches
- Hugging Face caches

## macOS
### One-time install (creates launchd job for auto-mount)
```bash
./scripts/macos_install.sh
```

> The launchd job re-runs `macos_mount.sh` every 5 minutes as your user. Because the
> mount script calls `sudo`, unattended re-mounts only work if your user has
> passwordless sudo for `mount`/`mkdir`; otherwise use the manual mount commands.

### Manual mount
```bash
./scripts/macos_mount.sh
```

### Manual unmount
```bash
./scripts/macos_unmount.sh
```

## Linux
### One-time install (adds /etc/fstab entries with `_netdev` and mounts now)
```bash
./scripts/linux_install.sh
```

### Manual mount
```bash
./scripts/linux_mount.sh
```

### Manual unmount
```bash
./scripts/linux_unmount.sh
```

## Notes
- Requires NFS client packages:
  - macOS: built-in
  - Ubuntu/Debian: `sudo apt-get install -y nfs-common`
- All scripts read `cache-mounts.conf` from the repo root if present (regardless of the
  directory you run them from). Set `CACHE_MOUNTS_CONFIG=/path/to/conf` to use a different
  file, or export the same variables in your shell.
- Linux install writes the resolved server/export paths into `/etc/fstab`; rerun it after changing the config.

## Hub container (status page)

The CI Hub marketplace app `ci-tools-cache-mounts` runs
`ghcr.io/companionintelligence/ci-tools-cache-mounts` (built from the `Dockerfile` in this
repo). It serves only the static status/reference page in `status/` — the actual NFS
mounts are configured host-side with the scripts above; a container cannot create host
mounts. Treat the container as an install confirmation plus quick-reference card.
