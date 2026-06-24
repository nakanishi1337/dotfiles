#!/usr/bin/env bash
# macOS dotfiles setup
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Install packages
brew bundle --file="$DIR/Brewfile"

# Symlink dotfiles
ln -sfn "$DIR/.zshrc"         "$HOME/.zshrc"
ln -sfn "$DIR/.bashrc"        "$HOME/.bashrc"
ln -sfn "$DIR/.gitconfig"     "$HOME/.gitconfig"
mkdir -p "$HOME/.config/ghostty"
ln -sfn "$DIR/ghostty/config" "$HOME/.config/ghostty/config"

echo "Done. Open a new terminal."
