###################
#
# General python setup

# Where to find my stuff.
export PYTHONPATH=~/bin/python/lib
export PYTHONSTARTUP=~/bin/python/startup.py

#
# virtualenv helpers
####################
export PYVIRTPATH=$HOME/bin/python_virtualenv

function pyvirt_new() {
    local name

    name=$1
    if [ -z $name ]; then
        read -p 'New virtualenv name: ' name
    fi

    deactivate
    pushd $PYVIRTPATH
    virtualenv $name
    popd
    source $PYVIRTPATH/$name/bin/activate
}; export -f pyvirt_new

function pyvirt_list() {
    local result virtpath virtname format resline

    format=
    if [ -z $1 ]; then
        format='format'
    fi

    result=()
    for virtpath in `find $PYVIRTPATH -type d -mindepth 1 -maxdepth 1`; do
        virtname=(${virtpath//\// })
        virtname=${virtname[${#virtname[@]} -1]}
        result+=($virtname)
    done

    if [ -z $format ]; then
        echo ${result[@]}
    else
        resline=${result[@]}
        echo -e ${resline// /\\n}
    fi

}; export -f pyvirt_list


function pyvirt_activate() {
    
    name=$1
    if [ -z $name ]; then
        read -p 'Which env? ' name
    fi

    source ${PYVIRTPATH}/${name}/bin/activate
}; export -f pyvirt_activate

function pyvirt_switch() {
    local alphabet conflist name index mode modeIndex
    alphabet=({a..z})
    conflist=()

    for name in `pyvirt_list noformat`; do
        conflist+=("${name}")
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
        deactivate 2> /dev/null
        pyvirt_activate ${conflist[$modeIndex]}
    fi

}; export -f pyvirt_switch

function pyvirt_remove() {
    local alphabet conflist name index mode modeIndex confirm
    alphabet=({a..z})
    conflist=()

    for name in `pyvirt_list noformat`; do
        conflist+=("${name}")
    done

    for ((index=0; index<${#conflist[@]}; index++)); do
        echo -e "[${alphabet[$index]}] ${conflist[$index]}"
    done
    
    read -n 1 -p 'Remove which mode? ' mode
    echo

    modeIndex=$(elementIndex $mode alphabet)
    if [ "$modeIndex" -gt `expr ${#conflist[@]} - 1` ]; then
        echo "Nothing removed."
    else
        read -p "Remove ${conflist[$modeIndex]} (n/YES)? " confirm
        echo

        if [ $confirm = 'YES' ]; then
            rm -rfv ${PYVIRTPATH}/${conflist[$modeIndex]}
        else
            echo 'Nope, no delete for you!'
        fi
    fi
}; export pyvirt_remove

# Run python modules
# Create functions with the name of the module to run
# substituting '_' for '.'
#
# Example:
#    function class_subclass_module { 
#      _pythonmodulerun $FUNCNAME $*
#    }; export -f class_subclass_module
function _pythonmodulerun() {
    cmd=${1//_/.}
    shift
    python -m $cmd $@ 
}; export -f _pythonmodulerun

# Setup for refreshing all packages
function piprefreshall() {
    ur_forget
    python -m piprefresh
    python3 -m piprefresh
}; export -f piprefreshall

# Startup an ipython notebook in silence
function pynb() {
    nohup ipython notebook >& /dev/null &
}; export -f pynb

#
# Python Notebook helpers
#########################

#
# Find and open an already existing iPython Notebook
function pynb_open() {

    local alphabet conflist host index junk mode modeIndex nports port port_check port_start

    port_start=8888
    nports=10
    host="http://127.0.0.1:"
    port_check="curl -I -s ${host}"

    alphabet=({a..z})
    conflist=()

    for port in `seq ${port_start} $(($port_start + $nports))`; do
        junk=`${port_check}${port}`
        if [ $? -eq 0 ]; then
            conflist+=("${port}")
        fi
    done

    for ((index=0; index<${#conflist[@]}; index++)); do
        echo -e "[${alphabet[$index]}] ${conflist[$index]}"
    done
    
    read -n 1 -p 'Open which notebook? ' mode
    echo

    modeIndex=$(elementIndex $mode alphabet)
    if [ "$modeIndex" -gt `expr ${#conflist[@]} - 1` ]; then
        echo "Invalid notebook."
    else
        open ${host}${conflist[$modeIndex]}
    fi
}; export -f pynb_open
