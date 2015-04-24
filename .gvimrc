if has('gui_macvim')
  syntax on
  set noincsearch
  colorscheme wombat
  set background=dark
  set columns=110
  set lines=56
  set expandtab
  set nobackup
  set shortmess+=I
  set guifont=Osaka-Mono:h14
  " set transparency=12

  " Cursor
  set cursorline
  "set guicursor=block-Cursor
  highlight CursorLine gui=underline cterm=underline guibg=NONE ctermbg=NONE
  highlight Cursor guifg=NONE guibg=Green
  highlight iCursor guifg=NONE guibg=lightskyblue
  " IME の on/off に合わせてカーソルの色を変える
  highlight CursorIM guifg=NONE guibg=Violet gui=NONE
  set guicursor+=a:blinkon0
  set guicursor+=i:ver100-iCursor
  set guicursor+=i:blinkon0
  "set guicursor+=a:block-Cursor
  
  set hlsearch
  highlight Search guibg=cyan guifg=black

  unlet c_space_errors
  unlet java_space_errors
endif
