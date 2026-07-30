# Local binaries (GitHub Copilot CLI, etc.)
export PATH="$HOME/.local/bin:$PATH"

# Prompt: Starship if available, otherwise 2-line style [user@host] path
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
else
  PS1='\[\e[32m\][\u@\h] \[\e[34m\]\w\[\e[m\]\n\$ '
fi

# Aliases
alias ls='ls --color=auto'
alias vim='nvim'

# ll: long listing but truncate owner/group names to 5 chars for readability
ll() {
  ls -alF --color=always "$@" | awk '
    $1 == "total" { print; next }
    NF >= 9 {
      owner = substr($3, 1, 5)
      group = substr($4, 1, 5)
      name = $9
      for (i = 10; i <= NF; i++) name = name " " $i
      printf "%s %2s %-5s %-5s %8s %3s %2s %5s %s\n", \
             $1, $2, owner, group, $5, $6, $7, $8, name
      next
    }
    { print }
  '
}

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