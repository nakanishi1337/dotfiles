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

# Install GitHub Copilot CLI (into ~/.local/bin)
if ! command -v copilot >/dev/null 2>&1; then
  export PATH="$HOME/.local/bin:$PATH"
  curl -fsSL https://gh.io/copilot-install | PREFIX="$HOME/.local" bash
fi

# Symlink dotfiles
ln -sfn "$DIR/.zshrc"         "$HOME/.zshrc"
ln -sfn "$DIR/.bashrc"        "$HOME/.bashrc"
ln -sfn "$DIR/.gitconfig"     "$HOME/.gitconfig"
mkdir -p "$HOME/.config/ghostty"
ln -sfn "$DIR/ghostty/config" "$HOME/.config/ghostty/config"

# macOS system preferences
# Don't write .DS_Store
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Show all file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder

echo "Done. Open a new terminal."
