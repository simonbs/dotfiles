# Specifies locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Machine-specific environment and PATH settings
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

# Keep PATH and completion directories unique, including when re-sourcing.
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
typeset -U path fpath
path=(
  "$HOME/go/bin"
  "$BUN_INSTALL/bin"
  /opt/homebrew/opt/rustup/bin
  "$HOME/.cargo/bin"
  /opt/homebrew/opt/postgresql@16/bin
  "$HOME/.local/bin"
  /opt/homebrew/bin /opt/homebrew/sbin
  /usr/local/bin
  "${path[@]}"
  /usr/bin /bin /usr/sbin /sbin
)
export PATH

# Set default editor
export EDITOR="nova"

# History shared between interactive shells
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt extended_history share_history hist_ignore_dups hist_ignore_space
setopt hist_reduce_blanks hist_save_no_dups hist_verify

# Directory navigation and shell behavior previously supplied by Oh My Zsh
setopt auto_cd auto_pushd pushd_ignore_dups pushd_minus interactive_comments
unsetopt flow_control

# Initialize completion before tools register their own completions
[[ ! -d /opt/homebrew/share/zsh/site-functions ]] || fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
[[ ! -d /usr/local/share/zsh/site-functions ]] || fpath=(/usr/local/share/zsh/site-functions $fpath)
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true

# Emacs editing with history search using the text already entered
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^R' history-incremental-search-backward

# Common Git shortcuts, without a plugin framework
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gcam='git commit --all --message'
alias gcmsg='git commit --message'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gl='git pull'
alias glog='git log --oneline --decorate --graph'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias grb='git rebase'
alias grbi='git rebase --interactive'
alias grs='git restore'
alias grss='git restore --staged'
alias gst='git status'
alias gss='git status --short'
alias gsta='git stash push'
alias gstp='git stash pop'
alias gsw='git switch'
alias gswc='git switch --create'

# Set theme of fzf
# https://github.com/dracula/fzf
export FZF_DEFAULT_OPTS='--height=60% --layout=reverse --border=rounded --walker-skip=.git,node_modules,.build,target --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# Use fzf's built-in file walker; no ag, fd, or generated ~/.fzf.zsh needed.
# Discard the old dotfiles defaults if inherited when restarting an existing shell.
[[ ${FZF_DEFAULT_COMMAND-} != 'ag --hidden --ignore .git -g ""' ]] || unset FZF_DEFAULT_COMMAND
[[ ${FZF_CTRL_T_COMMAND-} != 'ag --hidden --ignore .git -g ""' ]] || unset FZF_CTRL_T_COMMAND
export FZF_CTRL_T_OPTS='--walker=file,hidden'
export FZF_ALT_C_OPTS='--walker=dir,hidden'
if command -v bat >/dev/null 2>&1; then
  export FZF_CTRL_T_OPTS="$FZF_CTRL_T_OPTS --preview 'bat --style=numbers --color=always -- {}' --preview-window=right:50%:hidden --bind 'ctrl-/:toggle-preview'"
fi

# Ctrl-R: history, Ctrl-T: files, Alt-C: directories, **<Tab>: completion.
# Initialize after compinit and the default key bindings above.
# https://github.com/junegunn/fzf#setting-up-shell-integration
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# cd to selected directory with fzf
# https://github.com/junegunn/fzf/wiki/examples
fd() {
  local dir
  dir=$(find "${1:-.}" -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# Open selected file with fzf
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
# https://github.com/junegunn/fzf/wiki/examples
fo() {
  local out file key
  out=$(fzf --query="$1" --exit-0 --expect=ctrl-o,ctrl-e) || return
  key=${out%%$'\n'*}
  file=${out#*$'\n'}
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# Checkout git branch with fzf
# https://github.com/junegunn/fzf/wiki/examples
fbr() {
  local branch
  branch=$(git for-each-ref --format='%(refname:short)' refs/heads | fzf +m) || return
  [[ -n "$branch" ]] && git switch -- "$branch"
}

# Show git commits with fzf
# https://github.com/junegunn/fzf/wiki/examples
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# Smarter directory navigation: z <query>, zi for an fzf picker
# https://github.com/ajeetdsouza/zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Configures GPG tty
export GPG_TTY=$TTY

# Use bat for file viewing and less as the general-purpose pager
# https://github.com/sharkdp/bat
if command -v bat >/dev/null 2>&1; then
  export PAGER="less"
  export BAT_THEME="Dracula"
  alias cat="bat"
fi

# fzf with bat preview
if command -v fzf >/dev/null 2>&1 && command -v bat >/dev/null 2>&1; then
  alias fp="fzf --preview 'bat --style=numbers --color=always {}'"
fi

# Disable Homebrew hints
export HOMEBREW_NO_ENV_HINTS=1

# Setup ngrok
# https://ngrok.com
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

# Setup wut
# https://github.com/simonbs/wut
if command -v wut &>/dev/null; then
  # wut registers Bash-style completions before enabling Zsh compatibility.
  autoload -Uz bashcompinit
  bashcompinit
  eval "$(wut init)"
  # Select worktree paths directly, preserving spaces and cancellation.
  wt() {
    local dir
    dir=$(git worktree list --porcelain |
      awk '/^worktree / { sub(/^worktree /, ""); print }' |
      fzf --height=~20) || return
    [[ -n "$dir" ]] && cd -- "$dir"
  }
fi

# Enhanced listing via eza
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons'
  alias ll='eza -lh --icons'
  alias la='eza -lha --icons'
  alias l='eza -l --icons'
  alias lsd='eza -lha --no-permissions --no-user --time-style=relative --icons'
  alias lt='eza --tree --icons'
  alias lt1='lt --level=1'
  alias lt2='lt --level=2'
  alias lt3='lt --level=3'
  alias lt4='lt --level=4'
  alias lt5='lt --level=5'
fi

# Override POSTGRES_DATA_DIR in ~/.zshrc.local for a different cluster.
startpostgresql() {
  local data_dir="${POSTGRES_DATA_DIR:-${PGDATA:-/opt/homebrew/var/postgresql@16}}"
  pg_ctl -D "$data_dir" -l "$data_dir/server.log" start
}
stoppostgresql() {
  local data_dir="${POSTGRES_DATA_DIR:-${PGDATA:-/opt/homebrew/var/postgresql@16}}"
  pg_ctl -D "$data_dir" stop -s -m fast
}

# Stop listeners on an exact TCP port.
killport() {
  if [[ $# != 1 || "$1" != <-> ]] || (( 10#$1 < 1 || 10#$1 > 65535 )); then
    print -u2 'Usage: killport <port 1-65535>'
    return 1
  fi
  local -aU pids
  pids=("${(@f)$(lsof -tiTCP:"$1" -sTCP:LISTEN -n -P)}")
  (( ${#pids} )) || return 0
  kill -- "${pids[@]}"
}

# Media ripper helpers
alias rip='"$HOME/Developer/dotfiles/scripts/rip-with-ffmpeg.sh"'
alias rip-yt='"$HOME/Developer/dotfiles/scripts/rip-yt.sh"'
alias tmp-codex='"$HOME/Developer/dotfiles/scripts/tmp-codex"'

# Bun completions
[[ ! -s "$BUN_INSTALL/_bun" ]] || source "$BUN_INSTALL/_bun"

# Scaleway CLI autocomplete initialization.
if command -v scw >/dev/null 2>&1; then
  eval "$(scw autocomplete script shell=zsh)"
fi

# Attach to agents tmux session
alias agents-tmux="tmux new-session -A -s agents"

# Unity CLI
[[ ! -f "$HOME/.unity/env" ]] || source "$HOME/.unity/env"

# Switching Codex accounts
unalias codex codexb codexp codexfb codexfp 2>/dev/null
codex-with-args() {
  local shared_dir="$HOME/.codex"
  local shadow_dir="$1"
  local entry name backup_dir
  shift

  if [[ "${shadow_dir:A}" == "${shared_dir:A}" ]]; then
    print -u2 "Codex account directory must differ from $shared_dir"
    return 1
  fi

  mkdir -p "$shadow_dir" || return
  chmod 700 "$shadow_dir" || return

  # Share entries except account-specific credentials and daemon runtime files.
  for entry in "$shared_dir"/*(DN); do
    name="${entry:t}"
    # Credentials and daemon sockets/locks belong to each account.
    [[ "$name" == "auth.json" || "$name" == "app-server-control" || "$name" == "app-server-daemon" ]] && continue

    # Keep ~/.codex authoritative, preserving separate copies before linking.
    if [[ -L "$shadow_dir/$name" && "$(readlink "$shadow_dir/$name")" == "$entry" ]]; then
      continue
    fi
    if [[ -e "$shadow_dir/$name" || -L "$shadow_dir/$name" ]]; then
      if [[ -z "$backup_dir" ]]; then
        backup_dir="$(mktemp -d "$shadow_dir/shared-backup.XXXXXXXX")" || return
      fi
      mv "$shadow_dir/$name" "$backup_dir/$name" || return
    fi
    ln -s "$entry" "$shadow_dir/$name" || return
  done

  CODEX_HOME="$shadow_dir" command codex -c 'cli_auth_credentials_store="file"' "$@"
}
alias codexfb='codex-with-args "$HOME/.codex-framna-business"'
alias codexfp='codex-with-args "$HOME/.codex-framna-personal"'
alias codex='codexfb'

# Local overrides take precedence over the defaults above.
if [[ -f ~/.aliases.local ]]; then
  source ~/.aliases.local
fi

# Initialize the prompt last, after shell integrations and local overrides
# https://starship.rs
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  # Keep a usable prompt until Starship is installed
  PROMPT='%F{cyan}%~%f %# '
fi

# bun completions
[ -s "/Users/simonbs/.bun/_bun" ] && source "/Users/simonbs/.bun/_bun"
