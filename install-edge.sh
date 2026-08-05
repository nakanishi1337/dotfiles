#!/usr/bin/env bash
# Ubuntu / shared edge computer setup (lightweight: no personal dotfiles)
set -euo pipefail

# Use sudo only when not already running as root
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
fi

# Minimal packages
$SUDO apt update
$SUDO apt install -y \
  tmux \
  unzip

# lazygit
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    $SUDO install lazygit /usr/local/bin
    rm -f lazygit lazygit.tar.gz
fi

echo "Done. (No personal dotfiles were installed; this is a shared-machine setup.)"
