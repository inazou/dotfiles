# dotfiles

**dotfiles使用法**  
```bash
$ git clone https://github.com/inazou/dotfiles.git
$ cd dotfiles
$ init.sh
```
**NeoBundle**  
```bash
$ mkdir -p ~/.vim/bundle
$ git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
```
vimを起動して以下を実行する。
```bash
:NeoBundleInstall
```
**rsenceを使う時**
```bash
$ ruby ~/.vim/bundle/rsense/etc/config.rb > ~/.rsense
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

