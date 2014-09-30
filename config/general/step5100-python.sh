###################
#
# General python setup

###################
#
# Basic install of environment
function pipsetup() {
    echo "pipsetup: Updating currently installed pips"
    python -m piprefresh
    echo "pipsetup: Installing required pips"
    pip install --upgrade -r $HOME/bin/python/pip-basic-requirements.txt $PYTHONUSEUSER $@
}; export -f pipsetup

################
#
# Where to find my stuff.
export PYTHONPATH=$HOME/bin/python/lib
export PYTHONSTARTUP=$HOME/bin/python/startup.py
export PYTHONUSERBASE=$HOME/bin/python/pkgs

###################################
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

#
# Python Notebook helpers
#########################

# Startup an ipython notebook in silence
function pynb() {
    local venv=${VIRTUAL_ENV-"sys"}
    venv=${venv##*/}
    local cwd=${PWD##*/}
    tmux new-session -s "$venv/$cwd" -d 'ipython notebook'
}; export -f pynb

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

####################################
# Create different python files based on need.
#

# Create a new notebook
function mkpynb() {
    if [[ -z $1 ]]; then
        echo "Usage: mkpynb <filename>"
        return 1
    fi

    local ext=""
    if [ "$1" == "${1##*.}" ]; then
        ext='.ipynb'
    fi

    cp -iv $HOME/bin/python/lib/template.ipynb $1$ext

}; export -f mkpynb

# Create a new kata
function mkkata() {
    if [[ -z $1 ]]; then
        echo "Usage: mkkata <filename>"
        return 1
    fi

    local ext=""
    if [ "$1" == "${1##*.}" ]; then
        ext='.py'
    fi

    cp -iv $HOME/bin/python/lib/kata-template.py $1$ext

}; export -f mkkata

# Create a new module
function mkmodule() {
    if [[ -z $1 ]]; then
        echo "Usage: mkmodule <filename>"
        return 1
    fi

    local ext=""
    if [ "$1" == "${1##*.}" ]; then
        ext='.py'
    fi

    cp -iv $HOME/bin/python/lib/module_template.py $1$ext

}; export -f mkmodule

######
# PyQt install. Go from the base install.
function lnpyqt() {
    local LIBS=( PyQt4 sip.so )

    local PYTHON_VERSION=python$(python -c "import sys; print (str(sys.version_info[0])+'.'+str(sys.version_info[1]))")
    local VAR=( $(which -a $PYTHON_VERSION) )

    local GET_PYTHON_LIB_CMD="from distutils.sysconfig import get_python_lib; print (get_python_lib())"
    local LIB_VIRTUALENV_PATH=$(python -c "$GET_PYTHON_LIB_CMD")
    local LIB_SYSTEM_PATH=$(${VAR[${#VAR[@]} - 1]} -c "$GET_PYTHON_LIB_CMD")

    local LIB
    for LIB in ${LIBS[@]}; do
        ln -s $LIB_SYSTEM_PATH/$LIB $LIB_VIRTUALENV_PATH/$LIB 
    done
}; export -f lnpyqt
