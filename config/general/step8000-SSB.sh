#############
# SSB development

# SSB
function myraf() { pyraf --ipython; }; export -f myraf

# SSB CRDS
function togglecrdspath() {
    current_path=$CRDS_PATH
    CRDS_PATH=${CRDS_PATH_ALTERNATE:-"/tmp"}
    CRDS_PATH_ALTERNATE=$current_path

    current_url=$CRDS_SERVER_URL
    CRDS_SERVER_URL=${CRDS_SERVER_URL_ALTERNATE:="/https://hst-crds.stsci.edu"}
    CRDS_SERVER_URL_ALTERNATE=$current_url

    echo "CRDS_PATH $current_path -> $CRDS_PATH"
    echo "CRDS_SERVER_URL $current_url -> $CRDS_SERVER_URL"
}; export -f togglecrdspath

# Setup various command line shortcuts
function crds_diff() { _pythonmodulerun $FUNCNAME $*; }; export -f crds_diff
function crds_rowdiff() { _pythonmodulerun $FUNCNAME $*; }; export -f crds_rowdiff
