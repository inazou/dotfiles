"---------------------------
" 表示設定
"---------------------------
set number "行番号を表示する
set laststatus=2 "ステータスラインを表示
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

"---------------------------
" インデントの設定(vimにはFileTypeというオプションがあり、それごとに設定が分けられる)
"---------------------------
set smartindent "オートインデント 'gg=G'で一括でインデントを直せる(.vim/indentに個別に設定出来る)
set expandtab "タブをスペースとして展開
set tabstop=2 "<TAB>を含むファイルを開いた際、<TAB>を何文字の空白に変換するかを設定。
set shiftwidth=2 "vimが自動でインデントを行った際、設定する空白数。
set softtabstop=2 "キーボードで<TAB>を入力した際、<TAB>を何文字の空白に変換するかを設定。
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
inoremap (<Enter> ()<Left><CR><ESC><S-o>
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
"ここに入れたいプラグインを記入

"---------------------------
" neocomplcache コード補完してくれる
"---------------------------
NeoBundle 'Shougo/neocomplcache'

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" 別途辞書ファイルがあるときは指定すると読み込む 基本的に.vim/dictionaryに入れる
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'php' : $HOME.'/.vim/dictionary/php.dict',
      \ 'ruby' : $HOME.'/.vim/dictionary/ruby.dict'
      \ }

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" 十字キーで変換しない
inoremap <expr><Left>  neocomplcache#cancel_popup() . "\<Left>"
inoremap <expr><Right> neocomplcache#cancel_popup() . "\<Right>"
inoremap <expr><Up>    pumvisible() ? "\<C-n>"    : neocomplcache#cancel_popup() . "\<Up>"
inoremap <expr><Down>  pumvisible() ? "\<C-n>"  : neocomplcache#cancel_popup() . "\<Down>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" 保管候補のポップアップの色設定
hi Pmenu ctermbg=4
hi PmenuSel ctermbg=1
hi PMenuSbar ctermbg=4
"---------------------------

"---------------------------
" vim-endwise Ruby向けにendを自動挿入してくれる
" --------------------------
NeoBundle 'tpope/vim-endwise'
" --------------------------

"---------------------------
" NERDTeee ファイルをtree表示してくれる
" --------------------------
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
