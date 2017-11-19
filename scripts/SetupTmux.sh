#!/bin/bash

DOT_DIR=`pwd`

echo 'checking tmux...'
echo

which tmux >/dev/null 2>&1
if [ $? -ne 0 ];
then
  echo 'tmux is not installed'
  echo 'Please install tmux'
  exit 1
fi

echo 'checking tmux is finished'

which git >/dev/null 2>&1
if [ $? -ne 0 ];
then
  echo 'git is not installed'
  echo 'Please install git'
  exit 1
fi

if [ -d ${DOT_DIR}/.tmux/plugins/tpm ];
then
  echo 'tpm is installed'
else
  git clone git://github.com/tmux-plugins/tpm ${DOT_DIR}/.tmux/plugins/tpm
fi
