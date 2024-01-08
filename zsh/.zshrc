# Using pure prompt
# https://github.com/sindresorhus/pure
fpath+=($HOME/.zsh/pure)
autoload -Uz promptinit
promptinit
prompt pure
export PURE_PROMPT_VICMD_SYMBOL="_"
export PURE_PROMPT_SYMBOL="$"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export GOBIN=$GOPATH/bin

export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

export TZ="/usr/share/zoneinfo/Europe/London"

# Setting up default editor 
export EDITOR="nvim"
export GIT_EDITOR=$EDITOR

# Dracula theme for bat
export BAT_THEME="Dracula"

# Keys and things
source ~/.zshpriv

# Aliases
source ~/.zsh_aliases

# Zsh Functions and other scripts
source ~/.zsh_functions

# https://github.com/ohmyzsh/ohmyzsh/issues/3356#issuecomment-94344463
# If you get `command not found: compdef` error you need to regenerate
# completions
# source $HOME/.zsh/ohmyzsh/plugins/git/git.plugin.zsh

setopt autocd # Lazy cd

# Share history across tabs and auto save history on use
# TODO 
# I'm not sure if inc_append_history or append_history is what I want so
# will experiment more with these
# setopt inc_append_history
setopt append_history
setopt sharehistory
setopt histignorealldups # No duplicates in history

# Use vi keybindings
# TODO
# Testing out setopt vi, as far as I can tell it does bindkey -v, but also
# updates other aspects of zsh to use vi style. I should investigate this is
# more detail.
# bindkey -v
setopt vi

# Bind ctrl + r to reverse history search
bindkey "^R" history-incremental-search-backward

# TODO
# Look into all the options around globbing on the terminal
# https://zsh.sourceforge.io/Intro/intro_2.html
setopt extendedglob
setopt globdots # add hidden files to glob matches using *

# Uses menu completion.
# TODO
# More to investigate here
setopt automenu

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
export HISTSIZE=1000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zsh_history

# Enable cd'ing using vars
# TODO
# I should look more into how this works.
setopt cdablevars

# Enable fg/bg tasks
setopt monitor

# Use modern completion system
autoload -Uz compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Tab highlighting
zstyle ':completion:*' menu select

# Zplug
# https://github.com/zplug/zplug
# TODO
# Probably needs to be updated for debian
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "plugins/git",   from:oh-my-zsh
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2, as:command, use:'bin/n'

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
	printf "Install? [y/N]: "
	if read -q; then
		echo; zplug install
	fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# TODO
# Using zplug instead to manage plugins will remove after trial
# Zsh syntax highlighting should be sourced at end of file
# export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$HOME/.zsh/zsh-syntax-highlighting/highlighters
# source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Setup history search on keypresses
# https://github.com/zsh-users/zsh-history-substring-search
# source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
# TODO
# This is working a bit differently so need to see if this is nice or not
# bindkey -M vicmd "$terminfo[kcuu1]" history-substring-search-up
# bindkey -M vicmd "$terminfo[kcud1]" history-substring-search-down
# bindkey -M vicmd '^[[A' history-substring-search-up
# bindkey -M vicmd '^[[B' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# Set kitty wallpapers, should make this dynamic and random in the future
# if [[ -z "$TMUX" ]]; then
		# kitty @ set-background-image ~/Pictures/wallpapers-v3/KXYEwkl.png
# fi

source /Users/RCargill/.docker/init-zsh.sh || true # Added by Docker Desktop
