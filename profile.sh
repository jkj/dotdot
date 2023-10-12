# ~/.profile: executed by the command interpreter for login shells.
UNAMES=`uname -s 2> /dev/null`
export UNAMES

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

# Set PATH to include Homebrew if it exists
[ -d /opt/homebrew/bin ] && {
    PATH="/opt/homebrew/bin:$PATH"
}

# Set PATH to include Go if it exists
[ -d /usr/local/go/bin ] && {
    PATH="/usr/local/go/bin:$PATH"
}
[ -d "${HOME}/go/bin"  ] && {
    PATH="${HOME}/go/bin:$PATH"
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

#node_dir=/usr/local/node-v16.18.0-linux-x64
#if [ -d "$node_dir" ]; then
#    PATH="$node_dir/bin:$PATH"
#fi

if [ "${UNAMES}" = "Darwin" ]; then
    PATH="$PATH:/Users/kean/Library/Application Support/JetBrains/Toolbox/scripts"
fi
