#!/usr/bin/env bash
set -euo pipefail

# Install mise itself if this is a fresh machine, then install all tools from
# ~/.config/mise/config.toml (created by bootstrap/20-stow.sh).
if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

export PATH="$HOME/.local/bin:$PATH"

if ! command -v mise >/dev/null 2>&1; then
  echo "mise was installed but is not on PATH." >&2
  exit 1
fi

MISE_CONFIG="$HOME/.config/mise/config.toml"
if [[ ! -f "$MISE_CONFIG" ]]; then
  echo "Missing mise config: $MISE_CONFIG" >&2
  echo "Run bootstrap/20-stow.sh first." >&2
  exit 1
fi

mise install --yes
