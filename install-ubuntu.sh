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

# Install tmux
$SUDO apt update
$SUDO apt install -y \
  tmux \
  neovim \
  unzip \
  ripgrep \
  fd-find \
  fzf

# lazygit
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm -f lazygit lazygit.tar.gz
fi

# yazi
if ! command -v yazi &> /dev/null; then
    sudo apt update && sudo apt install -y unzip && \
    YAZI_VERSION=$(curl -s "https://api.github.com/repos/sxyazi/yazi/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -sLo yazi.zip "https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip" && \
    unzip -q yazi.zip && \
    sudo mv yazi-x86_64-unknown-linux-gnu/yazi yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/ && \
    rm -rf yazi.zip yazi-x86_64-unknown-linux-gnu
fi

# fd-find installs as `fdfind` on Debian/Ubuntu; symlink it to `fd`
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

# tree-sitter-cli (not packaged for apt)
if ! command -v tree-sitter &> /dev/null; then
    curl -sLo tree-sitter.gz "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz"
    gunzip -f tree-sitter.gz
    chmod +x tree-sitter
    sudo mv tree-sitter /usr/local/bin/
fi

# Starship prompt
if ! command -v starship >/dev/null 2>&1; then
  curl -fsSL https://starship.rs/install.sh | $SUDO sh -s -- --yes
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
ln -sfn "$DIR/.tmux.conf" "$HOME/.tmux.conf"
mkdir -p "$HOME/.config"
ln -sfn "$DIR/nvim" "$HOME/.config/nvim"

echo "Done. Run 'gh auth login' to authenticate, then open a new terminal."
