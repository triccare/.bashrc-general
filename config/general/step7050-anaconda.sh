# Setup the conda environment

# Utitlity functions for anaconda.

function conda_pip_update() {
    python -m conda_pip_update $1
}

function conda_envs() {
    conda info --envs
}; export -f conda_envs

function conda_list() {

    local format name resline result

    format=
    if [ -z $1 ]; then
        format='format'
    fi

    result=()
    for path in `conda info --json | jq ".envs[]"`; do
        name=${path//\"/}
        name=(${name//\// })
        name=${name[${#name[@]} -1]}
        result+=($name)
    done

    if [ -z $format ]; then
        echo ${result[@]}
    else
        resline=${result[@]}
        echo -e ${resline// /\\n}
    fi

}; export -f conda_list

function conda_switch() {
    local alphabet conflist index mode modeIndex item
    alphabet=({a..z})
    conflist=()

    for item in `conda_list noformat`; do
        conflist+=("${item}")
    done

    for ((index=0; index<${#conflist[@]}; index++)); do
        echo -e "[${alphabet[$index]}] ${conflist[$index]}"
    done

    read -n 1 -p 'Which environment? ' mode
    echo

    modeIndex=$(elementIndex $mode alphabet)
    if [ "$modeIndex" -gt "$index" ]; then
        echo "No change in environment"
    else
        conda_activate ${conflist[$modeIndex]}
    fi

}; export -f conda_switch

function conda_remove() {
    local alphabet confirm conflist index mode modeIndex item
    alphabet=({a..z})
    conflist=()

    for item in `conda_list noformat`; do
        conflist+=("${item}")
    done

    for ((index=0; index<${#conflist[@]}; index++)); do
        echo -e "[${alphabet[$index]}] ${conflist[$index]}"
    done

    read -n 1 -p 'Remove environment: ' mode
    echo

    modeIndex=$(elementIndex $mode alphabet)
    if [ "$modeIndex" -gt "$index" ]; then
        echo "No change in environment"
    else
        conda remove --name ${conflist[$modeIndex]} --all
    fi
}; export -f conda_remove

function conda_activate() {
    local newenv=${1:?Environment not specified}
    conda_deactivate
    conda activate ${newenv}
}; export -f conda_activate

function conda_deactivate() {
    conda deactivate
}; export conda_deactivate

function conda_new() {
    local newenv=${1:?"Usage: conda_new <name> <conda package or \"\"> <optional python version>"}
    local install_pkg=$2
    local pversion=${3:-"3"}

    # Clean up caches. Caches very occasionally cause out-of-date
    # issues, but just do it because OCD
    conda clean --all -y
    pip cache purge --no-input

    # Setup the new environment
    conda update -n base -c defaults conda
    conda create --name $newenv python=$pversion $install_pkg
    conda_activate $newenv

    read -n 1 -p 'Continue with pip setup [y/n]? ' dopipsetup
    echo
    if [ "$dopipsetup" = "y" ]; then
        pipsetup
    fi
}

function conda_start_iterms() {
    local project=${1:?"Usage: conda_start_iterms <project>"}
    local alphabet conflist index mode modeIndex item

    alphabet=({a..z})
    conflist=()

    for item in `conda_list noformat`; do
        conflist+=("${item}")
    done

    for ((index=0; index<${#conflist[@]}; index++)); do
        echo -e "[${alphabet[$index]}] ${conflist[$index]}"
    done

    read -n 1 -p 'Which environment? ' mode
    echo

    modeIndex=$(elementIndex $mode alphabet)
    if [ "$modeIndex" -gt "$index" ]; then
        echo "No environment specified, aborting"
    else
        make_project_iterms ${conflist[$modeIndex]} ${project}
    fi

}; export -f conda_start_iterms
