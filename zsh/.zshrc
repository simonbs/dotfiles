# .zshrc.local should specify path to ZSH, e.g.
# "export ZSH=/Users/username/.oh-my-zsh" on OS X
source ~/.zshrc.local

# Set theme
# https://github.com/bhilburn/powerlevel9k
ZSH_THEME="powerlevel9k/powerlevel9k"

# Theme configuration
# https://github.com/bhilburn/powerlevel9k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir virtualenv nodeenv rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)

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
# https://github.com/yyuu/pyenv#homebrew-on-mac-os-x
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# Add RVM to PATH
export PATH="$PATH:$HOME/.rvm/bin"

# Set default editor
export EDITOR='vim'

# Aliaes
source ~/.aliases 2> /dev/null

# Setup fzf
# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
