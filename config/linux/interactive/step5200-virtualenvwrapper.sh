#
# virtualenv helpers
####################
#export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python_support
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_HOOK_DIR=$HOME/bin/python_support/virtualenvs
export PROJECT_HOME=$HOME/Documents/projects_vw
if [ -e /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi
