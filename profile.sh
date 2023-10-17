# ~/.profile: executed by the command interpreter for login shells.
UNAMES=`uname -s 2> /dev/null`
if [ "${UNAMES}" = "Darwin" ]; then
  DOTARCH=mac
  HOMEROOT=/Users
else
  DOTARCH=linux
  HOMEROOT=/home
fi

export UNAMES DOTARCH HOMEROOT

umask 022

# For MacOS in case you want to use bash.
export BASH_SILENCE_DEPRECATION_WARNING=1

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

if [ "${DOTARCH}" = "mac" ]; then
    # Set PATH to include Homebrew if it exists
    [ -d /opt/homebrew/bin ] && {
        PATH="/opt/homebrew/bin:$PATH"
    }
fi

# Set PATH to include Go if it exists
[ -d /usr/local/go/bin ] && {
    export GOROOT=/usr/local/go
    PATH="/usr/local/go/bin:$PATH"
}

[ -d /u/go ] && {
    export GOPATH=/u/go
    PATH="/u/go/bin:$PATH"
}

[ -z "${GOPATH}" -a -d "${HOME}/go/bin"  ] && {
    export GOPATH="${HOME}/go"
    PATH="${HOME}/go/bin:$PATH"
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ "${DOTARCH}" = "linux" ]; then
    node_dir="/usr/local/node-v18.18.0-linux-x64"
fi

if [ -n "${node_dir}" -a -d "${node_dir}" ]; then
    PATH="${node_dir}/bin:$PATH"
fi

if [ "${DOTARCH}" = "mac" ]; then
    # add Jetbrains toolbox launcher scripts
    if [ -d "/${HOME}/Library/Application Support/JetBrains/Toolbox/scripts" ] ; then
        PATH="$PATH:/${HOME}/Library/Application Support/JetBrains/Toolbox/scripts"
    fi
    PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${HOME}/Library/Python/3.10/bin:${PATH}"
fi

if [ "${DOTARCH}" = "linux" ]; then
    # add Jetbrains toolbox launcher scripts
    if [ -d "$HOME/.local/share/JetBrains/Toolbox/scripts" ] ; then
        PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
    fi
fi
