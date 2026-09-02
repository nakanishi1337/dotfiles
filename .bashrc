# Local binaries (GitHub Copilot CLI, etc.)
export PATH="$HOME/.local/bin:$PATH"

# Fix stale SSH_AUTH_SOCK: when reattaching to a long-lived shell (tmux,
# reused sessions, etc.) the forwarded agent socket from a previous SSH
# connection can go away while the env var still points at it. If the
# current SSH_AUTH_SOCK isn't a live socket, fall back to the newest
# forwarded agent socket owned by us.
if [[ -n "$SSH_CONNECTION" ]] && { [[ -z "$SSH_AUTH_SOCK" ]] || ! [[ -S "$SSH_AUTH_SOCK" ]]; }; then
  fresh_sock=$(find /tmp -maxdepth 2 -type s -name 'agent.*' -uid "$(id -u)" -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -n1 | cut -d' ' -f2-)
  [[ -S "$fresh_sock" ]] && export SSH_AUTH_SOCK="$fresh_sock"
  unset fresh_sock
fi

# Prompt: Starship if available, otherwise 2-line style [user@host] path
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
else
  PS1='\[\e[32m\][\u@\h] \[\e[34m\]\w\[\e[m\]\n\$ '
fi

# Aliases
alias ls='eza'
alias vim='nvim'
alias cat='bat'

# fzf key bindings and fuzzy completion (Ctrl+R, Ctrl+T, Alt+C)
eval "$(fzf --bash)"

# zoxide: smarter cd (adds `z` command)
eval "$(zoxide init bash)"

# yazi: cd to the last visited directory on exit
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

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