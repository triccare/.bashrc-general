####################
#
# Setup for generic git tunnelling

function ssh_stealthy() {
    sshserver=$1
    if [ -z $sshserver ]; then
        read -p 'ssh server: ' sshserver
    fi
    ssh -f -N $sshserver
}; export -f ssh_stealthy
