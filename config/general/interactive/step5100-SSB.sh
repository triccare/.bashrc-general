#############
# SSB development

# SSB
function myraf() { pyraf --ipython; }; export -f myraf

# SSB CRDS
export CRDS_PATH_ALTERNATE=${CRDS_PATH_ALTERNATE:-"${HOME}/Documents/ssbdev/testdata/crds/hst"}
function togglecrdspath() {
    current=$CRDS_PATH
    CRDS_PATH=${CRDS_PATH_ALTERNATE:-"/tmp"}
    CRDS_PATH_ALTERNATE=$current
    echo "CRDS_PATH $current -> $CRDS_PATH"
}; export -f togglecrdspath

# Setup various command line shortcuts
function crds_diff() { _pythonmodulerun $FUNCNAME $*; }; export -f crds_diff
