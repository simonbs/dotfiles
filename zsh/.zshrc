# Specifies locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# .zshrc.local should specify path to ZSH, e.g.
# "export ZSH=/Users/username/.oh-my-zsh" on OS X
source ~/.zshrc.local

# Set theme
ZSH_THEME="kolo"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
source $ZSH/oh-my-zsh.sh

# /usr/local/bin takes precedence over /usr/bin
export PATH="/usr/local/bin:$PATH"

# pyenv
# https://github.com/pyenv/pyenv
if which pyenv > /dev/null; then; eval "$(pyenv init -)"; fi

# pyenv-virtualenv
# https://github.com/pyenv/pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Add RVM to PATH
export PATH="$PATH:$HOME/.rvm/bin"

# Set default editor
export EDITOR='vim'

# Aliases
source ~/.aliases 2> /dev/null

# Local aliases
if [ -f ~/.aliases.local ]; then
  source ~/.aliases.local 2> /dev/null
fi

# Completion for tmuxinator
# https://github.com/tmuxinator/tmuxinator
source ~/Developer/dotfiles/tmuxinator/tmuxinator-completion.sh

# Setup fzf
# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
if [ -f /usr/local/etc/profile.d/z.sh ]; then
  . /usr/local/etc/profile.d/z.sh
fi

# Setup nvm
export NVM_DIR="$HOME/.nvm"
# If commented, nvm should be sourced manually before used.
# Sourcing nvm on shell startup can be slow, therefore this can be commented.
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

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

# Allow tmuxinator to set window names without anyone else overriding them.
# https://github.com/tmuxinator/tmuxinator
export DISABLE_AUTO_TITLE=true

# Recommended setting for pyenv-virtualenv as prompt changing will be removed from future releases.
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Add virtual env to PS1
__pyenv_version_ps1() {
  local ret=$?;
  if [ -n "${PYENV_VIRTUAL_ENV}" ]; then
      echo -n "(${PYENV_VIRTUAL_ENV##*/}) "
  fi
  return $?
}
PS1="\$(__pyenv_version_ps1)${PS1}"

# shppa
export PATH=~/Developer/shpscripts:$PATH

