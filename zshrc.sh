#!/usr/bin/env zsh
UNAMES=`uname -s 2> /dev/null`
if [ "${UNAMES}" = "Darwin" ]; then
  DOTARCH=mac
  HOMEROOT=/Users
else
  DOTARCH=linux
  HOMEROOT=/home
fi

export UNAMES DOTARCH HOMEROOT

export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export HISTFILESIZE=10000
export SAVEHIST=10000

set -o appendhistory
set -o noincappendhistory
set -o histexpiredupsfirst
set -o histfindnodups
set -o histignoredups
set -o histreduceblanks
set -o histnostore
set -o histnofunctions
set -o nohistbeep
set -o rmstarsilent
set -o pushdsilent
set -o sharehistory

bindkey -e

autoload -Uz compinit && compinit

# Do not use $HOME here. Change to your personal homedir.
export DOTHOME="${DOTHOME:-/${HOMEROOT}/kean/.dot.dot}"
source "${DOTHOME}/common.sh"
dotps1_color="${bold_cyan_fg}"

dotps1_prompt() {
  :
}

case $TERM in
  xterm*) dotps1_tb="%{]0;%n@%m:%5~%}" ;;
       *) dotps1_tb="" ;;
esac

# For total control over the prompt, comment out the auto-load and the call
# to add-zsh-hook, and rather use the precmd function.
# autoload -Uz add-zsh-hook
# add-zsh-hook precmd custom_prompt
precmd() { custom_prompt }

# The next line updates PATH for the Google Cloud SDK.
if [ -f "/${HOMEROOT}/kean/.local/google-cloud-sdk/path.zsh.inc" ]; then . "/${HOMEROOT}/kean/.local/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "/${HOMEROOT}/kean/.local/google-cloud-sdk/completion.zsh.inc" ]; then . "/${HOMEROOT}/kean/.local/google-cloud-sdk/completion.zsh.inc"; fi
