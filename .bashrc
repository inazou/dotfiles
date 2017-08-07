# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi
# dotfilesにパスを通す
PATH=$PATH:$HOME/dotfiles/bin
export PATH

# git補完
source $HOME/.git-completion.bash

# gitの各種情報を表示(__git_ps1の設定)
source $HOME/.git-prompt.sh
# addされてない変更(unstaged)があったとき"*"を表示する、addされているがcommitされていない変更(staged)があったとき"+"を表示する
GIT_PS1_SHOWDIRTYSTATE=1
# 現在のブランチがupstreamより進んでいるとき">"を、遅れているとき"<"を、遅れてるけど独自の変更もあるとき"<>"を表示する。
GIT_PS1_SHOWUPSTREAM=1
# addされてない新規ファイルがある(untracked)とき"%"を表示する
GIT_PS1_SHOWUNTRACKEDFILES=1
# stashになにか入っている(stashed)とき"$"を表示する
GIT_PS1_SHOWSTASHSTATE=1




export PS1="[\u@\h \W]\$(type -t __git_ps1 >& /dev/null && __git_ps1)\[\033[00m\]\n\$"

# editor
export EDITOR=vim

# OS別のalias
if [ "$(uname)" = 'Darwin' ]; then
  # macのとき
  alias ll="ls -Gal"
else
  # その他
  alias ll="ls -al"
fi

alias g="git"
alias vi="vim"
alias vid="vi ./"
alias rm="rm -v -i"
alias cp="cp -v -i"
alias mv="mv -v -i"
alias sudo="sudo "
# cdしたらlsする
cdls ()
{
  \cd "$@" && ll
}
alias cd="cdls"

# anyenv
if [ -d $HOME/.anyenv ] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
  # tmux対応
  for D in `\ls $HOME/.anyenv/envs`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

# bash_completion
if [ -f /usr/local/etc/bash_completion ] ; then
  . /usr/local/etc/bash_completion
fi

# ログイン時にscreenfetchでロゴ表示
if type screenfetch >/dev/null 2>&1 && tput cols >/dev/null 2>&1; then
  WIDTH=`tput cols`
  if (( $WIDTH>80 )) ; then
    screenfetch -E
  else
    screenfetch -Ep
  fi
fi
