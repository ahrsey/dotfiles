# Using pure prompt
# https://github.com/sindresorhus/pure
fpath+=($HOME/.zsh/pure)
autoload -Uz promptinit
promptinit
prompt pure
export PURE_PROMPT_VICMD_SYMBOL="_"
export PURE_PROMPT_SYMBOL="$"

export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export GOBIN=$GOPATH/bin
export PNPM_HOME="$HOME/Library/pnpm"

# Zsh docs
# https://zsh.sourceforge.io/Intro/intro_toc.html
#
# Paths
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="$PNPM_HOME:$PATH"
export PATH="/Users/RCargill/.docker/bin:$PATH"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

export TZ="/usr/share/zoneinfo/Europe/London"
export EDITOR="NVIM_APPNAME=nvim-new nvim"
# export EDITOR="nvim"
export GIT_EDITOR=$EDITOR
export BAT_THEME="Dracula"

source ~/.zshpriv

# History
export SAVEHIST=10000000
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
export HISTFILE="$HOME/.zsh_infinite_history"
setopt inc_append_history share_history
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

# Bind ctrl + r to reverse history search
# Bind up and down to reverse history search
bindkey "^R" history-incremental-search-backward
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

setopt extendedglob
setopt globdots # add hidden files to glob matches using *
setopt automenu # Menu completion.
setopt cdablevars # Enable cd'ing using vars
setopt monitor # Enable fg/bg tasks
setopt vi # Vi mode
setopt AUTO_CD # Lazy cd

# Aliases
alias 'ps?'='ps ax | rg '
alias c=clear
alias cat=bat
alias cp='cp -i'
alias docker="podman"
# alias f="find . -type f -not -path '*.git*' -not -path '*node_modules*' | rg "
alias f="rg --files | rg"
alias grep="grep --color=auto"
alias ls="ls -alGh"
alias mkdir='mkdir -p'
alias mv='mv -i'
alias ping='ping -c 10'
alias python="python3"
alias rebootforce='sudo shutdown -r -n now'
alias rebootsafe='sudo shutdown -r now'
alias rg="rg --hidden -g '!.git' -g '!yarn.lock'"
alias rm='rm -iv'
alias sed="gsed"
alias serve="python3 -m http.server"
alias so="source"
alias t="find . -not -path '*node_modules*' -not -path '*git*'"
alias tf="terraform"
alias tmux="tmux -2"
alias vi="NVIM_APPNAME=nvim-new nvim"
# alias vi="nvim"
alias vim="NVIM_APPNAME=nvim-new nvim"
# alias vim="nvim"
alias x="exit"

alias se="$HOME/Repos/scripts/fuzzy_search_projects.sh"
alias update="$HOME/Repos/installation/update.sh"
alias op="$HOME/Repos/scripts/open_gitlab_latest_pipeline.sh"
alias ops="$HOME/Repos/scripts/open_pipelines.sh"
alias ot="$HOME/Repos/scripts/open_jira_ticket.sh"
alias omru="$HOME/Repos/scripts/open_mr_by_user.sh"
alias ocf="$HOME/Repos/scripts/open_cloudformation.sh"

# Connect to my headphones and turn off bluetooth
alias bt="blueutil -p TOGGLE"
alias bc="blueutil -p 1 && blueutil --connect cc-98-8b-b8-22-60"

# Easy config aliases and dotfiles
# TODO Rethink this
alias zshalias="$EDITOR ~/.zshrc +66"
alias zshfunctions="$EDITOR ~/.zshrc +123"
alias zshrc="$EDITOR ~/.zshrc"
alias sozsh="source ~/.zshrc"
alias tmuxrc="$EDITOR ~/.tmux.conf"
alias vimrc="$EDITOR ~/.config/nvim-new/init.lua"
# alias vimrc="$EDITOR ~/.config/nvim/init.lua"
alias DOTFILES_DIR="$HOME/dotfiles"
alias SCRIPTS_DIR="$HOME/Repos/scripts"
alias WORK="$HOME/Work"
alias REPOS="$HOME/Repos"

alias gssf="git status -s | awk '{print \$2}'"
alias gssfz="git status -s | awk '{print \$2}' | fzf"
alias gsf="git show --name-only --pretty=format:''"

# Functions
alias gsbf=git_show_branch_files
function git_show_branch_files() {
  local main_branch=$(git_latest_main_branch)
  git log --pretty=format:'%h' "${main_branch}.." | while read commit_hash; do git show --name-only --pretty=format: $commit_hash; done | sort -u
}

function git_latest_main_branch() {
  main_updated=$(git for-each-ref --sort=-committerdate refs/heads/main --format='%(committerdate:short)' | head -n 1)
  master_updated=$(git for-each-ref --sort=-committerdate refs/heads/master --format='%(committerdate:short)' | head -n 1)

  if [[ "$main_updated" > "$master_updated" ]]; then
    echo "main"
  elif [[ "$main_updated" < "$master_updated" ]]; then
    echo "master"
  fi
}

alias omr="open_mr"
function open_mr {
  local remoteUrl=$(git config --get remote.origin.url)
  local repoPath=${${remoteUrl/git@gitlab.com:/""}/.git/""}
  local gitlabUser=$(curl "https://gitlab.com/api/v4/user?private_token=${GITLAB_READ_TOKEN}" | jq ".username" | tr -d '"')

  # echo $gitlabUser

  # local pipelineUrl="https://gitlab.com/${repoPath}/-/merge_requests?scope=all&state=opened&author_username=${gitlabUser}"
  local pipelineUrl="https://gitlab.com/${repoPath}/-/merge_requests?scope=all&state=opened&author_username=RCargill"

  echo $pipelineUrl
  open $pipelineUrl
}

alias oc="open_compare"
function open_compare {
  local remoteUrl=$(git config --get remote.origin.url)
  local repoPath=${${remoteUrl/git@gitlab.com:/""}/.git/""}
  local mainBranch=$(git_main_branch)
  local currentBranch=$(git rev-parse --abbrev-ref HEAD)

  local pipelineUrl="https://gitlab.com/${repoPath}/-/compare/${mainBranch}...${currentBranch}"

  echo $pipelineUrl
  open $pipelineUrl
}

# TODO
# Look into some watch functionality for when it sees one of these files.
# https://github.com/nvm-sh/nvm#zsh
# Look into updating this to not use anything older than node 16
# Maybe using precmd
function set_node_version {
  if [ -e .nvmrc ]; then
    local nvmVersion=$(cat .nvmrc)
    echo "Found .nvmrc - using ${nvmVersion}"
    pnpm env use --global ${nvmVersion}

  elif [ -e .node-version ]; then
    local nodeVersion=$(cat .node-version)
    echo "Found .node-version - using ${nodeVersion}"
    pnpm env use --global ${nodeVersion}

  elif [ -e package.json ]; then
    local pkgVersion=$(cat package.json | jq '.engines.node')
    if [ $pkgVersion != 'null' ]; then
      echo "Found node engine in package.json - using ${pkgVersion}"
      pnpm env use --global ${pkgVersion}
    else
      echo "No node engine specified in package.json"
    fi
  else
    echo "I can't find a node version to set."
  fi 
}

alias bk=bk
function bk() {
  local bn=$(basename $1)
  if [[ "$1" == "$bn" ]]; then
    cp $1 "$bn.bak"
  else
    cp $1 "$($bn | sed 's/\..*$//').bak"
  fi
}

# Copy and go to the directory
function cpg ()
{
	if [ -d "$2" ];then
		cp "$1" "$2" && cd "$2" || return
	else
		cp "$1" "$2"
	fi
}

# Move and go to the directory
function mvg ()
{
	if [ -d "$2" ];then
		mv "$1" "$2" && cd "$2" || return
	else
		mv "$1" "$2"
	fi
}

# Goes up a specified number of directories  (i.e. up 4)
function up ()
{
	local d=""
	limit=$1
	for ((i=1 ; i <= limit ; i++))
		do
			d=$d/..
		done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd "$d" || return
}

# Find and replace in vim
# TODO
# I'd like to pipe the errors of this to /dev/null to silence them, but had some issues
# https://askubuntu.com/questions/589647/search-and-replace-from-terminal-but-with-confirmation 
function find_replace() {
  local find=$1
  local replace=$2

  $EDITOR "+bufdo %s/${find}/${replace}/gc | up" '+q' -- $(\rg $find -il)
}

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # Case insensitive completion
zstyle ':completion:*' menu select # Tab highlighting

# Zplug
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "plugins/git",   from:oh-my-zsh
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2, as:command, use:'bin/n'

if ! zplug check --verbose; then
	printf "Install? [y/N]: "
	if read -q; then
		echo; zplug install
	fi
fi

zplug load

alias gcm='git checkout $(git_latest_main_branch)'
alias grbm='git rebase $(git_latest_main_branch)'
