#########################################
# boot - Boot a bash environment
#
# Concept
#    Basically this script runs through a list of files in the
#    'config' subfolder.
#
#    Within 'config', will be a list of subfolders,
#    referred to as 'package' folders,  all of
#    arbitrary names. Within each subfolder, will be the
#    actual BASH files.
#
#    The files are executed as follows:
#        all-stepDDDD-description.sh
#        nonlogin-stepDDDD-description.sh
#        login-stepDDDD-description.sh
#
#    where the following conventions are being used:
#        all == Executed always
#        nonlogin == Executed for nonlogin shells.
#        login == Executed for login shells.
#        interactive == Executed for interactive shells.
#        noninteractive == Executed for non-interactive shells.
# 
#        DDDD == A zero-fill number defining the order of execution, starting from 0.
#                NOTE: Does not need to be consecutive. Number to allow insertion.
#        description == Arbitrary description. Ignored by this script.
#
#    Which package folders, and in what order, is defined by the
#    environment variable 'BOOTENVBASH', a semicolon-separated
#    list of package folders to run through. If not defined, the
#    a default of 'general;<hostname>' will be used.
########################################

# Define the package list if not defined.
_BOOTENVBASH=${BOOTENVBASH-'general;'${HOSTNAME}}
pkgs=(${_BOOTENVBASH//;/ })

# Constants
CONFDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/config/"

# Define the file regex
fileregexall='all-step????-*.sh'
fileregexlogin='login-step????-*.sh'
fileregexnonlogin='nonlogin-step????-*.sh'
fileregexinteractive='interactive-step????-*.sh'
fileregexnoninteractive='noninteractive-step????-*.sh'

# Run through the packages
for pkg in "${pkgs[@]}"; do
    pkgpath=$CONFDIR$pkg
    if [ -d "$pkgpath" ]; then

        # Do the all scripts.
        globpath=$pkgpath'/'$fileregexall
        scripts=($globpath)
        if [ "${globpath}" != "${scripts}" ]; then
            for script in "${scripts[@]}"; do
                source "${script}"
            done
        fi

        # Do the login/non-login scripts
        if shopt -q login_shell ; then

            # Login shell
            globpath=$pkgpath'/'$fileregexlogin
            scripts=($globpath)
            if [ "${globpath}" != "${scripts}" ]; then
                for script in "${scripts[@]}"; do
                    source "${script}"
                done
            fi

        else

            # Non-login shell
            globpath=$pkgpath'/'$fileregexnonlogin
            scripts=($globpath)
            if [ "${globpath}" != "${scripts}" ]; then
                for script in "${scripts[@]}"; do
                    source "${script}"
                done
            fi
        fi

        # Do the interactive/non-interactive scripts
        if [ -z "$PS1" ] ; then

            # Non-interactive shell
            globpath=$pkgpath'/'$fileregexnoninteractive
            scripts=($globpath)
            if [ "${globpath}" != "${scripts}" ]; then
                for script in "${scripts[@]}"; do
                    source "${script}"
                done
            fi

        else

            # Interactive shell
            globpath=$pkgpath'/'$fileregexinteractive
            scripts=($globpath)
            if [ "${globpath}" != "${scripts}" ]; then
                for script in "${scripts[@]}"; do
                    source "${script}"
                done
            fi
        fi

    fi
done
