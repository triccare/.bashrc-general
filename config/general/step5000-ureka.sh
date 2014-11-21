#######################
#
# UREKA setup

function ur_setup() {
    eval `$HOME/.ureka/ur_setup -sh $*`
}; export -f ur_setup
function ur_forget() {
    eval `$HOME/.ureka/ur_forget -sh $*`
}; export -f ur_forget
