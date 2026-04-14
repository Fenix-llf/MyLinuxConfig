#!/usr/bin/env bash

set -euo pipefail

if [ -z "${NVIM_REPO_URL:-}" ]; then
  echo "[INFO] NVIM_REPO_URL is not set, skipping Neovim bootstrap."
  exit 0
fi

target="${NVIM_REPO_DIR:-$HOME/.config/nvim}"

if [ -d "$target" ]; then
  mv ${target} ${target}.backup
fi

mkdir -p "$(dirname "$target")"
git clone "$NVIM_REPO_URL" "$target"
