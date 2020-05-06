" Neovim Config

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
set hidden                 " Keep changes in buffer when switching
set splitbelow             " Horizontal split below current.
set splitright             " Vertical split to right of current.
set nostartofline          " Do not jump to first character with page commands.

set showtabline=2          " Always show tabline
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

set undofile               " Persistent undo

set list                   " Show special characters for tabs, trailing whitespace, etc
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" }}}1

" Functions {{{1

function! s:GoToLastCursorLocation()
    if line("'\"") > 0 && line("'\"") <= line("$") && &filetype !~# 'commit'
        normal! g'"
    endif
endfunction

function! s:ReloadVimConfig()
    let l:vimrc = $MYVIMRC
    if expand("%:p") ==# l:vimrc
        write
    endif
    source l:vimrc
endfunction

" }}}1

" Autocommands {{{
augroup Misc
    autocmd!
    autocmd BufReadPost * call s:GoToLastCursorLocation()
augroup END
" }}}

" Abbreviations {{{1

" Always open help in new bottom window
" cabbrev h botright help

" }}}1

" Keymaps {{{1

let mapleader="\<SPACE>"

noremap Y y$
nnoremap zV zMzv
inoremap jk <ESC>

nnoremap <leader><leader> :botright help 

" To disable highlighting, but enable on /, ?, n, N
nnoremap <silent><expr> <Leader>/ (&hlsearch && v:hlsearch ? ':nohlsearch' : ':set hlsearch')."\n"

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
" }}}

" Buffer {{{
nnoremap <leader>by gg"+yG<C-O>
nnoremap <leader>bw :set wrap!<CR>
nnoremap <leader>bd :bdelete<CR>
" }}}

" Splits {{{
nnoremap <leader>h <C-W>h
nnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
nnoremap <leader>l <C-W>l

nnoremap <leader>ss <C-W>s
nnoremap <leader>sv <C-W>v
nnoremap <leader>sd <C-W>c
" }}}

" Config File {{{
nnoremap <leader>e :edit $MYVIMRC<CR>
nnoremap <leader>r :call <SID>ReloadVimConfig()<CR>
" }}}

" }}}1

" Plugins {{{1

call plugpac#begin()

Pack 'k-takata/minpac', { 'type': 'opt' }

Pack 'ryvnf/readline.vim'

Pack 'manasthakur/vim-commentor'

Pack 'tpope/vim-unimpaired'

Pack 'tommcdo/vim-lion'

Pack 'wellle/targets.vim'

" TODO: replace with mucomplete
Pack 'ajh17/VimCompletesMe'

Pack 'blankname/vim-fish', { 'for': 'fish' }

" vim-sandwich {{{
Pack 'machakann/vim-sandwich', { 'type': 'opt' }

packadd! vim-sandwich
runtime macros/sandwich/keymap/surround.vim
" }}}

" vim-oldfiles {{{
Pack 'gpanders/vim-oldfiles'

nnoremap <leader>o :Oldfiles 

let g:oldfiles_blacklist = ['vim/runtime/doc']
" }}}

" vim-sneak {{{
Pack 'justinmk/vim-sneak'

nmap : <Plug>Sneak_;

let g:sneak#label = 1
" }}}

" indentLine {{{
Pack 'Yggdroot/indentLine', { 'on': 'IndentLinesToggle' }

nnoremap <leader>bi :IndentLinesToggle<CR>

let g:indentLine_char = '│'
let g:indentLine_enabled = 0
let g:indentLine_bufTypeExclude = [ 'help', 'terminal' ]
let g:indentLine_fileTypeExclude = [ 'markdown' ]
" }}}

" onedark.vim {{{
Pack 'joshdick/onedark.vim', { 'type': 'opt' }

let g:onedark_terminal_italics=1

packadd! onedark.vim
colorscheme onedark
" }}}

call plugpac#end()

" }}}1
