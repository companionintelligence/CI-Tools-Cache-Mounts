#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$REPO_DIR/scripts/cache_mounts.sh"

cache_require_server

# Ensure NFS client
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y nfs-common
fi

while IFS= read -r cache_name; do
  mount_path="$(cache_mount_path linux "$cache_name")"
  remote_spec="$(cache_remote_spec "$cache_name")"
  fstab_line="${remote_spec} ${mount_path} nfs defaults,_netdev 0 0"

  sudo mkdir -p "$mount_path"

  if ! grep -Fq "$fstab_line" /etc/fstab; then
    echo "$fstab_line" | sudo tee -a /etc/fstab >/dev/null
  fi
done < <(cache_list_names)

# Try mounting now
sudo mount -a

chmod +x "$REPO_DIR/scripts/linux_mount.sh" "$REPO_DIR/scripts/linux_unmount.sh"

echo "Installed fstab entries and mounted NFS caches on Linux."
