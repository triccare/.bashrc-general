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

function ur_list() {
    local dotureka urekapath location variant result

    dotureka=$HOME/.ureka
    result=()

    for urekapath in `find $dotureka -type d -mindepth 1`; do
        urekaname=(${urekapath//\// })
        urekaname=${urekaname[${#urekaname[@]} -1]}
        location=`cat ${urekapath}/location`
        if [ -e $location ]; then
            for variant in `find $location/variants -type d -mindepth 1 -maxdepth 1`; do
                variantname=(${variant//\// })
                variantname=${variantname[${#variantname[@]} -1]}
                result+=("$urekaname,$variantname,$location/variants/$variantname")
            done
        fi
    done

    echo ${result[@]}

}; export -f ur_list

function ur_switch() {
    local alphabet conflist urargs name variant index mode modeIndex variant_path
    alphabet=({a..z})
    conflist=()
    urargs=()

    for ureka in `ur_list`; do
        ureka=(${ureka//,/ })
        name=${ureka[0]}
        variant=${ureka[1]}
        variant_path=${ureak[2]}
        conflist+=("${name}/${variant}")
        urargs+=("${variant} ${name}")
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
}; export -f ur_switch

function ur_remove() {
    local alphabet conflist rmargs name variant index mode modeIndex variant_path
    alphabet=({a..z})
    conflist=()
    rmargs=()

    for ureka in `ur_list`; do
        ureka=(${ureka//,/ })
        name=${ureka[0]}
        variant=${ureka[1]}
        variant_path=${ureka[2]}
        if [ $variant != "common" ]; then
            conflist+=("${name}/${variant}")
            rmargs+=("${variant_path}")
        fi
    done

    for ((index=0; index<${#conflist[@]}; index++)); do
        echo -e "[${alphabet[$index]}] ${conflist[$index]} <${rmargs[$index]}>"
    done
    
    read -n 1 -p 'Remove? ' mode
    echo

    modeIndex=$(elementIndex $mode alphabet)
    if [ "$modeIndex" -gt "$index" ]; then
        echo "No change in environment"
    else
        read -p "Remove ${conflist[$modeIndex]} (n/YES)? " confirm
        echo

        if [ $confirm = 'YES' ]; then
            rm -rfv ${rmargs[$modeIndex]}
        else
            echo 'Nope, no delete for you!'
        fi
    fi

}; export -f ur_remove
