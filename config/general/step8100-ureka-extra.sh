# Ureka setup: personal commands

# Figure out which one we're using
function ur_what() {
    if [ -z $UR_DIR ]; then
        echo 'No Ureka in use'
    else
        local dotureka=$HOME/.ureka
        local regex=".*/(.*)/location"
        local path=`find $HOME/.ureka -name location -exec grep -iH "$UR_DIR" {} \;`
        if [[ "$path" =~ $regex ]]; then
            echo "${BASH_REMATCH[1]}/${UR_VARIANT}"
        else
            echo "Cannot find current setup, '${UR_DIR}, in '${dotureka}'"
        fi
    fi
}

function ur_clean() {
    local urekaname urekapath
    local dotureka=$HOME/.ureka

    for urekapath in `find $dotureka -mindepth 1 -type d`; do
        urekaname=(${urekapath//\// })
        urekaname=${urekaname[${#urekaname[@]} -1]}
        location=`cat ${urekapath}/location`
        if [ ! -e $location ]; then
            echo "Ureka '$urekaname' no longer actually exists, removing."
            /bin/rm -rfv $urekapath
        fi
    done
}; export -f ur_clean

function ur_list() {
    local dotureka format location result ureka urekapath variant

    format=
    if [ -z $1 ]; then
        format='format'
    fi

    dotureka=$HOME/.ureka
    result=()

    for urekapath in `find $dotureka -mindepth 1 -type d`; do
        urekaname=(${urekapath//\// })
        urekaname=${urekaname[${#urekaname[@]} -1]}
        location=`cat ${urekapath}/location`
        if [ -e $location ]; then
            for variant in `find $location/variants -mindepth 1 -maxdepth 1 -type d`; do
                variantname=(${variant//\// })
                variantname=${variantname[${#variantname[@]} -1]}
                result+=("$urekaname,$variantname,$location/variants/$variantname")
            done
        fi
    done

    if [ -z $format ]; then
        echo ${result[@]}
    else
        resline=${result[@]}
        echo -e ${resline// /\\n} | column -t -s, -c3
    fi

}; export -f ur_list

function ur_switch() {
    local alphabet conflist urargs name variant index mode modeIndex variant_path
    alphabet=({a..z})
    conflist=()
    urargs=()

    for ureka in `ur_list noformat`; do
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

    for ureka in `ur_list noformat`; do
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
            ur_forget
            rm -rfv ${rmargs[$modeIndex]}
        else
            echo 'Nope, no delete for you!'
        fi
    fi

}; export -f ur_remove

function ur_new() {
    if [ -z $1 ]; then
        echo "Usage: ur_new <new configuration name> [<ureka base installation>]"
        return 1
    fi

    ur_setup -n $1 $2
    loadpyqt
    python -m piprefresh
    pipsetup

}; export -f ur_new
