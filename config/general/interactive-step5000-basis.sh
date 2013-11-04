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

# Editor
export EDITOR='gui-emacs'

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
function emacs() {
    open -a /Applications/Emacs.app $@;
}; export -f emacs
function ec() {
    /Applications/Emacs.app/Contents/MacOS/bin/emacsclient $@;
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
