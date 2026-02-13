#!/usr/bin/env bash
set -euo pipefail

SERVER="100.124.211.75"

DOCKER_REMOTE="${SERVER}:/srv/cache/docker"
OLLAMA_REMOTE="${SERVER}:/srv/cache/ollama"

DOCKER_MOUNT="/Volumes/cache-docker"
OLLAMA_MOUNT="/Volumes/cache-ollama"

sudo mkdir -p "$DOCKER_MOUNT" "$OLLAMA_MOUNT"

# Mount if not already mounted
if ! mount | grep -q "${DOCKER_MOUNT}"; then
  sudo mount -t nfs -o resvport,hard,intr,tcp "$DOCKER_REMOTE" "$DOCKER_MOUNT"
fi

if ! mount | grep -q "${OLLAMA_MOUNT}"; then
  sudo mount -t nfs -o resvport,hard,intr,tcp "$OLLAMA_REMOTE" "$OLLAMA_MOUNT"
fi

echo "Mounted NFS caches on macOS."
