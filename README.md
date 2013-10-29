.bashrc-general
===============

This is to make a generic setup for bash environment.

For details on how to do the setup, see boot.sh

Once setup, modify ~/.profile and ~/.bashrc to contain the following:
```
if [ -e ${HOME}/.bashrc-general/boot.sh ]; then
   . ${HOME}/.bashrc-general/boot.sh
fi
```
