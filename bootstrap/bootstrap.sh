#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Usage: bootstrap.sh [options]

Installs apt prerequisites, Stow links, and mise-managed tools.

Options:
  --skip-apt    Skip apt prerequisites
  --skip-stow   Skip dotfile symlinking
  --skip-mise   Skip mise installation/tool installation
  -h, --help    Show this help
EOF
}

run_apt=true
run_stow=true
run_mise=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-apt) run_apt=false ;;
    --skip-stow) run_stow=false ;;
    --skip-mise) run_mise=false ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if [[ "$run_apt" == true ]]; then
  "$SCRIPT_DIR/00-apt.sh"
fi
if [[ "$run_stow" == true ]]; then
  "$SCRIPT_DIR/20-stow.sh"
fi
if [[ "$run_mise" == true ]]; then
  "$SCRIPT_DIR/10-mise-install.sh"
fi

echo "Home dotfiles bootstrap complete."
