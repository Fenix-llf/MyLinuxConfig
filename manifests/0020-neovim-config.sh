#!/usr/bin/env bash


set -euo pipefail

INSTALL_DIR="/opt/nvim"
TMP_DIR="$(mktemp -d)"
PKG="nvim-linux-x86_64.tar.gz"
URL="https://github.com/neovim/neovim/releases/latest/download/${PKG}"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Downloading latest Neovim for linux x86_64..."
curl -fL "$URL" -o "$TMP_DIR/$PKG"

echo "Extracting..."
tar -xzf "$TMP_DIR/$PKG" -C "$TMP_DIR"

EXTRACTED_DIR="$TMP_DIR/nvim-linux-x86_64"
if [ ! -d "$EXTRACTED_DIR" ]; then
  echo "Extraction failed: $EXTRACTED_DIR not found"
  exit 1
fi

echo "Installing to $INSTALL_DIR ..."
sudo rm -rf "$INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"
sudo cp -a "$EXTRACTED_DIR"/. "$INSTALL_DIR"/

echo
echo "Installed successfully."
echo "Binary: $INSTALL_DIR/bin/nvim"
echo

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
