# Cache Mounts (NFS over Tailscale)

Automates mounting NFS cache shares from **beta-1** across macOS and Linux clients on Tailscale.

## Shares
- `beta-1` (Tailscale): `100.124.211.75`
- Exports:
  - `/srv/cache/docker`
  - `/srv/cache/ollama`

## macOS
Mount points:
- `/Volumes/cache-docker`
- `/Volumes/cache-ollama`

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
Mount points:
- `/mnt/cache/docker`
- `/mnt/cache/ollama`

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
- All scripts assume Tailscale is connected.
