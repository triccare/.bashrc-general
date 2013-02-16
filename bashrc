# These are JDE's personal bash setup
#####################################################

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

# Freeplane beta
alias fp-beta="screen -d -m -S freeplanebeta ~/bin/freeplane-1.2.11/freeplane.sh"


################
# Environmental
################

# Prompt
if [ $?PS1 ]; then
   export PS1='\h:\W$ '
fi

# Catchall paths
export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH
export PATH=~/QtSDK/Desktop/Qt/474/gcc/bin:$PATH
export PATH=~/bin:~/varnish/bin:~/varnish/sbin:$PATH

export MANPATH=/opt/local/share/man:$MANPATH

# Editor
export EDITOR='gui-emacs'

# Web development
export ARCHFLAGS='-arch x86_64'
export CFLAGS='-arch x86_64'
#export HUBBLESITE_DEVELOPMENT=yes

#################
# Setup commands
#################

# Folders
function back() { cd -; }; export -f back
function pu() { pushd "$@"; }; export -f pu
function po() { popd; }; export -f po
function cddev() { pushd $HOME/cs-user-eisenham/webdev; }; export -f cddev

# Newscenter App dev
function psstart() { pg_ctl start; }; export -f psstart
function cdnews() { pushd $HOME/cs-user-eisenham/webdev/hsite/newscenter; }; export -f cdnews
function newsapi() { 
  screen -S newsapi $HOME/bin/newsapi
}; export -f newsapi
function newsfront () {
  screen -S newsfront $HOME/bin/newsfront
}; export -f newsfront

# Mongo
function startmongo () {
  screen -d -m -S mongod mongod
}

#### Packages

# PostGreSQL
export PGDATA=~/Documents/postgresql-db/defaultdb-ps92

# Ruby
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
