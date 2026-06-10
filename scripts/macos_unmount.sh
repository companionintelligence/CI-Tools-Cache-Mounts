#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=scripts/cache_mounts.sh
source "$REPO_DIR/scripts/cache_mounts.sh"

while IFS= read -r cache_name; do
  mount_path="$(cache_mount_path macos "$cache_name")"

  if cache_is_mounted "$mount_path"; then
    if ! sudo umount "$mount_path"; then
      echo "Failed to unmount $mount_path (still in use?)" >&2
      exit 1
    fi
  fi
done < <(cache_list_names)

echo "Unmounted NFS caches on macOS."
