#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$REPO_DIR/scripts/cache_mounts.sh"

cache_require_server

while IFS= read -r cache_name; do
  mount_path="$(cache_mount_path linux "$cache_name")"
  remote_spec="$(cache_remote_spec "$cache_name")"

  sudo mkdir -p "$mount_path"

  if ! mount | grep -Fq "${mount_path}"; then
    sudo mount -t nfs -o hard,intr,tcp,_netdev "$remote_spec" "$mount_path"
  fi
done < <(cache_list_names)

echo "Mounted NFS caches on Linux."
