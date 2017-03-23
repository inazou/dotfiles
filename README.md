# dotfiles

**dotfiles使用法**  
```bash
$ git clone https://github.com/inazou/dotfiles.git
$ cd dotfiles
$ make
```
**NeoBundle**  
```bash
$ git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
```
vimを起動して以下を実行する
```bash
:NeoBundleInstall
```
githubのログインを求められる  
  
**ruby補完を使う時**
```bash
$ gem install rcodetools
$ gem install fastri
```
**ctagsを使う時**
```bash
$ brew install ctags
```
**neocompleteが動かない時**
```bash
$ brew install lua
$ brew reinstall vim --with-lua
```

