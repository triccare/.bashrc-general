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
#    The files are executed as follows, if $pkg represents the package
#     folder:
#        $pkg/stepDDDD-description.sh
#        $pkg/login/stepDDDD-description.sh <= only if login shell
#        $pkg/nonlogin/stepDDDD-description.sh <= only if non-login shell
#        $pkg/interactive/stepDDDD-description.sh <= only if  interactive shell
#        $pkg/noninteractive/stepDDDD-description.sh <= only if non-interactive shell
#
# where: 
#        DDDD == A zero-fill number defining the order of execution, starting from 0.
#                NOTE: Does not need to be consecutive. Number to allow insertion.
#        description == Arbitrary description. Ignored by this script.
#
#    Note: Each of the subfolders are then recursively searched as if
#    they are packages themselves. So each of the types can have a login,
#    nonlogin, interactive, and noninteractive subfolder. This allows for
#    all combinations, and many, many nonsensical combinations of shells.
#
#    Which package folders, and in what order, is defined by the
#    environment variable 'BOOTENVBASH', a semicolon-separated
#    list of package folders to run through. If not defined, the
#    a default of 'general;<hostname>' will be used.
########################################

# Define the package list if not defined.
_BB_ENV=${BOOTENVBASH-"general;"${HOSTNAME}}
_BB_pkgs=(${_BB_ENV//;/ })

# Constants
_BB_CONFDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/config/"

_BB_runpkg () {

    if [ ! -z "$1" ]; then
        local pkgpath=$1

        # Define the file regex
        local stepregex="step????-*.sh"

        if [ -d $pkgpath ]; then

            # Do the all scripts.
            local globpath=$pkgpath"/"$stepregex
            local scripts=($globpath)
            if [ "${globpath}" != "${scripts}" ]; then
                for script in "${scripts[@]}"; do
                    # echo "    executing script ${script}..."
                    source "${script}"
                done
            fi

            # Login/non-login shells
            if shopt -q login_shell ; then
                _BB_runpkg $pkgpath"/login"
            else
                _BB_runpkg $pkgpath"/nonlogin"
            fi

            # Do the interactive/non-interactive scripts
            if [ -z "$PS1" ] ; then
                _BB_runpkg $pkgpath"/noninteractive"
            else
                _BB_runpkg $pkgpath"/interactive"
            fi
        fi
    fi
}

# Run through the packages
for _BB_pkg in "${_BB_pkgs[@]}"; do
    # echo "Importing package ${_BB_pkg}"
    _BB_runpkg $_BB_CONFDIR$_BB_pkg
done
