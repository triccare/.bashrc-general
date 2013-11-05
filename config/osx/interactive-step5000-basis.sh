################
# Environmental
################

# Editor
export EDITOR='ec'

#################
# Setup commands
#################

# Emacs
function emacs() {
    open -a /Applications/Emacs.app $@;
}; export -f emacs
function ec() {
    /Applications/Emacs.app/Contents/MacOS/bin/emacsclient $@;
}; export -f ec
