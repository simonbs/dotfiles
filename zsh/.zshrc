# Specifies locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# .zshrc.local should specify path to ZSH, e.g.
# "export ZSH=/Users/username/.oh-my-zsh" on OS X
if [[ -f "~/.zshrc.local" ]]; then
  source ~/.zshrc.local
fi

# Set powerlevel10k theme.
# https://github.com/romkatv/powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
source ~/.oh-my-zsh/oh-my-zsh.sh

# /usr/local/bin takes precedence over /usr/bin
export PATH="/usr/local/bin:$PATH"

# Add psql
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# Set default editor
export EDITOR="nova"

# Aliases
source ~/.aliases 2> /dev/null

# Local aliases
if [ -f ~/.aliases.local ]; then
  source ~/.aliases.local 2> /dev/null
fi

# Setup fzf
# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set theme of fzf
# https://github.com/dracula/fzf
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# cd to selected directory with fzf
# https://github.com/junegunn/fzf/wiki/examples
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# Open selected file with fzf
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
# https://github.com/junegunn/fzf/wiki/examples
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# Checkout git branch with fzf
# https://github.com/junegunn/fzf/wiki/examples
fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
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

# Setup z
# https://github.com/rupa/z
if [ -f ~/z/z.sh ]; then
  . ~/z/z.sh
fi

# Setup asdf
# https://asdf-vm.com
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# z with fzf
# Like normal z when used with arguments but displays an fzf prompt when used without
# https://github.com/junegunn/fzf/wiki/examples
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --reverse --inline-info +s --tac --query "$*" | sed 's/^[0-9,.]* *//')"
}

# Configures GPG tty
# https://www.gnupg.org/documentation/manuals/gnupg/Common-Problems.html
export GPG_TTY=$(tty)

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Use bat as pager and cat replacement
# https://github.com/sharkdp/bat
if command -v bat >/dev/null 2>&1; then
  export PAGER="bat"
  export BAT_THEME="Dracula"
  alias cat="bat"
fi

# fzf with bat preview
if command -v fzf >/dev/null 2>&1 && command -v bat >/dev/null 2>&1; then
  alias fp="fzf --preview 'bat --style=numbers --color=always {}'"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Configures LM Studio
# https://lmstudio.ai
export PATH="$PATH:/Users/simonbs/.lmstudio/bin"
export HOMEBREW_NO_ENV_HINTS=1
