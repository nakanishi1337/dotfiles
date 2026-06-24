#!/usr/bin/env bash
# Ubuntu / remote server dotfiles setup
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Use sudo only when not already running as root
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
fi

# Install GitHub CLI (gh) from the official apt repository
if ! command -v gh >/dev/null 2>&1; then
  type -p wget >/dev/null || { $SUDO apt update && $SUDO apt install -y wget; }
  $SUDO mkdir -p -m 755 /etc/apt/keyrings
  out="$(mktemp)"
  wget -nv -O "$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg
  $SUDO tee /etc/apt/keyrings/githubcli-archive-keyring.gpg < "$out" > /dev/null
  $SUDO chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | $SUDO tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  $SUDO apt update
  $SUDO apt install -y gh
fi

# Install GitHub Copilot CLI (into ~/.local/bin)
if ! command -v copilot >/dev/null 2>&1; then
  command -v curl >/dev/null 2>&1 || { $SUDO apt update && $SUDO apt install -y curl; }
  export PATH="$HOME/.local/bin:$PATH"
  curl -fsSL https://gh.io/copilot-install | PREFIX="$HOME/.local" bash
fi

# Symlink dotfiles
ln -sfn "$DIR/.bashrc"    "$HOME/.bashrc"
ln -sfn "$DIR/.gitconfig" "$HOME/.gitconfig"

echo "Done. Run 'gh auth login' to authenticate, then open a new terminal."
