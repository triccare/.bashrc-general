# tmux utilities
function mktmux() {
    local name="`date +%Y%m%d`-`date +%k%M%S`"
    tmux new-session -s "$name"
}; export mktmux
