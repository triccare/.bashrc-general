# General setups for OS X

# iTerm tab naming
function term_title() {
    echo -ne "\033]0;"$*"\007"
}; export -f term_title
