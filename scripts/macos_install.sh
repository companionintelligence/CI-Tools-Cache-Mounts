#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PLIST_DIR="$HOME/Library/LaunchAgents"
PLIST_NAME="com.companionintelligence.cache-mounts.plist"
PLIST_PATH="$PLIST_DIR/$PLIST_NAME"

mkdir -p "$PLIST_DIR"

cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$PLIST_NAME</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$REPO_DIR/scripts/macos_mount.sh</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>StartInterval</key>
  <integer>300</integer>
  <key>StandardOutPath</key>
  <string>/tmp/cache-mounts.out</string>
  <key>StandardErrorPath</key>
  <string>/tmp/cache-mounts.err</string>
</dict>
</plist>
EOF

launchctl unload "$PLIST_PATH" >/dev/null 2>&1 || true
launchctl load "$PLIST_PATH"

chmod +x "$REPO_DIR/scripts/macos_mount.sh" "$REPO_DIR/scripts/macos_unmount.sh"

echo "Installed launchd job: $PLIST_NAME"
