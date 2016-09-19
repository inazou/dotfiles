" 保存時にsudo権限で無理やり保存
cnoremap w!! w !sudo tee > /dev/null %<CR> :e!<CR>

"---------------------------
" 表示設定
"---------------------------
set number "行番号を表示する
set laststatus=2 "ステータスラインを表示
set statusline=%<%F%m%r%h%w\ %y[%{&fenc}][%{&ff}]%=%c/%{col('$')-1},%l/%L%11p%% "ステータスラインの表示設定
set title "編集中のファイル名を表示
set showmatch "括弧入力時の対応する括弧を表示
syntax on "コードの色分け

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

"---------------------------




"---------------------------
" 入力の設定
"---------------------------
set backspace=indent,eol,start " 何故かバックスペースが効かなくなるのでこれで解消

"---------------------------
" インデントの設定(vimにはFileTypeというオプションがあり、それごとに設定が分けられる)
"---------------------------
set smartindent "オートインデント 'gg=G'で一括でインデントを直せる(.vim/indentに個別に設定出来る)
set expandtab "タブをスペースとして展開
set tabstop=2 "<TAB>を含むファイルを開いた際、<TAB>を何文字の空白に変換するかを設定。
set shiftwidth=2 "vimが自動でインデントを行った際、設定する空白数。
set softtabstop=2 "キーボードで<TAB>を入力した際、<TAB>を何文字の空白に変換するかを設定。
set list "タブや改行を可視化
set listchars=tab:>_,trail:_,eol:↲,extends:>,precedes:< "可視化されたタブや改行の表示形式
"---------------------------

"---------------------------
" クォーテーションを自動で閉じる
"---------------------------
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>
"---------------------------

"---------------------------
" カッコを自動で閉じる
"---------------------------
inoremap ( ()<ESC>i
inoremap { {}<ESC>i
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [ []<ESC>i
"---------------------------

"---------------------------


"---------------------------
" 検索の設定
"---------------------------
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
"---------------------------



"---------------------------
" Start Neobundle Settings.
"---------------------------
set nocompatible
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" ~/neobundle.log にログを出力する
let g:neobundle#log_filename = $HOME . "/neobundle.log"

" ここに入れたいプラグインを記入

"---------------------------
" syntastic ファイル保存時に構文チェック
"---------------------------
NeoBundle 'scrooloose/syntastic'
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
NeoBundle 'Shougo/neosnippet-snippets'
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" 別途辞書ファイルがあるときは指定すると読み込む 基本的に.vim/dictionaryに入れる
let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'php' : $HOME.'/.vim/dictionary/php.dict'
      \ }
" rsence(rubyの辞書を使う設定)
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
" タグ補完の呼び出しパターン
if !exists('g:neocomplete#sources#member#prefix_patterns')
  let g:neocomplete#sources#member#prefix_patterns = {}
endif
let g:neocomplete#sources#member#prefix_patterns['php'] = '->\|::'
let g:neocomplete#sources#member#prefix_patterns['ruby'] = '[^. *\t]\.\w*\|\h\w*::'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" 十字キーで変換しない
inoremap <expr><Left>  neocomplete#cancel_popup() . "\<Left>"
inoremap <expr><Right> pumvisible() ? neocomplete#close_popup() . "\<Right>"    : neocomplete#cancel_popup() . "\<Right>"
inoremap <expr><Up>    pumvisible() ? "\<Up>"    : neocomplete#cancel_popup() . "\<Up>"
inoremap <expr><Down>  pumvisible() ? "\<Down>"  : neocomplete#cancel_popup() . "\<Down>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
imap <expr><TAB> neosnippet#expandable() <Bar><bar> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() <Bar><bar> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

" 保管候補のポップアップの色設定
hi Pmenu ctermbg=4
hi PmenuSel ctermbg=1
hi PMenuSbar ctermbg=4
"---------------------------

"---------------------------
" rsence Ruby用の辞書 Lazyで遅延ロードしたほうがいいかも
" --------------------------
NeoBundle 'NigoroJr/rsense'
let g:rsenseUseOmniFunc = 1
" --------------------------

"---------------------------
" neocomplcache-rsense rsenceをneocomplcacheで使えるようにする
"---------------------------
NeoBundle 'supermomonga/neocomplete-rsense.vim', {
      \ 'depends': ['Shougo/neocomplete.vim', 'marcus/rsense'],
      \ }
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
" vim-endwise Ruby向けにendを自動挿入してくれる
"---------------------------
NeoBundle 'tpope/vim-endwise'
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

call neobundle#end()
"-------------------------
" End Neobundle Settings.
"-------------------------

filetype plugin indent on " .vim/filetype.vimにファイルタイプを書いておくと.vim/ftpluginの設定が読み込める
