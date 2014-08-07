.bashrc-general
===============

This is to make a generic setup for bash environment.

For details on how to do the setup, see boot.sh

Once setup, modify ~/.bash_profile and ~/.bashrc to contain the following:
```
if [ -e ${HOME}/.bashrc-general/boot.sh ]; then
   . ${HOME}/.bashrc-general/boot.sh
fi
```

If one also wants to add to .profile, include a way of checking that 
the shell which invoked the .profile is actually bash. One method
of doing so is
```
_BOOTSHELL=`ps -hp $$|awk '{print $NF}' | awk -F '/' '{print $NF}'`

if [ ${_BOOTSHELL} == "bash" -a -e ${HOME}/.bashrc-general/boot.sh ]; then
   . ${HOME}/.bashrc-general/boot.sh
fi
```