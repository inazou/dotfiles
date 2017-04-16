" 保存時に:w!!でsudo権限で無理やり保存
cnoremap w!! w !sudo tee > /dev/null %<CR> :e!<CR>

"-----------------------------------------------
" 表示設定
"-----------------------------------------------
set number "行番号を表示する
set laststatus=2 "ステータスラインを表示
set statusline=%<%F%m%r%h%w\ %y[%{&fenc}][%{&ff}]%=%c/%{col('$')-1},%l/%L%11p%% "ステータスラインの表示設定
set title "編集中のファイル名を表示
set showmatch "括弧入力時の対応する括弧を表示
syntax on "コードの色分け
set completeopt=menuone "vim補完でScratchを表示しない
set t_Co=256 "256色使えるようにする

"---------------------------
"文字コードの設定
"---------------------------
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,sjis,iso-2022-jp,euc-jp
set fileformats=unix,dos,mac
"---------------------------

"---------------------------
" 挿入モード時、ステータスラインの色を変更
"---------------------------
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction
"---------------------------
"-----------------------------------------------

"-----------------------------------------------
" 入力とインデントの設定(vimにはFileTypeというオプションがあり、それごとに設定が分けられる)
"-----------------------------------------------
set smartindent "オートインデント 'gg=G'で一括でインデントを直せる(.vim/indentに個別に設定出来る)
set expandtab "タブをスペースとして展開
set tabstop=2 "<TAB>を含むファイルを開いた際、<TAB>を何文字の空白に変換するかを設定。
set shiftwidth=2 "vimが自動でインデントを行った際、設定する空白数。
set softtabstop=2 "キーボードで<TAB>を入力した際、<TAB>を何文字の空白に変換するかを設定。
set list "タブや改行を可視化
set listchars=tab:>_,trail:_,eol:↲,extends:>,precedes:< "可視化されたタブや改行の表示形式
set backspace=indent,eol,start " 何故かバックスペースが効かなくなるのでこれで解消
"---------------------------
" ペースト時にインデントしてずれないようにする
"---------------------------
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"
  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction
  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
"---------------------------
"-----------------------------------------------

"-----------------------------------------------
" 検索の設定
"-----------------------------------------------
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
set hlsearch "検索結果文字列のハイライトを有効にする
"-----------------------------------------------

"-----------------------------------------------
" バックアップの設定
"-----------------------------------------------
set backup "バックアップをとる
set backupdir=~/.vim/backup "バックアップファイルを作るディレクトリ
set directory=~/.vim/swap "スワップファイルを作るディレクトリ
set undofile "undoの履歴をとる
set undodir=~/.vim/undo "undoファイルを作るディレクトリ
"-----------------------------------------------

"-----------------------------------------------
" タブの設定
"-----------------------------------------------
" シフト + 右カーソルで次のタブ
nnoremap <S-Right> gt
" シフト + 左カーソルで前のタブ
nnoremap <S-Left> gT
"-----------------------------------------------


"-----------------------------------------------
" Start Neobundle Settings.
"-----------------------------------------------
set nocompatible
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" ~/neobundle.log にログを出力する
let g:neobundle#log_filename = $HOME . "/.vim/bundle/neobundle.log"

" ここに入れたいプラグインを記入
"---------------------------
" Fugaku vimのカラースキーム
"---------------------------
NeoBundle 'tasuten/Fugaku'
"---------------------------

"---------------------------
" syntastic ファイル保存時に構文チェック
"---------------------------
NeoBundle 'scrooloose/syntastic'
" perlのチェックを有効化
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ['perl', 'podchecker']
"---------------------------

"---------------------------
" vimproc 非同期でいろいろ実行できるようにする
"---------------------------
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'gmake -f make_unix.mak',
      \    },
      \ }
"---------------------------

"---------------------------
" neocomplcache コード補完してくれる
"---------------------------
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet' " スニペット補完を可能にする
NeoBundle 'Shougo/neosnippet-snippets' " スニペットのセット
" AutoComplPopが入っていたら無効化する
let g:acp_enableAtStartup = 0
" neocompleteを自動起動
let g:neocomplete#enable_at_startup = 1
" 大文字が入力されるまで大文字と小文字の区別をしない.
let g:neocomplete#enable_smart_case = 1
" シンタックスをキャッシュするときの最小文字長を3にする.
let g:neocomplete#sources#syntax#min_keyword_length = 3
" 自動的にロックするバッファ名のパターン
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" 別途辞書ファイルがあるときは指定すると読み込む 基本的に.vim/dictionaryに入れる
let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'php' : $HOME.'/.vim/dictionary/php.dict',
      \ 'perl': $HOME.'/.vim/dictionary/perl.dict'
      \ }
" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" タグ補完の呼び出しパターン
let g:neocomplete#sources#omni#input_patterns = {
      \   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
      \   "perl" : '\h\w*->\h\w*\|\h\w*::',
      \   "php"  : '->\|::'
      \}
if !exists('g:neocomplete#sources#member#prefix_patterns')
  let g:neocomplete#sources#member#prefix_patterns = {}
endif
let g:neocomplete#sources#member#prefix_patterns['php'] = '->\|::'

" 十字キーでの変換動作----------------------------------------------
" 左は変換を表示しない
inoremap <expr><Left>  neocomplete#cancel_popup() . "\<Left>"
" 右は変換中なら決定する 変換中でないなら変換を表示しない
inoremap <expr><Right> pumvisible() ? neocomplete#close_popup() : neocomplete#cancel_popup() . "\<Right>"
" 上は変換中なら候補を上に移動 変換中でないなら表示しない
inoremap <expr><Up>    pumvisible() ? "\<Up>" : neocomplete#cancel_popup() . "\<Up>"
" 下は変換中なら候補を下に移動 変換中でないなら表示しない
inoremap <expr><Down>  pumvisible() ? "\<Down>" : neocomplete#cancel_popup() . "\<Down>"

" バックスペースは閉じて１文字消す
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" tabキーは候補の決定とsnippetの展開
imap <expr><TAB> pumvisible() ? neocomplete#close_popup() : neosnippet#expandable() <Bar><bar> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() <Bar><bar> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" 保管候補のポップアップの色設定
hi Pmenu ctermbg=4
hi PmenuSel ctermbg=1
hi PMenuSbar ctermbg=4
"---------------------------

"---------------------------
" vim-monster ruby補完 gem install rcodetoolsが必要
"---------------------------
NeoBundle "osyo-manga/vim-monster"
"---------------------------

"---------------------------
" perlomni perl補完
"---------------------------
NeoBundle "c9s/perlomni.vim"
"---------------------------

"---------------------------
" vim-perl perlのsyntaxの色
"---------------------------
NeoBundle "vim-perl/vim-perl"
"---------------------------

"---------------------------
" soramugi/auto-ctags
" ctags(コードジャンプ出来るようにするやつ)を自動保存してくれる
"---------------------------
NeoBundle 'soramugi/auto-ctags.vim'
let g:auto_ctags = 1 " ファイル保存時にtagsファイルを生成
let g:auto_ctags_directory_list = ['.git'] "指定したディレクトリに保存する
let g:auto_ctags_tags_args = '--tag-relative --recurse --sort=yes' " ctags実行時のオプション
let g:auto_ctags_filetype_mode = 1 " 開いているファイルタイプ専用のtagsを作成
nnoremap <C-j> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>

"---------------------------
" lexima カッコやクォートなどの自動閉じ
"---------------------------
NeoBundle 'cohama/lexima.vim'
"---------------------------

"---------------------------
" NERDTeee ファイルをtree表示してくれる
"---------------------------
NeoBundle 'scrooloose/nerdtree'
"  Ctrl+e or F2 で開く
nnoremap <silent><C-e> :NERDTreeToggle<CR>
nnoremap <f2> :NERDTreeToggle<CR>

" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1

" 引数なしでvimを起動した場合ツリーを開く
" 引数なしで実行したとき、NERDTreeを実行する
let file_name = expand("%:p")
if has('vim_starting') &&  file_name == ""
  autocmd VimEnter * execute 'NERDTreeToggle'
endif
"---------------------------

"---------------------------
" nerdtree-git-plugin NERDTeeeでgitの状態を表示
"---------------------------
NeoBundle 'Xuyuanp/nerdtree-git-plugin'
"---------------------------

"---------------------------
" vim-javacomplete2 javaの補完拡張
"---------------------------
NeoBundle 'artur-shaik/vim-javacomplete2'
autocmd FileType java setlocal omnifunc=javacomplete#Complete
" 保存時にimportされていないものをimportする
autocmd BufWritePre *.java :JCimportsAddMissing
" 保存時に使っていないimportを削除する
autocmd BufWritePre *.java :JCimportsRemoveUnused
"---------------------------

"---------------------------
" indentLine インデントの可視化
"---------------------------
NeoBundle 'Yggdroot/indentLine'
let g:indentLine_color_term = 238 "cuiの色
let g:indentLine_char = '┆' "use ¦, ┆ or │
"---------------------------

"---------------------------
" vim-gitgutter gitの差分を表示
"---------------------------
NeoBundle 'airblade/vim-gitgutter'
"---------------------------

"---------------------------
" Gundo undoの履歴をツリーで表示
"---------------------------
NeoBundle 'sjl/gundo.vim'
" Uで表示
nnoremap U :GundoToggle<CR>
" returnしたら自動で閉じる
let g:gundo_close_on_revert = 1
"---------------------------

"---------------------------
" sudo.vim 自分の.vimrcでsudo viできる
"---------------------------
NeoBundle 'vim-scripts/sudo.vim'
"---------------------------

call neobundle#end()
"---------------------------------------------
" End Neobundle Settings.
"---------------------------------------------
colorscheme Fugaku " カラースキームの設定 call neobundle#end()したあとでないとエラーになる
filetype plugin indent on " .vim/filetype.vimにファイルタイプを書いておくと.vim/ftpluginの設定が読み込める
