#!/usr/bin/env bash
set -euo pipefail

DOCKER_MOUNT="/mnt/cache/docker"
OLLAMA_MOUNT="/mnt/cache/ollama"

if mount | grep -q "${DOCKER_MOUNT}"; then
  sudo umount "$DOCKER_MOUNT"
fi

if mount | grep -q "${OLLAMA_MOUNT}"; then
  sudo umount "$OLLAMA_MOUNT"
fi

echo "Unmounted NFS caches on Linux."
