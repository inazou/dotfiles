#!/bin/bash

DOT_DIR=`pwd`

output=(
"       __      __  _____ __         "
"  ____/ /___  / /_/ __(_) /__  _____"
" / __  / __ \/ __/ /_/ / / _ \/ ___/"
"/ /_/ / /_/ / /_/ __/ / /  __(__  ) "
"\__,_/\____/\__/_/ /_/_/\___/____/  "
)

for f in .??*
do
  [[ "$f" == ".git" ]] && continue
  [[ "$f" == ".DS_Store" ]] && continue
  [[ "$f" == ".gitignore" ]] && continue

  echo "$f"
  ln -sfn ${DOT_DIR}/${f} $HOME/${f}
done
