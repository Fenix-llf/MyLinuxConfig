#!/usr/bin/env bash
set -euo pipefail

ZSH_DIR="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_DIR}/custom"
ZSHRC="${HOME}/.zshrc"

echo "[1/4] 安装依赖..."
sudo apt update
sudo apt install -y zsh git curl

echo "[2/4] 安装 oh-my-zsh..."
if [ ! -d "$ZSH_DIR" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "oh-my-zsh 已存在，跳过安装"
fi

echo "[3/4] 克隆插件..."
mkdir -p "${ZSH_CUSTOM}/plugins"

if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
else
  echo "zsh-autosuggestions 已存在，跳过"
fi

if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
else
  echo "zsh-syntax-highlighting 已存在，跳过"
fi


echo "[4/4] 设置默认 shell 为 zsh ..."
if [ "${SHELL:-}" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)" || true
fi

