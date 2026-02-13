#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SERVER="100.124.211.75"

DOCKER_MOUNT="/mnt/cache/docker"
OLLAMA_MOUNT="/mnt/cache/ollama"

sudo mkdir -p "$DOCKER_MOUNT" "$OLLAMA_MOUNT"

# Ensure NFS client
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y nfs-common
fi

# Add fstab entries if missing
DOCKER_LINE="${SERVER}:/srv/cache/docker ${DOCKER_MOUNT} nfs defaults,_netdev 0 0"
OLLAMA_LINE="${SERVER}:/srv/cache/ollama ${OLLAMA_MOUNT} nfs defaults,_netdev 0 0"

if ! grep -q "/srv/cache/docker" /etc/fstab; then
  echo "$DOCKER_LINE" | sudo tee -a /etc/fstab >/dev/null
fi

if ! grep -q "/srv/cache/ollama" /etc/fstab; then
  echo "$OLLAMA_LINE" | sudo tee -a /etc/fstab >/dev/null
fi

# Try mounting now
sudo mount -a

chmod +x "$REPO_DIR/scripts/linux_mount.sh" "$REPO_DIR/scripts/linux_unmount.sh"

echo "Installed fstab entries and mounted NFS caches on Linux."
