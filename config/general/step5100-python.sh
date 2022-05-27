###################
#
# General python setup

################
#
# Where to find my stuff.
export PYTHONPATH=$HOME/bin/python_support/lib

# ############
# python shell
function pybash() {
    ipython --profile=cmdshell
}

###################
#
# Basic install of environment
function pipsetup() {
    #echo "pipsetup: Updating currently installed pips"
    #python -m piprefresh
    echo "pipsetup: Installing required pips"
    pip install --upgrade -r $HOME/bin/python_support/pip-basic-requirements.txt $PYTHONUSEUSER $@
}; export -f pipsetup

function pipscience() {
    echo "pipscience: Updatiing currently installed pips..."
    python -m piprefresh
    echo "pipscience: Installing science pips..."
    pip install --upgrade -r $HOME/bin/python_support/pip-science-requirements.txt $PYTHONUSEUSER $@
}; export -f pipscience

function pypkgclean() {
    rm -rf ./build ./docs/build ./docs/_build
    python setup.py clean
}; export -f pypkgclean

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

#########################
# Python Notebook helpers

# Startup an ipython notebook in silence
function pynb_plain() {
    local tmpdir=${TMPDIR:-/tmp}
    tmpdir=${tmpdir%/}
    local venv=${VIRTUAL_ENV-"sys"}
    venv=${venv##*/}
    local cwd=${PWD##*/}
    local fname="${venv}_${cwd}"
    nohup ipython notebook > $tmpdir/$fname.log &
}; export -f pynb_plain

function pynb() {
    local ur
    ur=`ur_what`
    local urcomp=(${ur//\// })
    local sname dname
    dname=`pwd`
    dname=`basename $dname`
    sname="${ur}/${dname}"
    tmux new-session -s "$sname" "ur_setup ${urcomp[1]} ${urcomp[0]}; ipython notebook"
}; export -f pynb

#
# Find and open an already existing iPython Notebook
function pynb_open() {

    local alphabet conflist host index junk mode modeIndex nports port port_check port_start

    port_start=8888
    nports=10
    host="http://127.0.0.1:"
    port_check="curl -I -s ${host}"

    alphabet=({a..z} \~)
    conflist=()

    for port in `seq ${port_start} $(($port_start + $nports))`; do
        junk=`${port_check}${port}`
        if [ $? -eq 0 ]; then
            conflist+=("${port}")
        fi
    done

    if [ -n "$conflist" ]; then
        for ((index=0; index<${#conflist[@]}; index++)); do
            echo -e "[${alphabet[$index]}] ${conflist[$index]}"
        done

        read -n 1 -p 'Open which notebook? ' mode
        echo

        modeIndex=$(elementIndex ${mode:-\~} alphabet)
        if [ "$modeIndex" -gt `expr ${#conflist[@]} - 1` ]; then
            echo "Invalid notebook: Really!?!? I gave you the list..."
        else
            open ${host}${conflist[$modeIndex]}
        fi
    else
        echo "No notebook server running...try starting one..."
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

    cp -iv $HOME/bin/python_support/lib/template.ipynb $1$ext

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

    cp -iv $HOME/bin/python_support/lib/kata-template.py $1$ext

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

    cp -iv $HOME/bin/python_support/lib/module_template.py $1$ext

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
