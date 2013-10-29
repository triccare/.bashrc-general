################
# Appearance
################

# Prompt
export PS1='\h:\W$ '

################
# Aliases
################

# interactive file manipulation aliases
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

#  directory listing aliases
alias l="ls -FG"

alias ll="ls -laG"
alias la="ls -aFG"

################
# Environmental
################

# Editor
export EDITOR='gui-emacs'

#################
# Setup commands
#################

# Folders
function back() { cd -; }; export -f back
function pu() { pushd "$@"; }; export -f pu
function po() { popd; }; export -f po
