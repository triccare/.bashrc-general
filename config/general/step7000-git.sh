# git configs
function git_author() {

    if `git rev-parse`; then
        echo "Current author is `git config user.name` <`git config user.email`>"

        local authors
        declare -a authors
        authors[0]="J.D.Eisenhamer:eisenhamer@stsci.edu"
        authors[1]="triccare:triccare@gmail.com"

        local alphabet author authorIndex index
        alphabet=({a..z})
        
        for ((index=0; index<${#authors[@]}; index++)); do
            echo -e "[${alphabet[$index]}] ${authors[$index]}"
        done

        read -n 1 -p 'git author? ' author
        echo

        authorIndex=$(elementIndex $author alphabet)
        if [ "$authorIndex" -ge "$index" ]; then
            echo "Invalid author! You are not an author!"
        else
            author=(${authors[authorIndex]//:/ })
            git config user.name "${author[0]}" && \
                git config user.email "${author[1]}" && \
                echo "git repo author is `git config user.name` <`git config user.email`>"
        fi
    fi
}; export -f git_author
