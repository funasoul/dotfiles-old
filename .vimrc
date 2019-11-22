" funa's ~/.vimrc tested on Vim-6.1
" ----------------------------------------------
" Last modified: Mon, 12 Aug 2019 06:38:33 +0900
" ----------------------------------------------

" vi との互換性OFF
set nocompatible
" ファイル形式の検出を無効にする
filetype off

" neovim 用設定
if has('nvim')
  " set termguicolors
  " hi Cursor guifg=cyan guibg=cyan
  set clipboard+=unnamedplus
endif

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
" How to remove Bundles:
" Remove NeoBundle lines from  .vimrc, and then :NeoBundleClean

NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Shougo/vinarise'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'taglist.vim'
NeoBundle 'vim-scripts/errormarker.vim.git'
NeoBundle 'rizzatti/funcoo.vim'
NeoBundle 'rizzatti/dash.vim'
NeoBundle 'honza/vim-snippets'
NeoBundle 'bling/vim-airline'
NeoBundle 'rking/ag.vim'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'Vimjas/vim-python-pep8-indent'
NeoBundle 'tyru/current-func-info.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Xuyuanp/nerdtree-git-plugin'
NeoBundle 'zah/nim.vim'
NeoBundle 'zerowidth/vim-copy-as-rtf'
NeoBundle "mechatroner/rainbow_csv"
NeoBundle 'w0rp/ale'
" vim-devicons を使うなら、iTerm2 にてフォントを
" Ricty Diminished with-icons Regular に設定し、
" [ ] Use a different font for non-ASCII text を OFF にする。
" NeoBundle 'ryanoasis/vim-devicons'
" NeoBundle 'tiagofumo/vim-nerdtree-syntax-highlight'
" Jedi for python
NeoBundleLazy "davidhalter/jedi-vim", { "autoload": { "filetypes": [ "python", "python3", "djangohtml"] }}
"NeoBundle 'gilligan/vim-lldb'
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

" Automatic reloading of .vimrc
"autocmd! bufwritepost .vimrc source %

" Better copy & paste
set pastetoggle=<F2>
"set clipboard=unnamed

" Show whitespace
" MUST be inserted BEFORE the colorscheme command
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=cyan guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/

"" set my vim variables
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set expandtab
set smarttab
set smartindent
set breakindent            " wrap line した際にインデントを合わせる
set breakindentopt=shift:2 " wrap line した時のインデント数
set smartcase
set infercase           " 補完時に大文字小文字を区別しない
set laststatus=2
"set statusline=%y%{GetStatusEx()}%F%m%r%=[%3l:%3c]--%3p%%--
if !has('nvim')
  set term=screen
endif
set notitle
set cursorline
set history=1000
set paste
set paste!
set splitbelow
set splitright
set backspace=start,eol,indent
set mouse= "disable mouse function on vim
" no backup for file in /tmp (for crontab -e)
set backupskip=/tmp/*,/private/tmp/*
set ambiwidth=double
" set my background as dark
set background=dark
" set encoding=euc-jp
" set termencoding=euc-jp
" set fileencoding=euc-jp
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac
set tw=79  " text width
set nowrap " don't automatically wrap on load
set fo-=t  " don't automatically wrap text when typing
set colorcolumn=80

" Avoid slowdown on switching Insert <-> Normal mode.
if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif
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
  highlight Search ctermbg=238
  highlight CursorLine term=underline cterm=underline ctermbg=NONE
  highlight ColorColumn ctermbg=233
  " ALE (Asynchronious Lint Engine)
  highlight ALEWarning ctermbg=23
  highlight ALEError ctermbg=125
  highlight ALEWarningSign ctermbg=22
  highlight ALEErrorSign ctermbg=18
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
let mapleader = "\<Space>"
map Q :qall<CR>
map <C-U> :nohlsearch<CR>
" better search history
cnoremap <C-N> <DOWN>
cnoremap <C-P> <UP>
" Emacs cursor map for insert mode
"inoremap <C-n> <Down>
"inoremap <C-p> <Up>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <silent> <C-d> <Del>
" [Space] [Space]で直前のバッファに戻る(バッファを閉じるなら :bw )
nnoremap <leader><leader> <C-^>
" move in wrapped line by arrow key
nnoremap <Down> gj
nnoremap <Up> gk
if has('nvim')
  tnoremap <silent> <ESC> <C-\><C-n> " keymap for neovim terminal emulator
endif
" V (or C-v) でvisual modeで選択した範囲を sort
vnoremap <Leader>s :sort<CR>
" V (or C-v) でvisual modeで選択した範囲を indent
vnoremap < <gv " better indentation
vnoremap > >gv " better indentation

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
" function! GetStatusEx()
  " let str = ''
  " let str = str . '' . &fileformat . ']'
  " if has('multi_byte') && &fileencoding != ''
    " let str = '[' . &fileencoding . ':' . str
  " endif
  " return str
" endfunction

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

" FileType set
augroup filetypedetect
  au BufRead,BufNewFile Portfile setfiletype tcl
  " associate Portfile with tcl filetype
augroup END

" Use Skeleton for new file.
augroup SkeletonAu
  autocmd!
  autocmd BufNewFile *.html 0r $HOME/.vim/skel.html
  autocmd BufNewFile *.c 0r $HOME/.vim/skel.c
  autocmd BufNewFile *.pl 0r $HOME/.vim/skel.pl
  autocmd BufNewFile *.py 0r $HOME/.vim/skel.py
  autocmd BufNewFile *.rb 0r $HOME/.vim/skel.rb
  autocmd BufNewFile *.tex 0r $HOME/.vim/skel.tex
augroup END

" highlight
let java_highlight_all=1
let java_highlight_debug=1
let java_allow_cpp_keywords=1
let java_space_errors=1
let java_highlight_functions=1

" XML folding
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax
au FileType xsd setlocal foldmethod=syntax
set foldlevelstart=20
nnoremap <space> za

" " Unite.vim
" " insert modeで開始
" let g:unite_enable_start_insert = 1
" " 大文字小文字を区別しない
" let g:unite_enable_ignore_case = 1
" let g:unite_enable_smart_case = 1
" " 
" let g:unite_source_history_yank_enable =1
" let g:unite_source_file_mru_limit = 200
" " keybind for unite
" nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
" nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>
" " grep検索
" nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" " カーソル位置の単語をgrep検索
" nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
" " ディレクトリを指定してgrep検索
" nnoremap <silent> ,dg  :<C-u>Unite grep -buffer-name=search-buffer<CR>
" " grep検索結果の再呼出
" nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>
" " unite grep に ag(The Silver Searcher) を使う
" if executable('ag')
  " let g:unite_source_grep_command = 'ag'
  " let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  " let g:unite_source_grep_recursive_opt = ''
" endif

" Use Ag from Ctrl-P
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
" bind K to grep word under cursor (fast and easy tag jump!)
" K で検索したら quickfix window に結果が表示されるのでhjkl or カーソルキーで選択、[Enter]で該当行に飛ぶ。
" quickfix で飛んだ先から帰るには <C-o>, 再度飛ぶには <C-i>
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" NERDTree
" open NERDTree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>
" Highlight full name (not only icons). You need to add this if you don't have
" vim-devicons and want highlight.
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

" vim-airline
" statusline with powerline symbols
"let g:airline_powerline_fonts = 1
" avoid slowdown
let g:airline_highlighting_cache=1
" show the current function name on statusline (requires vim-airline and
" current-func-info.vim).
let g:airline_section_c = '%t [%{cfi#format("%s()", "no function")}]'

" Vinarise
" To use ':VinariseDump a.out' you have to install binutils from
" MacPorts. sudo port install binutils
let g:vinarise_objdump_command='gobjdump' " for MacOSX

" Nerd_Commenter
" <Leader>c<Space> でコメントアウト、イン
" <Leaer>を<Space>にしているのでつまりは
" <Space>c<Space> でコメントのトグル。
" Visual (v, V, <C-v>)でも使用可能
" 範囲指定の場合は `<Space>cs` が便利
" vim では <C-/> をmapできないので<C-/>にmapすることは不可能。
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign='left'
let g:NERDCompactSexyComs = 1

" vim-javascript
" Enables syntax highlighting for JSDocs.
let g:javascript_plugin_jsdoc = 1
" Enables some additional syntax highlighting for NGDocs. Requires JSDoc plugin to be enabled as well.
let g:javascript_plugin_ngdoc = 1
" Enables syntax highlighting for Flow.
let g:javascript_plugin_flow = 1

" ALE(Asynchronious Lint Engine)
" sudo port install py27-flake8 py36-flake8
" sudo port select --set pycodestyle pycodestyle-py27
" sudo port select --set flake8 flake8-27
" sudo port select --set pyflakes py27-pyflakes
" sudo port install py27-autopep8 py36-autopep8
" sudo port select --set autopep8 autopep8-27
" sudo port install py27-isort py36-isort
" sudo port install py27-yapf py36-yapf
" sudo port select --set yapf py27-yapf
" 左端のシンボルカラムを表示したままにする(お好みで)
" let g:ale_sign_column_always = 1
" ~/.vim/ftplugin/python.vim に g:ale_fixers を記述(fixerに何を使うかを指定)
" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1
" Set include path for clang and gcc
" C
let g:ale_c_clang_options = "-std=c11 -Wall -I/opt/local/include -I../include"
let g:ale_c_gcc_options = "-std=c11 -Wall -I/opt/local/include -I../include"
" C++
let g:ale_cpp_clang_options = "-std=c++14 -Wall -I/opt/local/include -I../include"
let g:ale_cpp_gcc_options = "-std=c++14 -Wall -I/opt/local/include -I../include"
" Set this in your vimrc file to disabling highlighting
" let g:ale_set_highlights = 0
" <C-k> previous error, <C-j> next error
nmap <silent> <C-k> <Plug>(ale_previous)
nmap <silent> <C-j> <Plug>(ale_next)

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
":nmap <silent> K <Plug>DashSearch

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

" Nim
fun! JumpToDef()
  if exists("*GotoDefinition_" . &filetype)
    call GotoDefinition_{&filetype}()
  else
    exe "norm! \<C-]>"
  endif
endf

" Jump to tag
"nn <C-]> :call JumpToDef()<cr>
"ino <C-]> <esc>:call JumpToDef()<cr>i

" QuickRun
silent! nmap <unique> <C-c>c <Plug>(quickrun)
" 横分割をするようにする (C-w o で現在開いているbuffer以外を閉じる)
"let g:quickrun_config={'*': {'split': '12'}}  " 下12行を実行結果に
let g:quickrun_config = {
      \   "_" : {
      \       "outputter/buffer/split" : ":botright 8sp",
      \       "outputter" : "error",
      \       "outputter/error/success" : "buffer",
      \       "outputter/error" : "quickfix",
      \       "runner" : "vimproc",
      \       "runner/vimproc/updatetime" : 40,
      \   }
      \}
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
" QuickFix
augroup QuickFixCmd
  autocmd!
  autocmd QuickFixCmdPost *grep* cwindow
augroup END
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
nmap <silent> <unique> <Leader><Leader>cc :ErrorAtCursor<CR>
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
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
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
