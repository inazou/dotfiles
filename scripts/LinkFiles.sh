#!/bin/bash

DOT_DIR=`pwd`

for f in .??*
do
  [[ "$f" == ".git" ]] && continue
  [[ "$f" == ".DS_Store" ]] && continue
  [[ "$f" == ".gitignore" ]] && continue

  echo "$f"
  ln -sfn ${DOT_DIR}/${f} $HOME/${f}
done
