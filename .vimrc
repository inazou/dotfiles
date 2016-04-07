"#####表示設定#####
set number "行番号を表示する
set title "編集中のファイル名を表示
set showmatch "括弧入力時の対応する括弧を表示
syntax on "コードの色分け
set tabstop=2 "インデントをスペース4つ分に設定
set smartindent "オートインデント
set shiftwidth=2 "タブを挿入するときの幅
set noexpandtab "タブをスペースとして展開させない

"####検索設定#####
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る

"-------------------------------
" NeoBundleが入っている確認する
"-------------------------------
let $VIMBUNDLE = '~/.vim/bundle'
let $NEOBUNDLEPATH = $VIMBUNDLE . '/neobundle.vim'
if stridx(&runtimepath, $NEOBUNDLEPATH) != -1

else
	" If the NeoBundle doesn't exist.
	command! NeoBundleInit try | call s:neobundle_init()
	            \| catch /^neobundleinit:/
	                \|   echohl ErrorMsg
	                \|   echomsg v:exception
	                \|   echohl None
	                \| endtry
	
	function! s:neobundle_init()
		redraw | echo "Installing neobundle.vim..."
		if !isdirectory($VIMBUNDLE) 
			call mkdir($VIMBUNDLE, 'p')
			echo printf("Creating '%s'.", $VIMBUNDLE)		
		endif
		cd $VIMBUNDLE

		if executable('git')
			call system('git clone git://github.com/Shougo/neobundle.vim')
			if v:shell_error
				throw 'neobundleinit: Git error.'
			endif
		endif

		set runtimepath& runtimepath+=$NEOBUNDLEPATH
		call neobundle#rc($VIMBUNDLE)
		try
			echo printf("Reloading '%s'", $MYVIMRC)
			source $MYVIMRC
		catch
			echohl ErrorMsg
			echomsg 'neobundleinit: $MYVIMRC: could not source.'
			echohl None
			return 0
		finally
			echomsg 'Installed neobundle.vim'
		endtry

		echomsg 'Finish!'
	endfunction

	autocmd! VimEnter * redraw
				\ | echohl WarningMsg
				\ | echo "You should do ':NeoBundleInit' at first!"
				\ | echohl None
endif
"-----------------------------



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

" neocomplcache
NeoBundle 'Shougo/neocomplcache'

let g:rsenseHome = '/usr/local/Cellar/rsense/0.3/libexec'
let g:rsenseUseOmniFunc = 1

if !exists('g:neocomplcache_omni_patterns')
	let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
	\ 'default' : ''
    \ }

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" 十字キーで変換しない
inoremap <expr><Left>  neocomplcache#cancel_popup() . "\<Left>"
inoremap <expr><Right> neocomplcache#cancel_popup() . "\<Right>"
inoremap <expr><Up>    pumvisible() ? "\<C-n>"    : neocomplcache#cancel_popup() . "\<Up>"
inoremap <expr><Down>  pumvisible() ? "\<C-n>"  : neocomplcache#cancel_popup() . "\<Down>"

" 補完候補が表示されている場合は確定。そうでない場合は改行

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


" Ruby向けにendを自動挿入してくれる
NeoBundle 'tpope/vim-endwise'

" インデントに色を付けて見やすくする
""NeoBundle 'nathanaelkane/vim-indent-guides'

" 自動カラーを無効にして手動で設定する
""let g:indent_guides_auto_colors = 0
" 奇数インデントのガイドカラー
""hi IndentGuidesOdd  ctermbg=128
" 偶数インデントのガイドカラー
""hi IndentGuidesEven ctermbg=171
" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
""let g:indent_guides_enable_on_vim_startup = 1


" ファイルをtree表示してくれる
NeoBundle 'scrooloose/nerdtree'
"---------------------------
" NERDTeeeの設定
" --------------------------

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

""NeoBundle 'Shougo/unite.vim'
" Unite.vimで最近使ったファイルを表示できるようにする
""NeoBundle 'Shougo/neomru.vim'

" http://blog.remora.cx/2010/12/vim-ref-with-unite.html
"---------------------------
" Unit.vimの設定
"----------------------------
" 入力モードで開始する
""let g:unite_enable_start_insert=1
" バッファ一覧
""noremap <C-P> :Unite buffer<CR>
" ファイル一覧
""noremap <C-N> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
""noremap <C-Z> :Unite file_mru<CR>
" sourcesを「今開いているファイルのディレクトリ」とする
""noremap :uff :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
" ウィンドウを分割して開く
""au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
""au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
""au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
""au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
""au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
""au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
"------------------------------
call neobundle#end()
filetype plugin indent on
"-------------------------
" End Neobundle Settings.
"-------------------------

"閉じカッコの自動補完
inoremap ( ()<ESC>i
inoremap <expr> ) ClosePair(')')
inoremap { {}<ESC>i
inoremap <expr> } ClosePair('}')
inoremap [ []<ESC>i
inoremap <expr> ] ClosePair(']')

inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

" pair close checker.
" " from othree vimrc ( http://github.com/othree/rc/blob/master/osx/.vimrc )
function ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>" 
	else
		return a:char
	endif
endf

" https://sites.google.com/site/fudist/Home/vim-nihongo-ban/-vimrc-sample
""""""""""""""""""""""""""""""
" 挿入モード時、ステータスラインの色を変更
""""""""""""""""""""""""""""""
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
""""""""""""""""""""""""""""""
