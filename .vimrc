" funa's ~/.vimrc tested on Vim-6.1
" ----------------------------------------------
" Last modified: Fri, 13 Mar 2015 23:52:29 +0900
" ----------------------------------------------

" vi との互換性OFF
set nocompatible
" ファイル形式の検出を無効にする
filetype off

" To use NeoBundle
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle/'))
endif
" I want to use these Bundles
" How to install Bundles:
" % vim
" :NeoBundleInstall
" How to update Bundles:
" :NeoBundleUpdate
" How to remove BUndles:
" Remove NeoBundle lines from  .vimrc, and then :NeoBundleClean

NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet.git'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Shougo/vinarise'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'taglist.vim'
NeoBundle 'vim-scripts/errormarker.vim.git'
NeoBundle 'rizzatti/funcoo.vim'
NeoBundle 'rizzatti/dash.vim'
NeoBundle 'honza/vim-snippets'
NeoBundle 'bling/vim-airline'
" vimproc is required for include completion in neocomplete
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }

filetype on
filetype plugin on
filetype indent on
syntax on

" Here we go.
source $HOME/.exrc

"" set my vim variables
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smartcase
set laststatus=2
"set statusline=%y%{GetStatusEx()}%F%m%r%=[%3l:%3c]--%3p%%--
set term=screen
set notitle
set cursorline
set history=1000
set paste
set paste!
set splitbelow
set splitright
" set my background as dark
set background=dark
" set encoding=euc-jp
" set termencoding=euc-jp
" set fileencoding=euc-jp
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  highlight Search ctermbg=cyan ctermfg=black
  "	highlight StatusLine ctermfg=black ctermbg=blue
endif
if has('gui_macvim')
  set background=dark
  set transparency=12
  colorscheme wombat
else
  set t_Co=256
  colorscheme wombat256funa
  " screen 256 mode fix
  highlight Normal ctermbg=NONE
  highlight nonText ctermbg=NONE
endif
if has('iconv')
  set fileencodings=utf-8,iso-2022-jp,euc-jp
  if has('unix')
    set fileencodings+=cp932,shift-jis,japan
  else
    set fileencodings+=euc-jp,japan,shift-jis
  endif
  set fileencodings+=utf-16,ucs-2-internal,ucs-2
endif

"" My keymappings
map Q :qall<CR>
map <C-U> :nohlsearch<CR>
cnoremap <C-P> <UP>
cnoremap <C-N> <DOWN>

"" Insert timestamp after 'Last modified: '
" If buffer modified, update any 'Last modified: ' in the first 40 lines.
" 'Last modified: ' can have up to 10 characters before (they are retained).
" Restores cursor and window position using save_cursor variable.
function! LastModified()
  if &modified
    let save_cursor = getpos(".")
    let n = min([40, line("$")])
    keepjumps exe '1,' . n . 's#^\(.\{,10}Last modified: \).*#\1' . 
          \ strftime('%a, %d %b %Y %H:%M:%S %z') . '#e'
    call histdel('search', -1)
    call setpos('.', save_cursor)
  endif
endfun
autocmd BufWritePre * call LastModified()

" Show encoding on statusline
function! GetStatusEx()
  let str = ''
  let str = str . '' . &fileformat . ']'
  if has('multi_byte') && &fileencoding != ''
    let str = '[' . &fileencoding . ':' . str
  endif
  return str
endfunction

" Binary editor
" vinarise pluginが入っていれば :Vinarise でOK
" *.bin を開けば自動的にbinary modeに。
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

" Use Skeleton for new file.
augroup SkeletonAu
  autocmd!
  autocmd BufNewFile *.html 0r $HOME/.vim/skel.html
  autocmd BufNewFile *.c 0r $HOME/.vim/skel.c
  autocmd BufNewFile *.pl 0r $HOME/.vim/skel.pl
  autocmd BufNewFile *.py 0r $HOME/.vim/skel.py
  autocmd BufNewFile *.rb 0r $HOME/.vim/skel.rb
augroup END

" highlight
let java_highlight_all=1
let java_highlight_debug=1
let java_allow_cpp_keywords=1
let java_space_errors=1
let java_highlight_functions=1

" vim-airline
" statusline with powerline symbols
""let g:airline_powerline_fonts = 1


" Vinarise
" To use ':VinariseDump a.out' you have to install binutils from
" MacPorts. sudo port install binutils
let g:vinarise_objdump_command='gobjdump' " for MacOSX

" Nerd_Commenter
" <C-o> でコメントアウト、イン
" Visual (v, V, <C-v>)でも使用可能
let g:NERDCreateDefaultMappings = 0
let NERDSpaceDelims = 1"
nmap <C-o> <Plug>NERDCommenterToggle
vmap <C-o> <Plug>NERDCommenterToggle

" Dash (sophisticated man)
" 検索したいwordの上で K
""function! s:dash(...)
""  let ft = &filetype
""  if &filetype == 'python'
""    let ft = ft.'2'
""  endif
""  let ft = ft.':'
""  let word = len(a:000) == 0 ? input('Dash search: ', ft.expand('<cword>')) : ft.join(a:000, ' ')
""  call system(printf("open dash://'%s'", word))
""endfunction
""command! -nargs=* Dash call <SID>dash(<f-args>)
""nmap K :Dash<CR>
:nmap <silent> K <Plug>DashSearch

" Taglist
" :Tlist<CR>
"set tags=tags,~/Downloads/libsbml-5.1.0-b0/src/tags
set tags=tags
let Tlist_Ctags_Cmd = "/opt/local/bin/ctags"
let Tlist_Show_One_File = 1 "現在編集中のソースのタグしか表示しない
let Tlist_Exit_OnlyWiindow = 1 "taglist が最後のウインドウなら vim を閉じる
"let Tlist_Enable_Fold_Column = 1 " 折り畳み
"map <silent> <leader>tl :TlistToggle<CR>
"let g:tlist_php_settings = 'php;c:class;d:constant;f:function'

" Changelog mode
au BufNewFile,BufRead 00diary setf changelog
au BufNewFile,BufRead 00diary set expandtab
let g:changelog_timeformat = "%Y-%m-%d"
let g:changelog_username = "Akira Funahashi <funa@funa.org>"

" ANTLR
au BufRead,BufNewFile *.g set syntax=antlr3

" QuickRun
silent! nmap <unique> <C-c>c <Plug>(quickrun)
" 横分割をするようにする (C-w o で現在開いているbuffer以外を閉じる)
let g:quickrun_config={'*': {'split': '12'}}  " 下12行を実行結果に
" 以下のように実行するとコマンドライン引数を渡すことが出来る。
" :QuickRun -args hogefuga
" vimprocを用いて非同期に実行する
" (vim が +clientserver 付きでコンパイルされている必要あり)
" let g:quickrun_config._ = {'runner' : 'vimproc'}
" HTMLの場合openで開くようにする
let g:quickrun_config.html = { 'command' : 'open', 'exec' : ['%c %s'] }
" Javaの文字化け対策
let g:quickrun_config.java = { 'exec': ['javac -J-Dfile.encoding=UTF-8 %o %s', '%c -Dfile.encoding=UTF-8 %s:t:r %a', ':call delete("%S:t:r.class")'] }
" Markdown
" markdownではvimprocによる非同期実行が遅いので無効化
let g:quickrun_config.markdown = {
      \ 'runner' : 'system',
      \ 'type' : 'markdown/bluecloth',
      \ 'cmdopt' : '-f',
      \ 'outputter' : 'browser'
      \ }
" (La)TeX
" LaTeXをquickrunで楽に処理する - プログラムモグモグ
" http://d.hatena.ne.jp/itchyny/20121001/1349094989 等参考。viewtexは~/bin/に
"let g:quickrun_config.tex = { 'command' : 'viewtex' }

"errormarker設定 {{{
" QuickFixを呼ぶのでQuickFixの操作方法を。
" :set makeprg=gcc\ foo.c
" :make でCのファイルもQuickFixできる。
" :cn で次のエラーへ。 :cN で前のエラーへ。
" 保存時に自動的に :make を実行するには、Filetype Pluginで各拡張子毎に BufWritePost のhookを書く。
" ~/.vim/ftplugin/c.vim 等を編集して set makeprg を変更する
hi Error ctermbg=darkblue
hi Error ctermfg=white
hi Todo ctermbg=darkgreen
hi Todo ctermfg=white
let &errorformat="%f:%l: %t%*[^:]:%m," . &errorformat
let &errorformat="%f:%l:%c: %t%*[^:]:%m," . &errorformat
let g:errormarker_warningtypes = "wWiI"
let g:errormarker_errortext = '! '
let g:errormarker_warningtext = 'W '
let g:errormarker_errorgroup = 'Error'
let g:errormarker_warninggroup = 'Todo'
if has('win32') || ('win64')
  let g:errormarker_erroricon = expand('$VIM/signs/err.bmp')
  let g:errormarker_warningicon = expand('$VIM/signs/warn.bmp')
else
  let g:errormarker_erroricon = expand('$VIM/signs/err.png')
  let g:errormarker_warningicon = expand('$VIM/signs/warn.png')
endif
"}}}

"" for snippets
" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" Tell Neosnippet about the other snippets
"let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets, ~/.vim/snipmate-snippets-rubymotion/snippets'

"" neocomplete settings
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" C-n, C-p ... select
" C-y ... apply
" C-k ... snippets hit C-k again to move to next placeholder
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" ctags
let g:neocomplete#ctags_command = "/opt/local/bin/ctags"
let g:neocomplete#ctags_arguments = {
      \ 'perl' : '-R -h ".pm"'
      \}

" include completion
if !exists('g:neocomplete#sources#include#paths')
  let g:neocomplete#sources#include#paths = {}
endif
let g:neocomplete#sources#include#paths.c  =  '/usr/include,'.'/usr/local/include,'.'/opt/local/include'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
      \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

"" neosnippet
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
"" neosnippet End

