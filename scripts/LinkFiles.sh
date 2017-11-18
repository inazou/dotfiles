#!/bin/bash

DOT_DIR=`pwd`
BACKUP_DIR="${DOT_DIR}/backup/"

echo 'copying dotfiles...'
echo

for f in .??*
do
  [[ "$f" == ".git" ]] && continue
  [[ "$f" == ".DS_Store" ]] && continue
  [[ "$f" == ".gitignore" ]] && continue

  echo "$f"
  dotfile="$HOME/${f}"
  if [ -e ${dotfile} ] && [ ! -L ${dotfile} ]; then
    echo "${dotfile} is already exists. Move ${dotfile} to ${BACKUP_DIR}"
    mv -v ${dotfile} ${BACKUP_DIR}
  fi

  ln -sfn ${DOT_DIR}/${f} ${dotfile}
done

echo
echo 'copying dotfiles is finished'
echo
