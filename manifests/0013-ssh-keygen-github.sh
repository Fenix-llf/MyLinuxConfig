#!/usr/bin/env bash
set -euo pipefail

KEY_PATH="${HOME}/.ssh/github"
PUB_KEY_PATH="${KEY_PATH}.pub"

if [ -r /etc/os-release ]; then
  . /etc/os-release
  OS_NAME="${NAME:-Linux}"
else
  OS_NAME="Linux"
fi

COMMENT="${ID^}@$(hostname)"

mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"

if [ -f "$KEY_PATH" ] || [ -f "$PUB_KEY_PATH" ]; then
  echo "密钥已存在：$KEY_PATH"
  echo "如需重新生成，请先删除旧文件："
  echo "  rm -f $KEY_PATH $PUB_KEY_PATH"
  exit 1
fi

ssh-keygen -t rsa -C "$COMMENT" -f "$KEY_PATH" -N ""

chmod 600 "$KEY_PATH"
chmod 644 "$PUB_KEY_PATH"

echo
echo "SSH 密钥已生成："
echo "  私钥: $KEY_PATH"
echo "  公钥: $PUB_KEY_PATH"
echo "  注释: $COMMENT"
echo
echo "下面是公钥内容，复制到 GitHub SSH keys："
echo "--------------------------------------------------"
cat "$PUB_KEY_PATH"
echo
echo "--------------------------------------------------"
