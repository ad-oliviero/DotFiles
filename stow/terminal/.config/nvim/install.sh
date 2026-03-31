#!/usr/bin/bash

set -e

ARCH=$(uname -m)
case "$ARCH" in
    x86_64|amd64)
        NVIM_ARCH="x86_64"
        ;;
    aarch64|arm64)
        NVIM_ARCH="arm64"
        ;;
    *)
        echo "Error: Unsupported architecture ($ARCH)."
        exit 1
        ;;
esac

TAR_FILE="nvim-linux-${NVIM_ARCH}.tar.gz"
DOWNLOAD_URL="https://github.com/neovim/neovim/releases/latest/download/${TAR_FILE}"

INSTALL_DIR="$HOME/.local/share/nvim"
BIN_DIR="$HOME/.local/bin"
TMP_DIR=$(mktemp -d)
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

cd "$TMP_DIR"

curl -LO "$DOWNLOAD_URL"
tar -C "$INSTALL_DIR" --strip-components=1 -xzf "$TAR_FILE"

ln -sf "${INSTALL_DIR}/bin/nvim" "${BIN_DIR}/nvim"

cd - > /dev/null
rm -rf "$TMP_DIR"

"${BIN_DIR}/nvim" --version | head -n 1
