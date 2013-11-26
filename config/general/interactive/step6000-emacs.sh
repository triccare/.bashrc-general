#####################
#
# General emacs setup

# shortcut for emacs startup.
function ec() {
    emacsclient $@;
}; export -f ec
