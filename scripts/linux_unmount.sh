#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$REPO_DIR/scripts/cache_mounts.sh"

while IFS= read -r cache_name; do
  mount_path="$(cache_mount_path linux "$cache_name")"

  if mount | grep -Fq "${mount_path}"; then
    sudo umount "$mount_path"
  fi
done < <(cache_list_names)

echo "Unmounted NFS caches on Linux."
