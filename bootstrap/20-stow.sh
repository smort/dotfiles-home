#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is not installed. Run bootstrap/00-apt.sh first." >&2
  exit 1
fi

cd "$REPO_DIR"
stow --restow git lazygit ssh starship zsh mise
