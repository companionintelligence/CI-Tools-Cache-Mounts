#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=scripts/cache_mounts.sh
source "$REPO_DIR/scripts/cache_mounts.sh"

cache_require_server

# Ensure NFS client
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y nfs-common
fi

if [[ -f /etc/fstab ]]; then
  sudo cp /etc/fstab "/etc/fstab.cache-mounts.bak.$(date +%Y%m%d%H%M%S)"
fi

while IFS= read -r cache_name; do
  mount_path="$(cache_mount_path linux "$cache_name")"
  remote_spec="$(cache_remote_spec "$cache_name")"
  fstab_line="${remote_spec} ${mount_path} nfs defaults,_netdev 0 0"

  sudo mkdir -p "$mount_path"

  if ! awk -v remote="$remote_spec" -v mount="$mount_path" '
    $1 == remote && $2 == mount { found=1; exit }
    END { exit !found }
  ' /etc/fstab; then
    tmp_fstab="$(sudo mktemp /run/cache-mounts-fstab.XXXXXX)"
    sudo chmod 600 "$tmp_fstab"
    if [[ -f /etc/fstab ]]; then
      awk -v mount="$mount_path" '$2 != mount { print }' /etc/fstab | sudo tee "$tmp_fstab" >/dev/null
    fi
    printf '%s\n' "$fstab_line" | sudo tee -a "$tmp_fstab" >/dev/null
    # tmp_fstab is root-owned 600; an unprivileged redirect (`< file`) cannot
    # read it, so install it into place with root privileges instead (SC2024).
    sudo install -m 644 "$tmp_fstab" /etc/fstab
    sudo rm -f "$tmp_fstab"
  fi
done < <(cache_list_names)

# Try mounting now
if ! sudo mount -a; then
  echo "mount -a failed; check that $CACHE_SERVER is reachable and exporting the cache paths." >&2
  exit 1
fi

chmod +x "$REPO_DIR/scripts/linux_mount.sh" "$REPO_DIR/scripts/linux_unmount.sh"

echo "Installed fstab entries and mounted NFS caches on Linux."
