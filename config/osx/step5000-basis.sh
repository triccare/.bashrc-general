# Basic OSX setup

# Personal development
export PERSONALDEVDIR=$HOME/Documents/projects

# Unsetting things I don't want
unset DYLD_LIBRARY_PATH

# Catchall paths
export PATH=/usr/local/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:$PATH
export PATH=~/QtSDK/Desktop/Qt/474/gcc/bin:$PATH
export PATH=~/bin:~/varnish/bin:~/varnish/sbin:$PATH

export MANPATH=/opt/local/share/man:$MANPATH

# Web development
export ARCHFLAGS='-arch x86_64'
export CFLAGS='-arch x86_64'
