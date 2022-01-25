# Common (mostly) to all Bourne-compatible shells.
# Sets all common aliases, loads the color variables, and provides several of
# the functions used for portions of the prompts. These are common to all
# Bourne-shell compatible shells (ksh, zsk, bash, maybe others). Shells with
# extra features will no doubt set other prompt things in their specific
# dotrc file.
[ -n "${BASH_VERSION}" ] && {
  dotps1_user='\u'
  dotps1_host='\h'
  dotps1_pwd='\w'
  dotps1_beg='\['
  dotps1_end='\]'
  dotshrc="bashrc"
}

[ -n "${ZSH_VERSION}" ] && {
  dotps1_user='%n'
  dotps1_host='%m'
  dotps1_pwd='%5~'
  dotps1_beg='%{'
  dotps1_end='%}'
  dotshrc="zshrc"
}

source "${DOTHOME}/colors.sh"
set -o ignoreeof
[ -f "${DOTHOME}/${USER}.sh" ] && source "${DOTHOME}/${USER}.sh"

#
# I really hate the collation sequence used for UTF-8 for file listings. Nearly
# 45 years of seeing files displayed in a certain order has made me appreciate
# the "C" locale, or, the default one. So this function unsets LANG and LC_ALL
# but just for the ls command. We use aliases to get to this.
#
__ls() {
  LANG="" LC_ALL="" /usr/bin/ls --color=auto "$@"
}

# enable color support of ls and also add handy aliases
test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
alias ls='__ls'
alias l='__ls -l'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias more=less
alias vi=/usr/bin/vim
alias kx=kubectx
alias kc=kubectl
alias reload="source ${HOME}/.${dotshrc}"

export LESS=-Mier
export PAGER=less
export EDITOR=/usr/bin/vim
export MYSQL_PS1="(\u@\h) [\d]> "
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
export AWS_PROFILE="${AWS_PROFILE:-development}"

# PS2="└─▪ "
PS2="${blcorner}${horiz}${square} "

# PS3="──➤ "
PS3="${horiz}${horiz}${arrowhead} "

#
# This implements the mind-shatteringly useful ksh-ism of allowing the cd
# command to take two arguments. When used with just one argument it behaves
# exactly as you expect - it changes to that directory. However, if used with
# two arguments it substitutes all occurences of $1 with $2. So for example
# if your PWD was currently /path/to/some/dir/somewhere and you typed:
#    cd some any
# it would change to /path/to/any/dir/anywhere
#
cd() {
  if [ $# -eq 2 ]; then builtin cd "${PWD//$1/$2}"; else builtin cd $1; fi
}

#
# I have lost count of the number of times in a day where I need to do a
# "grep all files in and below the current directory for a given string".
# Enter afg() - all files grep. Usage is whatever you would give as normal
# arguments to grep.
#
afg() {
  local nma nmf nmn

  [ "$1" = "-name" ] && {
    nma='-a'
    nmn=$1
    nmf=$2
    shift 2
  }

  find . -name '.git' -prune -o -type f $nma $nmn $nmf -a -print0 | xargs -0 grep "$@"
}

# Find all files in or below the current directory that match the give name.
ff() {
  find . -name '.git' -prune -o -iname "$@" -print
}

# AWS and k8s stuff. Usage: awsdev [commands.....] or awsprod [commands....]
# If no commands are given, set the default to that environment. For example
# awsdev would set the development profile or awsprod would set the production
# profile.
aws_common() {
  local which="$1"
  shift

  [ -z "$1" ] && {
    export AWS_PROFILE="${which}"
    return
  }

  aws --profile $which "$@"
}
alias awsprod='aws_common production'
alias awsdev='aws_common development'

awsnone() {
  unset AWS_PROFILE
  unset AWS_DEFAULT_REGION
}

# Version control (VC) theme options. The sky's the limit. See the functions
# below for all the places these get used to get an idea of how you can mess
# with the prompt appearance.
vc_prompt_prefix=''
vc_prompt_suffix=''
vc_prompt_dirty=" ${bold_red_fg}${bold}${ballotcross}${no_bold}${dotps1_color}"
vc_prompt_clean=" ${bold_green_fg}${heavycheck}${dotps1_color}"
vc_branch_prefix=''
vc_branch_suffix=''
vc_tag_prefix="${heart}:"
vc_tag_suffix=''
vc_detached_prefix=''
vc_detached_suffix=''
vc_branch_track_prefix=" ${arrow} "
vc_branch_track_suffix=''
vc_branch_gone_prefix=" ${brokenarrow} "
vc_branch_gone_suffix=''
vc_char_prefix=''
vc_char_suffix=''
vc_git_char="${bold_green_fg}${bold}${dotps1_beg}${plusminus}${dotps1_end}${no_bold}${dotps1_color}"
vc_svn_char="${bold_cyan_fg}${bold}${dotps1_beg}⑆${dotps1_end}${no_bold}${dotps1_color}"
vc_none_char="${circle}"
vc_scm_git='git'
vc_scm_svn='svn'
vc_scm_none='NONE'

# Git specific options.
vc_git_show_details=${vc_git_show_details:=true}
vc_git_show_remote_info=${vc_git_show_remote_info:=auto}
vc_git_ignore_untracked=${vc_git_ignore_untracked:=false}
vc_git_show_minimal_info=${vc_git_show_minimal_info:=false}

# Git specific themes.
vc_git_detached_char="${detached}:"
vc_git_ahead_char="${uparrow}"
vc_git_behind_char="${downarrow}"
vc_git_untracked_char='?:'
vc_git_unstaged_char='U:'
vc_git_staged_char='S:'
vc_git_stash_char_prefix='{'
vc_git_stash_char_suffix='}'

#
# I know zsh supports RPS1 but it has issues. For example on a multi-line prompt like this it puts
# the RPS1 text on the second line which isn't useful. We want to put some stuff on the right hand
# side because - well - reasons :) It's pretty easy to do. All we need to do is keep track of the
# number of printable characters we will need (i.e not counting the escape sequences) and then we
# can simply position the cursor at the right position with HPA and display the string with all of
# the colorising escape sequences. This function does just that.
#
right_prompt() {
  local tlen=0
  local awsbeg=''
  local awsend=''
  local awsprof=''
  local awsreg=''
  local ts
  local rs=''
  local cc=0

  [ -n "${AWS_PROFILE}" ] && {
    awsbeg='[AWS'
    awsprof=":${AWS_PROFILE}"
    awsend=']'
  }

  [ -n "${AWS_DEFAULT_REGION}" ] && {
    awsbeg='[AWS'
    awsreg=":${AWS_DEFAULT_REGION}"
    awsend=']'
  }

  ts="${awsbeg}${awsprof}${awsreg}${awsend}"
  tlen=${#ts}
  [ -n "${ts}" ] && {
    rs=" ${dotps1_color}[${bold_magenta_fg}${bold}${awsbeg#\[}${awsprof}${awsreg}${no_bold}${dotps1_color}]"
    cc=1
  }

  local kxc=$(kubectx -c 2> /dev/null)
  [ -n "${kxc}" ] && {
    local prod="${bold_magenta_fg}"
    [ -n "${DOTDOT_AWS_PROD_ID}" ] && {
      case "${kxc}" in
        *:${DOTDOT_AWS_PROD_ID}:*) prod="${bold_yellow_fg}${bold_black_bg}" ;;
      esac
    }
    local rks="${kxc##*/}"
    cc=$(( $cc + 1 ))
    tlen=$(( ${tlen} + ${#rks} + $cc ))
    rs="${prod}${bold}${leftchev}${rks}${rightchev}${no_bold}${normal_bg}${rs}"
  }

  [ ${tlen} -ne 0 ] && {
    local hpa=$(( ${COLUMNS} - ${tlen} - 1 ))
    echo "${csi}${hpa}G${rs}"
  }
}

vc_prompt() {
  local chr=$(vc_scm_char)
  [ "$chr" = "$vc_none_char" ] || echo " [${chr} ${bold_yellow_fg}${bold}$(vc_scm_prompt_info)${no_bold}${dotps1_color}]"
}

#
# The various top level scripts (.bashrc, .zshrc, .kshrc etc) all arrange for
# this function to be called prior to needing to display PS1. The exact method
# varies from shell to shell which is why it isn't in this common code, but
# the stuff to actually set PS1 should be common. If for whatever reason the
# specific shell needs to over-ride this it can do so by redefining the function
# in the rcfile.
#
custom_prompt() {
  local psc="${bold_green_fg}"
  local pec="\$"
  local shlv=''

  [ "$UID" = '0' ] && {
    psc="${bold_red_fg}"
    pec='#'
  }

  [ $SHLVL -gt 1 ] && {
    shlv="${bold_black_bg}${bold}${leftchev}${SHLVL}${rightchev}${no_bold}${normal_bg}${dotps1_color} "
  }

    PS1="${dotps1_tb}${dotps1_color}${tlcorner}${horiz}[${psc}${bold}${dotps1_user}@${dotps1_host}${dotps1_color}:${cyan_fg}${dotps1_pwd}${no_bold}${dotps1_color}]$(vc_prompt)$(dotps1_prompt)$(right_prompt)
${dotps1_color}${blcorner}${horiz}${shlv}${pec}${normal_fg} "
}

#
# Utility function to check to see if a file or directory of the given name
# exists anywhere in the path leading up to the PWD. For example, see if
# the .git directory exists leading up to $PWD. If you really want to over-
# think things and ensure that no symbolic links are followed, change the
# first line to: local current="/$(builtin pwd -P)"
#
# Usage: is_in_parent [ -d | -f | -e ] thing [-p]
#
# Intentionally does not check for the file/dir in the root directory.
# Use -p to print the actual thing found, if it was.
#
is_in_parent() {
  local current="/${PWD}"
  local how=$1
  local what=$2

  while [ "${current}" != "/" ]; do
    if [ ${how} "${current#/}/${what}" ]; then
      [ "$3" = "-p" ] && echo "${current#/}/${what}"
      return 0
    fi
    current="${current%/*}"
  done
  return 1
}

vc_scm() {
  if is_in_parent -f .git/HEAD ; then vc_which=$vc_scm_git
  elif which git &> /dev/null && [[ -n "$(git rev-parse --is-inside-work-tree 2> /dev/null)" ]]; then vc_which=$vc_scm_git
  elif [[ -d .svn ]]; then vc_which=$vc_scm_svn
  else vc_which=$vc_scm_none
  fi
}

vc_prompt_char() {
  if [[ -z $vc_which ]]; then vc_scm; fi
  if [[ $vc_which == $vc_scm_git ]]; then vc_char=$vc_git_char
  elif [[ $vc_which == $vc_scm_svn ]]; then vc_char=$vc_svn_char
  else vc_char=$vc_none_char
  fi
}

vc_scm_prompt_info() {
  vc_scm
  vc_prompt_char
  vc_prompt_info_common
}

vc_prompt_info_common() {
  vc_dirty=0
  vc_state=''

  if [[ ${vc_which} == ${vc_scm_git} ]]; then
    if [[ ${vc_git_show_minimal_info} == true ]]; then
      vc_git_prompt_minimal_info
    else
      vc_git_prompt_info
    fi
    return
  fi

  [[ ${vc_which} == ${vc_scm_svn} ]] && vc_svn_prompt_info && return
}

vc_git_prompt_minimal_info() {
  vc_state=${vc_prompt_clean}

  vc_git_hide_status && return

  vc_branch="${vc_branch_prefix}$(vc_git_friendly_ref)${vc_branch_suffix}"

  if [[ -n "$(vc_git_status | tail -n1)" ]]; then
    vc_dirty=1
    vc_state=${vc_prompt_dirty}
  fi

  echo -e "${vc_prompt_prefix}${vc_branch}${vc_state}${vc_prompt_suffix}"
}

vc_git_prompt_vars() {
  if vc_git_branch &> /dev/null; then
    vc_git_detached="false"
    vc_branch="${vc_branch_prefix}$(vc_git_friendly_ref)$(vc_git_remote_info)${vc_branch_suffix}"
  else
    vc_git_detached="true"

    local detached_prefix detached_suffix
    if vc_git_tag &> /dev/null; then
      detached_prefix=${vc_tag_prefix}
      detached_suffix=${vc_tag_suffix}
    else
      detached_prefix="${vc_detached_prefix}${vc_git_detached_char}"
      detached_suffix=${vc_detached_suffix}
    fi
    vc_branch="${detached_prefix}$(vc_git_friendly_ref)${detached_suffix}"
  fi

  IFS=$'\t' read -r commits_behind commits_ahead <<< "$(vc_git_upstream_behind_ahead)"
  [[ "${commits_ahead}" -gt 0 ]] && vc_branch+=" ${vc_git_ahead_char}${commits_ahead}"
  [[ "${commits_behind}" -gt 0 ]] && vc_branch+=" ${vc_git_behind_char}${commits_behind}"

  local stash_count
  stash_count="$(git stash list 2> /dev/null | wc -l | tr -d ' ')"
  [[ "${stash_count}" -gt 0 ]] && vc_branch+=" ${vc_git_stash_char_prefix}${stash_count}${vc_git_stash_char_suffix}"

  if vc_git_status ; then
    vc_state=${vc_prompt_clean}
  else
    vc_state=${vc_prompt_dirty}
  fi
  if ! vc_git_hide_status; then
    IFS=$'\t' read -r untracked_count unstaged_count staged_count <<< "$(vc_git_status_counts)"
    if [[ "${untracked_count}" -gt 0 || "${unstaged_count}" -gt 0 || "${staged_count}" -gt 0 ]]; then
      vc_dirty=1
      if [[ "${vc_git_show_details}" = "true" ]]; then
        [[ "${staged_count}" -gt 0 ]] && vc_branch+=" ${vc_git_staged_char}${staged_count}" && vc_dirty=3
        [[ "${unstaged_count}" -gt 0 ]] && vc_branch+=" ${vc_git_unstaged_char}${unstaged_count}" && vc_dirty=2
        [[ "${untracked_count}" -gt 0 ]] && vc_branch+=" ${vc_git_untracked_char}${untracked_count}" && vc_dirty=1
      fi
      vc_state=${vc_prompt_dirty}
    fi
  fi

  vc_change=$(vc_git_short_sha 2>/dev/null || echo "")
}

vc_svn_prompt_vars() {
  if [[ -n $(svn status 2> /dev/null) ]]; then
    vc_dirty=1
    vc_state=${vc_prompt_dirty}
  else
    vc_dirty=0
    vc_state=${vc_prompt_clean}
  fi
  vc_branch=$(svn info 2> /dev/null | awk -F/ '/^URL:/ { for (i=0; i<=NF; i++) { if ($i == "branches" || $i == "tags" ) { print $(i+1); break }; if ($i == "trunk") { print $i; break } } }') || return
  vc_change=$(svn info 2> /dev/null | sed -ne 's#^Revision: ##p' )
}

vc_git_prompt_info() {
  vc_git_prompt_vars
  echo -e "${vc_prompt_prefix}${vc_branch}${vc_state}${vc_prompt_suffix}"
}

vc_svn_prompt_info() {
  vc_svn_prompt_vars
  echo -e "${vc_prompt_prefix}${vc_branch}${vc_state}${vc_prompt_suffix}"
}

vc_scm_char() {
  vc_prompt_char
  echo -e "${vc_char_prefix}${vc_char}${vc_char_suffix}"
}

vc_git_symbolic_ref() {
 git symbolic-ref -q HEAD 2> /dev/null
}

vc_git_branch() {
 git symbolic-ref -q --short HEAD 2> /dev/null || return 1
}

vc_git_tag() {
  git describe --tags --exact-match 2> /dev/null
}

vc_git_commit_description() {
  # git describe --contains --all 2> /dev/null
  return 1
}

vc_git_short_sha() {
  git rev-parse --short HEAD
}

# Try the checked-out branch first to avoid collision with branches pointing to the same ref.
vc_git_friendly_ref() {
    vc_git_branch || vc_git_tag || vc_git_commit_description || vc_git_short_sha
}

vc_git_num_remotes() {
  git remote | wc -l
}

vc_git_upstream() {
  local ref
  ref="$(vc_git_symbolic_ref)" || return 1
  git for-each-ref --format="%(upstream:short)" "${ref}"
}

vc_git_upstream_remote() {
  local upstream
  upstream="$(vc_git_upstream)" || return 1

  local branch
  branch="$(vc_git_upstream_branch)" || return 1
  echo "${upstream%"/${branch}"}"
}

vc_git_upstream_branch() {
  local ref
  ref="$(vc_git_symbolic_ref)" || return 1

  git for-each-ref --format="%(upstream:strip=3)" "${ref}" 2> /dev/null
}

vc_git_upstream_behind_ahead() {
  git rev-list --left-right --count "$(vc_git_upstream)...HEAD" 2> /dev/null
}

vc_git_upstream_branch_gone() {
  [[ "$(git status -s -b | sed -e 's/.* //')" == "[gone]" ]]
}

vc_git_hide_status() {
  [[ "$(git config --get dotdot.hide-status)" == "1" ]]
}

vc_git_status() {
  git diff-index --quiet HEAD 2> /dev/null
}

vc_git_status_counts() {
  vc_git_status | awk '
  BEGIN {
    untracked=0;
    unstaged=0;
    staged=0;
  }
  {
    if ($0 ~ /^\?\? .+/) {
      untracked += 1
    } else {
      if ($0 ~ /^.[^ ] .+/) {
        unstaged += 1
      }
      if ($0 ~ /^[^ ]. .+/) {
        staged += 1
      }
    }
  }
  END {
    print untracked "\t" unstaged "\t" staged
  }'
}

vc_git_remote_info() {
  [[ "$(vc_git_upstream)" == "" ]] && return

  local remote_info

  [[ "$(vc_git_branch)" == "$(vc_git_upstream_branch)" ]] && local same_branch_name=true
  if ([[ "${vc_git_show_remote_info}" = "auto" ]] && [[ "$(vc_git_num_remotes)" -ge 2 ]]) ||
      [[ "${vc_git_show_remote_info}" = "true" ]]; then
    if [[ "${same_branch_name}" != "true" ]]; then
      remote_info="\$(vc_git_upstream)"
    else
      remote_info="\$(vc_git_upstream_remote)"
    fi
  elif [[ ${same_branch_name} != "true" ]]; then
    remote_info="\$(vc_git_upstream_branch)"
  fi
  if [[ -n "${remote_info}" ]];then
    local branch_prefix branch_suffix
    if vc_git_upstream_branch_gone; then
      branch_prefix="${vc_branch_gone_prefix}"
      branch_suffix="${vc_branch_gone_suffix}"
    else
      branch_prefix="${vc_branch_track_prefix}"
      branch_suffix="${vc_branch_track_suffix}"
    fi
    echo "${branch_prefix}${remote_info}${branch_suffix}"
  fi
}


#
# Must be last - allow for root user overrides
#
[ "$UID" = "0" ] && source "${DOTHOME}/root.sh"
