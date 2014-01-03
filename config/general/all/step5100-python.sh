###################
#
# General python setup

# Where to find my stuff.
export PYTHONPATH=~/bin/python/lib
export PYTHONSTARTUP=~/bin/python/startup.py

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
