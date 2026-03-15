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

cache_var_suffix() {
  echo "$1" | tr '[:lower:]/-' '[:upper:]__'
}

cache_list_names() {
  printf '%s\n' "$CACHE_NAMES" | tr ', ' '\n\n' | sed '/^$/d'
}

cache_require_server() {
  if [[ -z "$CACHE_SERVER" ]]; then
    echo "CACHE_SERVER is not set. Export it or create $CACHE_MOUNTS_CONFIG." >&2
    exit 1
  fi
}

cache_export_path() {
  local name="$1"
  local suffix="CACHE_EXPORT_$(cache_var_suffix "$name")"
  echo "${!suffix:-$CACHE_EXPORT_BASE/$name}"
}

cache_mount_path() {
  local platform="$1"
  local name="$2"
  local suffix="CACHE_MOUNT_$(cache_var_suffix "$name")"

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
