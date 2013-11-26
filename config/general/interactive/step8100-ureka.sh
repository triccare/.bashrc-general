# Ureka setup: personal commands

# Default usable and development
function ur_active() {
    ur_setup active primary
}

# Development Ureka
function ur_dev() {
    ur_setup develop primary
}

# Daily default and development
function ur_daily_active() {
    ur_setup active daily-dev
}
function ur_daily_dev() {
    ur_setup develop daily-dev
}

# Figure out which one we're using
function ur_what() {
    if [ -z $UR_DIR ]; then
        echo 'No Ureka in use'
    else
        patharray=(${UR_DIR//\// })
        ureka=${patharray[${#patharray} - 2]}
        echo "${ureka}/${UR_VARIANT}"
    fi
}

function ur_switch() {
    conflist=()
    urargs=()
    dotureka=$HOME/.ureka
    for name in `ls $dotureka`; do
        if [ -d "$dotureka/$name" ]; then
            l=`cat $dotureka/$name/location`
            lpath=(${l//\// })
            lname=${lpath[${#lpath} -2]}
            if [ -e $l ]; then
                V=$l/variants
                for v in `ls $V`; do
                    conflist+=("(${name})\t${lname}/${v}")
                    urargs+=("${v} ${name}")
                done
            fi
        fi
    done

    for ((i=0; i<${#conflist[@]}; i++)); do
        echo -e "[$i] ${conflist[$i]}"
    done
    
    read -n 1 -p 'Enter mode: ' mode
    echo

    ur_setup ${urargs[$mode]}
    ur_what
}
