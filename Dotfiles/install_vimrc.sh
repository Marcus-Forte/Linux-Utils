#!/bin/bash

if [ ! -f $HOME/.vimrc ] ; then
		echo ".vimrc not found. Copying .vimrc from repository."
else
		echo "found .vimrc .. backing up and copying .vimrc from repository."
		mv $HOME/.vimrc $HOME/.vimrc.bkp
fi

cp $PWD/vimrc $HOME/.vimrc

echo "success!"
exit 0
