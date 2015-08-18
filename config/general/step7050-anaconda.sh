# Utitlity functions for anaconda.

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
    source activate ${newenv}
}; export -f conda_activate

function conda_deactivate() {
    source deactivate
}; export conda_deactivate

function conda_new() {
    local newenv=${1:?Environment not specified}
    conda create --name $newenv --clone root
}
