#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Usage: bootstrap.sh [options]

Installs the apt prerequisites, Homebrew packages, and Stow links.
Homebrew/Linuxbrew must be installed separately first.

Options:
  --skip-apt    Skip apt prerequisites
  --skip-brew   Skip Brewfile installation
  --skip-stow   Skip dotfile symlinking
  -h, --help    Show this help
EOF
}

run_apt=true
run_brew=true
run_stow=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-apt) run_apt=false ;;
    --skip-brew) run_brew=false ;;
    --skip-stow) run_stow=false ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if [[ "$run_apt" == true ]]; then
  "$SCRIPT_DIR/00-apt.sh"
fi
if [[ "$run_brew" == true ]]; then
  "$SCRIPT_DIR/10-brew-bundle.sh"
fi
if [[ "$run_stow" == true ]]; then
  "$SCRIPT_DIR/20-stow.sh"
fi

echo "Home dotfiles bootstrap complete."
