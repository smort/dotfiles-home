#!/usr/bin/env bash
set -euo pipefail

# WSL2/Ubuntu prerequisites that are intentionally managed by apt.
if ! command -v apt-get >/dev/null 2>&1; then
  echo "This script requires an Ubuntu/Debian environment with apt-get." >&2
  exit 1
fi

if [[ "${EUID}" -eq 0 ]]; then
  APT=(apt-get)
else
  APT=(sudo apt-get)
fi

"${APT[@]}" update
"${APT[@]}" install --yes \
  stow \
  curl \
  build-essential \
  ca-certificates \
  unzip
