# SVN helpers

# Update modified and removed files in tree.
function svnsnapshot() {

    if [ $# != 1 ]
    then
        echo  "usage: svnsnapshot DIR"
        return 0
    fi

    ROOT=$1

    for i in `find ${ROOT} -type d \! -path "*.svn*" `
    do

        echo
        echo "--------------------------"
        ( cd $i ; 
        echo $i
        echo "--------------------------"
            

        svn status | awk '  
                          /^[!]/ { system("svn rm " $2) }
                          /^[?]/ { system("svn add " $2) }
                         '
        )
        echo
        
    done

}; export -f svnsnapshot
