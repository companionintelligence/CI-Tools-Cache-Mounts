# Cache Mounts (NFS over VPN or LAN)

Automates mounting shared NFS cache exports across macOS and Linux clients over Tailscale, VPN, or LAN.

## Configure the cache server
Create a local config file before running the scripts:

```bash
cp ./cache-mounts.conf.example ./cache-mounts.conf
```

Set at least:
- `CACHE_SERVER`: hostname or IP reachable on your VPN/LAN
- `CACHE_NAMES`: caches to mount (defaults to `docker ollama npm huggingface`)
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

### Manual mount
```bash
./scripts/macos_mount.sh
```

### Manual unmount
```bash
./scripts/macos_unmount.sh
```

## Linux
### One-time install (adds to /etc/fstab + systemd automount)
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
- All scripts read `./cache-mounts.conf` if present, or you can export the same variables in your shell.
- Linux install writes the resolved server/export paths into `/etc/fstab`; rerun it after changing the config.
