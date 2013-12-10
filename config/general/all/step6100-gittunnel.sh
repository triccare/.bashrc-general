####################
#
# Setup for generic git tunnelling

function gittunnel() {
    localport=$1
    gitserver=$2
    sshserver=$3
    if [ -z $localport ]; then
        read -p 'local port: ' localport
    fi
    if [ -z $gitserver ]; then
        read -p 'git server: ' gitserver
    fi
    if [ -z $sshserver ]; then
        read -p 'ssh server: ' sshserver
    fi
    ssh -f -N -L $localport:$gitserver:22 $sshserver
}; export -f gittunnel

function gt_grit() {
    gittunnel 10022 grit.stsci.edu hecatean
}; export -f gt_grit
