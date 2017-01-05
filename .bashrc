# .bashrc

# git settings
source $HOME/.git-prompt.sh
source $HOME/.git-completion.bash

# gitの各種情報を表示

# addされてない変更(unstaged)があったとき"*"を表示する、addされているがcommitされていない変更(staged)があったとき"+"を表示する
GIT_PS1_SHOWDIRTYSTATE=1
# 現在のブランチがupstreamより進んでいるとき">"を、遅れているとき"<"を、遅れてるけど独自の変更もあるとき"<>"を表示する。
GIT_PS1_SHOWUPSTREAM=1
# addされてない新規ファイルがある(untracked)とき"%"を表示する
GIT_PS1_SHOWUNTRACKEDFILES=1
# stashになにか入っている(stashed)とき"$"を表示する
GIT_PS1_SHOWSTASHSTATE=1



export PS1="[\u@\h \W]\$(__git_ps1)\[\033[00m\]\n\$"

alias ll="ls -Gla"
alias g="git"
alias vi="vim"
alias rm="rm -v -i"
alias cp="cp -v -i"
alias mv="mv -v -i"

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

# ログイン時にscreenfetchでロゴ表示
if [ -e $HOME/dotfiles/screenfetch ] ; then
  $HOME/dotfiles/screenfetch -E
fi
