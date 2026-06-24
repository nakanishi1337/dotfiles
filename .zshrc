# Local binaries (GitHub Copilot CLI, etc.)
export PATH="$HOME/.local/bin:$PATH"

# Load SSH keys from the Apple keychain
ssh-add --apple-load-keychain ~/.ssh/id_ed25519 2>/dev/null

# Aliases
alias ls='ls --color=auto'
alias ll='ls -alF'

# GitHub Copilot CLI: ask from the shell, e.g. `ai how do I undo a commit`
function _copilot_ask { copilot --silent -p "$*" }
alias ai='noglob _copilot_ask'

# highlight
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z1-2A-Z1-2}={A-Z1-2a-z1-2}'
autoload -Uz compinit && compinit

# pure
autoload -U promptinit; promptinit; prompt pure

# history
setopt share_history
setopt hist_ignore_dups
setopt hist_reduce_blanks