# Ureka setup: personal commands

# Figure out which one we're using
function ur_what() {
    if [ -z $UR_DIR ]; then
        echo 'No Ureka in use'
    else
        local patharray=(${UR_DIR//\// })
        local ureka=${patharray[${#patharray} - 2]}
        echo "${ureka}/${UR_VARIANT}"
    fi
}

function ur_switch() {
    local alphabet conflist urargs dotureka name location lpath lname Variants variant index mode modeIndex
    alphabet=({a..z})
    conflist=()
    urargs=()
    dotureka=$HOME/.ureka

    for name in `ls $dotureka`; do
        if [ -d "$dotureka/$name" ]; then
            location=`cat $dotureka/$name/location`
            lpath=(${location//\// })
            lname=${lpath[${#lpath} -2]}
            if [ -e $location ]; then
                Variants=$location/variants
                for variant in `ls $Variants`; do
                    conflist+=("(${name})\t${lname}/${variant}")
                    urargs+=("${variant} ${name}")
                done
            fi
        fi
    done

    for ((index=0; index<${#conflist[@]}; index++)); do
        echo -e "[${alphabet[$index]}] ${conflist[$index]}"
    done
    
    read -n 1 -p 'Enter mode: ' mode
    echo

    modeIndex=$(elementIndex $mode alphabet)
    if [ "$modeIndex" -gt "$index" ]; then
        echo "No change in environment"
    else
        ur_setup ${urargs[$modeIndex]}
    fi

    ur_what
}
