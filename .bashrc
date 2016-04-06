# .bashrc

# git settings
source $HOME/.git-prompt.sh
source $HOME/.git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true


export PS1="[\u@\h \W]\$(__git_ps1)\[\033[00m\]\n\$"

alias ll="ls -Gla"
alias g="git"

# cdしたらlsする
cdls ()
{
   \cd "$@" && ll
}
alias cd="cdls"
