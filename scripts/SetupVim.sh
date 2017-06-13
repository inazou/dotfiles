#!/bin/bash

DOT_DIR=`pwd`

echo 'checking vim...'
echo

which vim >/dev/null 2>&1
if [ $? -ne 0 ];
then
  echo 'vim is not installed'
  echo 'Please install vim'
  exit 1
fi

vim --version | grep '\+lua' >/dev/null 2>&1
if [ $? -ne 0 ];
then
  echo 'Your vim is not lua enabled'
  echo 'Please reinstall lua enabled vim'
  exit 1
fi

echo 'checking vim is finished'

which git >/dev/null 2>&1
if [ $? -ne 0 ];
then
  echo 'git is not installed'
  echo 'Please install git'
  exit 1
fi

if [ -d ${DOT_DIR}/.vim/bundle/neobundle.vim ];
then
  echo 'NeoBundle is installed'
else
  git clone git://github.com/Shougo/neobundle.vim ${DOT_DIR}/.vim/bundle/neobundle.vim
  vim -u ${DOT_DIR}/.vimrc -i NONE -c "try | NeoBundleInstall! | finally | q! | endtry" -e -s -V1
fi

echo 'Update NeoBundle'
vim -u ${DOT_DIR}/.vimrc -i NONE -c "try | NeoBundleUpdate! | finally | q! | endtry" -e -s -V1
echo
