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
  unzip \
  ripgrep \
  fd-find \
  fzf \
  xclip \
  bat \
  jq \
  btop

# Neovim (AstroNvim v6 requires >= 0.10; Ubuntu's apt package is often too old,
# so install the latest official release binary into ~/.local instead)
NVIM_MIN_MAJOR=0
NVIM_MIN_MINOR=10
nvim_version_ok() {
  command -v nvim >/dev/null 2>&1 || return 1
  local ver major minor
  ver="$(nvim --version | head -n1 | grep -Po '(?<=NVIM v)[0-9]+\.[0-9]+')"
  major="${ver%%.*}"
  minor="${ver##*.}"
  [ "$major" -gt "$NVIM_MIN_MAJOR" ] && return 0
  [ "$major" -eq "$NVIM_MIN_MAJOR" ] && [ "$minor" -ge "$NVIM_MIN_MINOR" ]
}
if ! nvim_version_ok; then
  mkdir -p "$HOME/.local/bin"
  curl -sLo /tmp/nvim-linux-x86_64.tar.gz \
    "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  rm -rf "$HOME/.local/nvim-linux-x86_64"
  tar -C "$HOME/.local" -xzf /tmp/nvim-linux-x86_64.tar.gz
  ln -sfn "$HOME/.local/nvim-linux-x86_64/bin/nvim" "$HOME/.local/bin/nvim"
  rm -f /tmp/nvim-linux-x86_64.tar.gz
fi

# bat installs as `batcat` on Debian/Ubuntu; symlink it to `bat`
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

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

# eza (not packaged for apt)
if ! command -v eza &> /dev/null; then
    curl -sLo eza.tar.gz "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz"
    tar xf eza.tar.gz
    sudo install eza /usr/local/bin
    rm -f eza eza.tar.gz
fi

# git-delta (not packaged for apt)
if ! command -v delta &> /dev/null; then
    DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
    curl -sLo delta.tar.gz "https://github.com/dandavison/delta/releases/latest/download/delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
    tar xf delta.tar.gz "delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu/delta"
    sudo install "delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu/delta" /usr/local/bin
    rm -rf delta.tar.gz "delta-${DELTA_VERSION}-x86_64-unknown-linux-gnu"
fi

# zoxide
if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# Nerd Font (HackGen: Hack + Japanese Gothic, with Nerd Font icons)
if [[ ! -f "$HOME/.local/share/fonts/HackGenConsoleNF-Regular.ttf" ]]; then
    mkdir -p "$HOME/.local/share/fonts"
    HACKGEN_URL=$(curl -s "https://api.github.com/repos/yuru7/HackGen/releases/latest" | grep -Po '"browser_download_url": "\K[^"]*HackGen_NF[^"]*\.zip')
    curl -sLo /tmp/HackGenNF.zip "$HACKGEN_URL"
    unzip -q -o -j /tmp/HackGenNF.zip "*.ttf" -d "$HOME/.local/share/fonts"
    rm -f /tmp/HackGenNF.zip
    fc-cache -f "$HOME/.local/share/fonts" >/dev/null 2>&1 || true
fi

# tree-sitter-cli (not packaged for apt)
if ! command -v tree-sitter &> /dev/null; then
    curl -sLo tree-sitter.gz "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz"
    gunzip -f tree-sitter.gz
    chmod +x tree-sitter
    sudo mv tree-sitter /usr/local/bin/
fi

# zellij (not packaged for apt)
if ! command -v zellij &> /dev/null; then
    curl -sLo zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"
    tar xf zellij.tar.gz zellij
    sudo install zellij /usr/local/bin
    rm -f zellij zellij.tar.gz
fi

# herdr (agent-aware terminal multiplexer)
if ! command -v herdr &> /dev/null; then
    curl -fsSL https://herdr.dev/install.sh | sh
fi

# Node.js / npm (required for claude-code and codex CLIs)
if ! command -v npm >/dev/null 2>&1; then
  $SUDO apt update && $SUDO apt install -y nodejs npm
fi

# Claude Code CLI
if ! command -v claude >/dev/null 2>&1; then
  $SUDO npm install -g @anthropic-ai/claude-code
fi

# Codex CLI
if ! command -v codex >/dev/null 2>&1; then
  $SUDO npm install -g @openai/codex
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
