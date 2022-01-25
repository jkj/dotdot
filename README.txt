This is my collection of Bourne-compatible shell rcfiles with the prompts and
aliases set up just the way I like them. If you find any bugs please report
them to me@keanjohnston.com. This is not meant to be a general purpose library
suitable for everyone. It is fairly specific to my envionment. In particular:

o  Requires GNU Bash 5.0 or greater if using Bash.
o  Requires ZSH 5.8 or later if using Zsh.
o  Requires Git 2.14 or later for correct prompt behaviour in Git repos.
o  Requires Subversion 1.14 or later for correct prompt behaviour in SVN repos.
o  Requires a modern terminal such as the one that comes with Ubuntu 20.04.
o  Requires your terminal window to be at least 150 columns wide, 175 better.
o  Requires kubectx and kubectl on your PATH for correct prompt info for k8s.
o  Looks much better with a dark background and the XTerm colour pallette.

INSTALLATION
============
cd $HOME
git clone https://github.com/jkj/dotdot.git .dot.dot

Edit the files bashrc and zshrc and set the variable DOTHOME to the full path
of this directory. Do NOT use $HOME when setting DOTHOME, it will break things
for root.

Move your existing RC files aside and create *hard* links as follows:
  cd $HOME
  ln $DOTHOME/bashrc.sh .bashrc
  ln $DOTHOME/zshrc.sh .zshrc
  ln $DOTHOME/profile.sh .profile    # Possibly not for root - take a look
  ln $DOTHOME/vimrc .vimrc           # Optional
  ln $DOTHOME/tmux.conf .tmux.conf   # Optional

Do the same thing for the root user. If the root user's home directory is on a
different filesystem to the user you extracted this for, then you will need to
use symbolic links, but if at all possible hard links are better.

If you want to put private, personal customisations and variable settings the
thing to do is to create a file called ${USER}.sh in your ${DOTHOME}. This is
sourced before the common code so for example, this is the place to set the
DOTDOT_AWS_PROD_ID variable to the account ID of your production account. This
will cause any k8s context in that account to be coloured more prominently so
you don't accidentally mess with the wrong cluster.

Log out completely and log back in again. Enjoy.

CREDITS
=======
Almost all of the VC stuff comes from Bash-IT. Most of the rest is my own doing
but this wouldn't be half as cool as it is without Bash-IT. I have tweaked that
code to eliminate unnecessary execs and to speed things up in a few places, in
particular for git repositories with very large number of files. Thus any bugs
are mine and should not reflect on the original authors.

COPYING
=======
I couldn't find any specific license for Bash-IT but all the code I wrote and
this collection as a whole is licensed under the Apache Software Foundation
License, Version 2.0.
