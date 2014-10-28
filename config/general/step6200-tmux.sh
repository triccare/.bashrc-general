# tmux utilities
function mktmux() {
    local name="`date +%Y%m%d`-`date +%k%M%S`"
    tmux new-session -s "$name"
}; export -f mktmux

function attach() {
    local session

    alphabet=({a..z})
    conflist=()

    for session in `tmux list-session -F "#S"`; do
        conflist+=("$session")
    done

    for ((index=0; index<${#conflist[@]}; index++)); do
        echo -e "[${alphabet[$index]}] ${conflist[$index]}"
    done

    read -n 1 -p 'Attache to? ' session
    echo

    answerIndex=$(elementIndex $session alphabet)
    if [ "$answerIndex" -gt "$index" ]; then
        echo "Wrong answer! Nothing done for you!"
    else
        tmux attach -t ${conflist[$answerIndex]}
    fi

}; export -f attach
