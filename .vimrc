" 保存時に:w!!でsudo権限で無理やり保存
cnoremap w!! w !sudo tee > /dev/null %<CR> :e!<CR>
" よく入力ミスするのでエイリアス
nmap :W :w
nmap :Q :q

"-----------------------------------------------
" 表示設定
"-----------------------------------------------
set number "行番号を表示する
set laststatus=2 "ステータスラインを表示
set statusline=%<%F%m%r%h%w\ %y[%{&fenc}][%{&ff}]%=%c/%{col('$')-1},%l/%L%11p%% "ステータスラインの表示設定
set title "編集中のファイル名を表示
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

"---------------------------
" 外部で変更のあったファイルを自動的に読み直す
"---------------------------
set autoread
augroup vimrc-checktime
  autocmd!
  autocmd WinEnter * checktime
augroup END
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
set mouse=a
set ttymouse=xterm2
"---------------------------
" ペースト時にインデントしてずれないようにする
"---------------------------
if has("patch-8.0.0238")
    " Bracketed Paste Mode対応バージョン(8.0.0238以降)では、特に設定しない
    " 場合はTERMがxtermの時のみBracketed Paste Modeが使われる。
    " tmux利用時はTERMがscreenなので、Bracketed Paste Modeを利用するには
    " 以下の設定が必要となる。
    if &term =~ "screen"
        let &t_BE = "\e[?2004h"
        let &t_BD = "\e[?2004l"
        exec "set t_PS=\e[200~"
        exec "set t_PE=\e[201~"
    endif
else
    " 8.0.0210 ～ 8.0.0237 ではVim本体でのBracketed Paste Mode対応の挙動が
    " 望ましくない(自動インデントが無効にならない)ので、Vim本体側での対応を
    " 無効にする。
    if has("patch-8.0.0210")
        set t_BE=
    endif

    " Vim本体がBracketed Paste Modeに対応していない時の為の設定。
    if &term =~ "xterm" || &term =~ "screen"
        let &t_ti .= "\e[?2004h"
        let &t_te .= "\e[?2004l"

        function XTermPasteBegin(ret)
            set pastetoggle=<Esc>[201~
            set paste
            return a:ret
        endfunction

        noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
        inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
        vnoremap <special> <expr> <Esc>[200~ XTermPasteBegin("c")
        cnoremap <special> <Esc>[200~ <nop>
        cnoremap <special> <Esc>[201~ <nop>
    endif
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
" カーソルの設定
"-----------------------------------------------
" 折り返していても見た目通りに下に移動する
nnoremap <Down> gj
" り返していても見た目通りに上に移動する
nnoremap <Up> gk
set virtualedit=block " 文字のないところにカーソル移動
" tmuxだとキー入力がおかしくなるので対応
if &term =~ '^screen' && exists('$TMUX')
    " tmux will send xterm-style keys when xterm-keys is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
    execute "set <xHome>=\e[1;*H"
    execute "set <xEnd>=\e[1;*F"
    execute "set <Insert>=\e[2;*~"
    execute "set <Delete>=\e[3;*~"
    execute "set <PageUp>=\e[5;*~"
    execute "set <PageDown>=\e[6;*~"
    execute "set <xF1>=\e[1;*P"
    execute "set <xF2>=\e[1;*Q"
    execute "set <xF3>=\e[1;*R"
    execute "set <xF4>=\e[1;*S"
    execute "set <F5>=\e[15;*~"
    execute "set <F6>=\e[17;*~"
    execute "set <F7>=\e[18;*~"
    execute "set <F8>=\e[19;*~"
    execute "set <F9>=\e[20;*~"
    execute "set <F10>=\e[21;*~"
    execute "set <F11>=\e[23;*~"
    execute "set <F12>=\e[24;*~"
endif
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
let g:syntastic_perl_checkers = ['srsys_perl', 'perl', 'podchecker']
let g:syntastic_perl_lib_path = ['lib/', 'local/lib/perl5/']
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
" SQLComplete.vim sql補完
"---------------------------
NeoBundle "vim-scripts/SQLComplete.vim"
NeoBundle "vim-scripts/dbext.vim"
"---------------------------

"---------------------------
" vim-perl perlのsyntaxの色
"---------------------------
NeoBundle "vim-perl/vim-perl"
"---------------------------

"---------------------------
" vim-javascript-syntax perlのsyntaxの色とインデント(htmlの<script>にも対応)
"---------------------------
NeoBundle 'jelera/vim-javascript-syntax'
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
" closetag htmlやxmlタグの自動閉じ
"---------------------------
NeoBundle 'alvan/vim-closetag'
let g:closetag_filenames = "*.html,*.xml,*.tx,*.tpl,*.tt" " 適応する拡張子
"---------------------------

"---------------------------
" vim-parenmatch 対応するカッコのハイライト
"---------------------------
NeoBundle 'itchyny/vim-parenmatch'
let g:loaded_matchparen = 1
"---------------------------

"---------------------------
" vim-parenmatch 対応するタグのハイライト
"---------------------------
NeoBundle 'valloric/matchtagalways'
let g:mta_use_matchparen_group = 1 " オプション機能をONにする
" 使用するファイルタイプ
let g:mta_filetypes = {
      \ 'html' : 1,
      \ 'xhtml' : 1,
      \ 'xml' : 1,
      \ 'jinja' : 1,
      \ 'php' : 1,
      \ 'tt2html' : 1,
      \ 'smarty' : 1,
      \}
"---------------------------

"---------------------------
" NERDTeee ファイルをtree表示してくれる
"---------------------------
NeoBundle 'scrooloose/nerdtree'
" タブを開いたときもnerdtreeを常に出してくれる
NeoBundle 'jistr/vim-nerdtree-tabs'
"  Ctrl+e or F2 で開く
nnoremap <silent><C-e> :NERDTreeTabsToggle<CR>
nnoremap <f2> :NERDTreeTabsToggle<CR>

" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1

" 引数がディレクトリだった時は自動起動
let g:nerdtree_tabs_open_on_console_startup=2

" 他のバッファをすべて閉じた時にNERDTreeが開いていたらNERDTreeも一緒に閉じる
let g:nerdtree_tabs_autoclose=1
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
