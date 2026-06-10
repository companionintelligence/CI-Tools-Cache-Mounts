#!/usr/bin/env bash

CACHE_MOUNTS_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_MOUNTS_REPO_DIR="$(cd "$CACHE_MOUNTS_LIB_DIR/.." && pwd)"
CACHE_MOUNTS_CONFIG="${CACHE_MOUNTS_CONFIG:-$CACHE_MOUNTS_REPO_DIR/cache-mounts.conf}"

if [[ -f "$CACHE_MOUNTS_CONFIG" ]]; then
  # shellcheck source=/dev/null
  source "$CACHE_MOUNTS_CONFIG"
fi

CACHE_SERVER="${CACHE_SERVER:-}"
CACHE_EXPORT_BASE="${CACHE_EXPORT_BASE:-/srv/cache}"
CACHE_NAMES="${CACHE_NAMES:-docker ollama npm huggingface}"

# Converts cache names like "my-cache" or "models/hf" into override suffixes
# such as "MY_CACHE" and "MODELS_HF" for CACHE_EXPORT_* and CACHE_MOUNT_*.
cache_var_suffix() {
  echo "$1" | tr '[:lower:]/-' '[:upper:]__'
}

cache_list_names() {
  local names="${CACHE_NAMES//,/ }"
  local -a cache_names=()
  local name

  read -r -a cache_names <<<"$names"

  for name in "${cache_names[@]}"; do
    printf '%s\n' "$name"
  done
}

cache_require_server() {
  if [[ -z "$CACHE_SERVER" ]]; then
    echo "CACHE_SERVER is not set. Export it or create $CACHE_MOUNTS_CONFIG (for example: cp $CACHE_MOUNTS_REPO_DIR/cache-mounts.conf.example $CACHE_MOUNTS_CONFIG)." >&2
    exit 1
  fi
}

cache_export_path() {
  local name="$1"
  local suffix
  suffix="CACHE_EXPORT_$(cache_var_suffix "$name")"
  echo "${!suffix:-$CACHE_EXPORT_BASE/$name}"
}

cache_mount_path() {
  local platform="$1"
  local name="$2"
  local suffix
  suffix="CACHE_MOUNT_$(cache_var_suffix "$name")"

  if [[ -n "${!suffix:-}" ]]; then
    echo "${!suffix}"
    return
  fi

  case "$platform" in
    linux)
      echo "/mnt/cache/$name"
      ;;
    macos)
      echo "/Volumes/cache-$name"
      ;;
    *)
      echo "Unsupported platform: $platform" >&2
      exit 1
      ;;
  esac
}

cache_remote_spec() {
  local name="$1"
  echo "${CACHE_SERVER}:$(cache_export_path "$name")"
}

# True if something is already mounted at the given path. Anchors the match on
# the " on <path> " portion of `mount` output so /mnt/cache/foo does not match
# /mnt/cache/foo-bar (works for both Linux and macOS mount formats).
cache_is_mounted() {
  local mount_path="$1"
  mount | grep -Fq " on ${mount_path} "
}
