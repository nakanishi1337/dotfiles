# Local binaries (GitHub Copilot CLI, etc.)
export PATH="$HOME/.local/bin:$PATH"

# Prompt: 2-line style [user@host] path
PS1='\[\e[32m\][\u@\h] \[\e[34m\]\w\[\e[m\]\n\$ '

# Aliases
alias ls='ls --color=auto'
alias ll='ls -alF'

# GitHub Copilot CLI: ask from the shell, e.g. ai how do I undo a commit
ai() { copilot --silent -p "$*"; }

# History
HISTSIZE=10000
HISTCONTROL=ignoreboth
shopt -s histappend

# Share history across multiple sessions
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Enable case-insensitive completion and menu selection
bind "set completion-ignore-case on"
bind 'TAB:menu-complete'