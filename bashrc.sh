#!/usr/bin/env bash
UNAMES=`uname -s 2> /dev/null`
if [ "${UNAMES}" = "Darwin" ]; then
  DOTARCH=mac
  HOMEROOT=/Users
else
  DOTARCH=linux
  HOMEROOT=/home
fi

export UNAMES DOTARCH HOMEROOT

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
PROMPT_DIRTRIM=5

unset MAILCHECK

shopt -s histappend
shopt -s checkwinsize
[ -n "$PS1" ] && {
  # Only for interactive shells, and PS1 isn't set for non-interactive ones.

  #bind "set colored-completion-prefix on"
  bind "set colored-stats on"
  bind "set menu-complete-display-prefix on"
  bind 'Tab:menu-complete'
}

# Do NOT use $HOME here - set an actual path. Reason being that this same file
# should ideally be hard linked from the repo into both the user AND the root
# directory. Thus in order for the root user to have an almost identical look
# and feel, it should source the same files. It is obvious where the root user
# is treated differently in the various prompt type bits and there is a whole
# special file for root over-rides below.
export DOTHOME="${DOTHOME:-/${HOMEROOT}/kean/.dot.dot}"
source "${DOTHOME}/common.sh"
dotps1_color="${bold_cyan_fg}"

dotps1_prompt() {
  :
}

case $TERM in
  xterm*) dotps1_tb="\[\033]0;\u@\h:\w\007\]" ;;
       *) dotps1_tb="" ;;
esac

#
# Arrange to call the function custom_prompt() each time before the prompt is to
# be displayed. bash 5.1 has a new PROMPT_COMMANDS array that could be used to
# install this handler but that is a very new version of the shell and this way
# works just as well.
#
safe_append_prompt_command() {
  local prompt_re

  if [ "${__bp_imported}" == "defined" ]; then
    # We are using bash-preexec
    if ! __check_precmd_conflict "${1}" ; then
      precmd_functions+=("${1}")
    fi
  else
    # Set OS dependent exact match regular expression
    if [[ ${OSTYPE} == darwin* ]]; then
      # macOS
      prompt_re="[[:<:]]${1}[[:>:]]"
    else
      # Linux, FreeBSD, etc.
      prompt_re="\<${1}\>"
    fi

    if [[ ${PROMPT_COMMAND} =~ ${prompt_re} ]]; then
      return
    elif [[ -z ${PROMPT_COMMAND} ]]; then
      PROMPT_COMMAND="${1}"
    else
      PROMPT_COMMAND="${1};${PROMPT_COMMAND}"
    fi
  fi
}

#
# If you want full and total control over the prompt then simply comment out
# this call and set PROMPT_COMMAND=custom_prompt. However, if you want to
# preserve other functions that may have been set, for example, by a system
# wide script in /etc/profile or some other such mechanism, then keep this
# uncommented and dont set PROMPT_COMMAND.
#
# safe_append_prompt_command custom_prompt
PROMPT_COMMAND=custom_prompt

# The next line updates PATH for the Google Cloud SDK.
if [ -f "/${HOMEROOT}/kean/.local/google-cloud-sdk/path.bash.inc" ]; then . "/${HOMEROOT}/kean/.local/google-cloud-sdk/path.bash.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "/${HOMEROOT}/kean/.local/google-cloud-sdk/completion.bash.inc" ]; then . "/${HOMEROOT}/kean/.local/google-cloud-sdk/completion.bash.inc"; fi
