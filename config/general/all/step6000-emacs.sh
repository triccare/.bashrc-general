#####################
#
# General emacs setup

export EDITOR=`which emacsclient`
export ALTERNATE_EDITOR=`which emacs`

function emacs-server() {
    `which emacs` &
}; export -f emacs-server
