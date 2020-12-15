#
# virtualenv helpers
####################
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python_support
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_HOOK_DIR=$HOME/bin/python_support/virtualenvs
export PROJECT_HOME=$HOME/Documents/projects_vw
if [ -e /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

#
# Install PyQt from base install
function loadpyqt() {

    # Load up the main PyQt bindings
    local LIBS=( PyQt4 sip.so )

    local PYTHON_VERSION=python$(python -c "import sys; print (str(sys.version_info[0])+'.'+str(sys.version_info[1]))")
    local VAR=( $(which -a $PYTHON_VERSION) )

    local GET_PYTHON_LIB_CMD="from distutils.sysconfig import get_python_lib; print (get_python_lib())"
    local LIB_VIRTUALENV_PATH=$(python -c "$GET_PYTHON_LIB_CMD")
    local LIB_SYSTEM_PATH=$(${VAR[${#VAR[@]} - 1]} -c "$GET_PYTHON_LIB_CMD")

    local LIB
    for LIB in ${LIBS[@]}
    do
        ln -s $LIB_SYSTEM_PATH/$LIB $LIB_VIRTUALENV_PATH/$LIB 
    done
}; export -f loadpyqt 
