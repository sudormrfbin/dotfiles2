" Vim Config

" Options {{{1

set showcmd                " Show (partial) command in status line.
set noshowmode             " Do not show current mode as lightline will do so

set tabstop=4              " Set tab to 4 space
set softtabstop=4          " Pretend to remove TABs with <BS> even if spaces
set expandtab              " Insert spaces when TAB is pressed.
set shiftwidth=4           " Number of spaces to use for each step of (auto)indent 
set tabstop=4              " Width of tab character

set foldmarker=\ {{{,\ }}} " String to use as fold delimiters

set lazyredraw             " Make macros faster by not redrawing screen
set mouse=a                " Enable mouse
set hidden                 " Keep changes in buffer when switching
set splitbelow             " Horizontal split below current.
set splitright             " Vertical split to right of current.
set nostartofline          " Do not jump to first character with page commands.
set wildmenu               " Show completions in command mode on a line above it

set showtabline=2          " Always show tabline
set laststatus=2           " Always show the statusline for all windows
set wildoptions=tagfile    " Disable vertical completion by removing pum option
set wildignorecase         " Ignore case when completing file name and directories

set showmatch              " Show matching brackets.
set nowrap                 " Do not wrap lines
set ruler                  " Show the line and column numbers of the cursor.
set number                 " Show the line numbers on the left side.
set relativenumber         " Show relative line numbers
set cursorline             " Highlight current line
set scrolloff=3            " Show next 3 lines while scrolling.
set sidescrolloff=5        " Show next 5 columns while side-scrolling.
set conceallevel=1         " Do not hide characters for eg. when editing md
set concealcursor=""       " Never conceal for any mode in current line
set termguicolors          " Set 24-bit colors

set ignorecase             " Make searching case insensitive
set smartcase              " ... unless the query has capital letters.
set nomagic                " Use 'magic' patterns (extended regular expressions).
set hlsearch               " Highlight search results
set incsearch              " Highlight search matches as you type

set updatetime=100         " Decrease updatetime for faster visual response (gutter)
set ttimeout               " Whether to timeout when waiting for keystrokes
set ttimeoutlen=50         " Amount of time to wait for

set undofile               " Persistent undo
set backupskip=/tmp/*      " Do not back up temporary files.

set list                   " Show special characters for tabs, tr  ailing whitespace, etc
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+          
                                                                   
filetype plugin indent on
syntax on

" }}}1

" Autocommands {{{

function! s:GoToLastCursorLocation()
    if line("'\"") > 0 && line("'\"") <= line("$") && &filetype !~# 'commit'
        normal! g'"
    endif
endfunction

augroup Misc
    autocmd!
    autocmd BufReadPost * call s:GoToLastCursorLocation()
augroup END

" }}}

" Abbreviations {{{1

" Always open help in new bottom window
cabbrev h botright help
cabbrev <expr> %% expand('%:h')

" }}}1

" Keymaps {{{1

let mapleader="\<SPACE>"

noremap Y y$
nnoremap zV zMzv
nnoremap <C-P> R<C-R>0<ESC>

inoremap jk <ESC>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Lines {{{
" Move lines up and down
nnoremap [e        :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e        :<c-u>execute 'move +'. v:count1<cr>
" Add newlines above and below
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>
" }}}

" Search {{{
nnoremap <expr> n  'Nn'[v:searchforward]
xnoremap <expr> n  'Nn'[v:searchforward]
onoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]
xnoremap <expr> N  'nN'[v:searchforward]
onoremap <expr> N  'nN'[v:searchforward]
" }}}

" Disabled {{{
nnoremap <Up>       <NOP>
nnoremap <Down>     <NOP>
nnoremap <Left>     <NOP>
nnoremap <Right>    <NOP>
nnoremap <PageUp>   <NOP>
nnoremap <PageDown> <NOP>
nnoremap <Home>     <NOP>
nnoremap <End>      <NOP>
inoremap <Esc>      <NOP>
inoremap <Up>       <NOP>
inoremap <Down>     <NOP>
inoremap <Left>     <NOP>
inoremap <Right>    <NOP>
inoremap <PageUp>   <NOP>
inoremap <PageDown> <NOP>
inoremap <Home>     <NOP>
inoremap <End>      <NOP>
" }}}

" Swapped {{{
noremap - $
noremap $ -
nnoremap ; :
nnoremap : ;
xnoremap ; :
xnoremap : ;
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
" }}}

" Buffer {{{
nnoremap <leader>by :%yank+<CR>
nnoremap <leader>bw :set wrap!<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>
" }}}

" Splits {{{
nnoremap <leader>h <C-W>h
nnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
nnoremap <leader>l <C-W>l
" }}}

" Config File {{{
nnoremap <leader>ee :edit $MYVIMRC<CR>
nnoremap <leader>er :source $MYVIMRC<CR>
" }}}

" }}}1

" Plugins {{{1

" Managed by maralla/pack

" vim-signify {{{
let g:signify_sign_add = '┃'
let g:signify_sign_change = '╏'
let g:signify_sign_delete = '▸'
let g:signify_sign_delete_first_line = '▴'
" }}}

" vim-sandwich {{{
packadd! vim-sandwich
runtime macros/sandwich/keymap/surround.vim
" }}}

" vim-sneak {{{
nmap : <Plug>Sneak_;
let g:sneak#label = 1
" }}}

" onedark.vim {{{
packadd! onedark.vim

" https://github.com/alacritty/alacritty/issues/3402
if &term == "alacritty"
  let &term = "xterm-256color"
endif

let g:onedark_terminal_italics=1
colorscheme onedark
" }}}

" lightline.vim & lightline-bufferline {{{
let g:lightline = {
    \ 'colorscheme': 'onedark',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'filename', 'modified' ] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'filetype' ] ]
    \ },
    \ 'component_function': {
    \   'filename': 'IconFileName',
    \   'cwd': 'GetCwd',
    \ },
    \ 'tabline': {
    \   'left': [ ['buffers'] ],
    \   'right': [ ['cwd'] ]
    \ },
    \ 'component_expand': {
    \   'buffers': 'lightline#bufferline#buffers'
    \ },
    \ 'component_type': {
    \   'buffers': 'tabsel'
    \ },
    \ 'mode_map': {
      \ 'n' : 'N',
      \ 'i' : 'I',
      \ 'R' : 'R',
      \ 'v' : 'V',
      \ 'V' : 'VL',
      \ "\<C-v>": 'VB',
      \ 'c' : 'C',
      \ 's' : 'S',
      \ 'S' : 'SL',
      \ "\<C-s>": 'SB',
      \ 't': 'T',
      \ },
    \ }

function! GetCwd()
    return pathshorten(substitute(getcwd(), expand("~"), "~", ""), 2)
endfunction

function! IconFileName()
    return strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() . ' ' . expand('%:t') : '[No Name]'
endfunction

let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#show_number = 1
let g:lightline#bufferline#unicode_symbols = 1
" }}}

" vim-polyglot {{{

" rust provided by arzg/vim-rust-syntax-ext
" disable vim-sensible bundled plugin
let g:polyglot_disabled = ['rust', 'sensible']

" }}}

" coc.nvim {{{
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" }}}

" vim-cheat40 {{{
let g:cheat40_use_default = 0
" }}}

" }}}1

" Misc {{{

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"

" }}}
