#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
BREWFILE="$REPO_DIR/Brewfile"

if ! command -v brew >/dev/null 2>&1; then
  cat >&2 <<'EOF'
Homebrew/Linuxbrew was not found.

Install Linuxbrew first, then run this script again:
  https://brew.sh
EOF
  exit 1
fi

if [[ ! -f "$BREWFILE" ]]; then
  echo "Missing Brewfile: $BREWFILE" >&2
  exit 1
fi

brew bundle --file="$BREWFILE"
