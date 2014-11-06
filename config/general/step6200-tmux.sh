# tmux utilities
function mktmux() {
    local name="`date +%Y%m%d`-`date +%k%M%S`"
    if [ "$1" ]; then
        name="$1"
    fi
    tmux new-session -s "$name"
}; export -f mktmux

function attach() {

    local conflist
    alphabet=({a..z} \~)
    conflist=()

    local session
    for session in `tmux list-session -F "#S"`; do
        conflist+=("$session")
    done

    if [ -n "$conflist" ]; then
        local index
        for ((index=0; index<${#conflist[@]}; index++)); do
            echo -e "[${alphabet[$index]}] ${conflist[$index]}"
        done

        read -n 1 -p 'Attach to? ' session
        echo
    
        local answerIndex=$(elementIndex ${session:-\~} alphabet)
        if [ "$answerIndex" -gt "$index" ]; then
            echo "Wrong answer! Nothing done for you!"
        else
            tmux attach -t ${conflist[$answerIndex]}
        fi

    else
        echo "No tmux to mux to...start a tmux next time."
    fi

}; export -f attach
