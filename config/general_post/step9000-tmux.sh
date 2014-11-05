# tmux final run cleanup

if [ -n "$TMUX" ]; then
    local path=`tmux show-environment PATH`
    export PATH=${path#PATH=}
fi
