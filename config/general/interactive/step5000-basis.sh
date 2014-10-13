################
# Appearance
################

# Prompt
export PS1='[\u@\h \W]\\$ '
export PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'

function term_title() {
    echo -ne "\033]0;"$*"\007"
}; export -f term_title

################
# Aliases
################

# interactive file manipulation aliases
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

#  directory listing aliases
alias l="ls -FG"

alias ll="ls -lah"
alias la="ls -aFGh"

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

# Folders
function back() { cd -; }; export -f back
function pu() { pushd "$@"; }; export -f pu
function po() { popd; }; export -f po
function gohome() { cd; dirs -c; }; export -f gohome
function lsd() {
    find ${1-.} -type d -maxdepth 1| awk 'BEGIN { FS = "/" } ; { print $NF }'|column; 
}; export -f lsd

# Process handling
function fp() { # Find a process
    ps axu | grep -i $1 | grep -v grep
}; export -f fp

# Search a tree
function egdown() {
    find . -iname "${2}" -follow -type f -exec egrep -iH "${1}" {} \; | more
}; export -f egdown
function fs() {
    find . -iname "*${1}*"
}; export -f fs

# Use rsync as copy
function csync() {
    rsync -PLur "$@"
}; export -f csync
