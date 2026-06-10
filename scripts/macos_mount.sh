#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=scripts/cache_mounts.sh
source "$REPO_DIR/scripts/cache_mounts.sh"

cache_require_server

while IFS= read -r cache_name; do
  mount_path="$(cache_mount_path macos "$cache_name")"
  remote_spec="$(cache_remote_spec "$cache_name")"

  sudo mkdir -p "$mount_path"

  if ! cache_is_mounted "$mount_path"; then
    if ! sudo mount -t nfs -o resvport,hard,intr,tcp "$remote_spec" "$mount_path"; then
      echo "Failed to mount $remote_spec at $mount_path" >&2
      exit 1
    fi
  fi
done < <(cache_list_names)

echo "Mounted NFS caches on macOS."
