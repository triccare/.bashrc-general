################
# Appearance
################

# Prompt
export PS1='\h:\W$ '

################
# Aliases
################

# interactive file manipulation aliases
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

#  directory listing aliases
alias l="ls -FG"

alias ll="ls -laG"
alias la="ls -aFG"

################
# Environmental
################

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#################
# Setup commands
#################

# Folders
function back() { cd -; }; export -f back
function pu() { pushd "$@"; }; export -f pu
function po() { popd; }; export -f po
function lsd() 
{ 
    find ${1-.} -type d -maxdepth 1| awk 'BEGIN { FS = "/" } ; { print $NF }'|column; 
}; export -f lsd

# Emacs
function ec() {
    emacsclient $@;
}; export -f ec

# SSB
function myraf() { pyraf --ipython; }; export -f myraf

# SSB CRDS
function togglecrdspath() {
    current=$CRDS_PATH
    CRDS_PATH=${CRDS_PATH_ALTERNATE:-'~/Documents/ssbdev/testdata/crds'}
    CRDS_PATH_ALTERNATE=$current
    echo "CRDS_PATH $current -> $CRDS_PATH"
}; export -f togglecrdspath
