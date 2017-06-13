#!/bin/bash

DOT_DIR=`pwd`

echo $'\e[36m       __      __  _____ __         \e[m'
echo $'\e[36m  ____/ /___  / /_/ __(_) /__  _____\e[m'
echo $'\e[36m / __  / __ \/ __/ /_/ / / _ \/ ___/\e[m'
echo $'\e[36m/ /_/ / /_/ / /_/ __/ / /  __(__  ) \e[m'
echo $'\e[36m\__,_/\____/\__/_/ /_/_/\___/____/  \e[m'

echo
echo 'copying dotfiles...'
echo

for f in .??*
do
  [[ "$f" == ".git" ]] && continue
  [[ "$f" == ".DS_Store" ]] && continue
  [[ "$f" == ".gitignore" ]] && continue

  echo "$f"
  ln -sfn ${DOT_DIR}/${f} $HOME/${f}
done

echo
echo 'copying dotfiles is finished'
echo
