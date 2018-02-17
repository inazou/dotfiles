#.bash_profile
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# anyenv
if type anyenv > /dev/null 2>&1; then
  eval "$(anyenv init -)"
fi

PATH=$PATH:$HOME/bin
export PATH

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT=/Applications/Cocos/Cocos2d-x/cocos2d-x-3.10/tools/cocos2d-console/bin
export PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_X_ROOT for cocos2d-x
export COCOS_X_ROOT=/Applications/Cocos/Cocos2d-x
export PATH=$COCOS_X_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT=/Applications/Cocos/Cocos2d-x/cocos2d-x-3.10/templates
export PATH=$COCOS_TEMPLATES_ROOT:$PATH

if [ -e $HOME/perl5/perlbrew/etc/bashrc ]; then
  source $HOME/perl5/perlbrew/etc/bashrc
  perlbrew use 5.16.3
fi

export PATH=$HOME/.rbenv/bin:$PATH
if type rbenv > /dev/null 2>&1; then
 eval "$(rbenv init -)"
fi
export PATH=$HOME/.ndenv/bin:$PATH
if type ndenv > /dev/null 2>&1; then
  eval "$(ndenv init -)"
fi

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
