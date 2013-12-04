################################
#
# Generic library of stuff for bas

function elementIndex() {
    local needle=${1:?Needle not specified}
    local junk=${2:?Array not specified}

    local haystackname=$2[@]
    local haystack=("${!haystackname}")

    for (( i = 0; i < ${#haystack[@]}; i++ )); do
        if [ "${haystack[$i]}" = "${needle}" ]; then
            echo $i
            return 0
        fi
    done
    echo ""
    return 1
}
