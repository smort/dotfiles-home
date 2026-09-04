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

# Antidote is a small Zsh plugin manager used for optional shell niceties such
# as syntax highlighting. Keep it outside brew/mise package management so this
# setup does not depend on Homebrew.
ANTIDOTE_DIR="$HOME/.local/share/antidote"
if [[ ! -d "$ANTIDOTE_DIR/.git" ]]; then
  rm -rf "$ANTIDOTE_DIR"
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
else
  git -C "$ANTIDOTE_DIR" pull --ff-only
fi
