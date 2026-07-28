# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Starshipを使うため、Oh My Zshのテーマは無効化
ZSH_THEME=""

plugins=(
  git
  brew
  macos
  docker
  ssh
  starship
)

source "$ZSH/oh-my-zsh.sh"

# Load SSH keys from the Apple keychain
ssh-add --apple-load-keychain ~/.ssh/id_ed25519 2>/dev/null

# Aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias vim='nvim'

# GitHub Copilot CLI
function _copilot_ask {
  copilot --silent -p "$*"
}
alias ai='noglob _copilot_ask'

# History
setopt share_history
setopt hist_ignore_dups
setopt hist_reduce_blanks

# Autosuggestions
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highlighting should be loaded near the end
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
