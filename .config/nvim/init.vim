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
set signcolumn=auto:3      " Show signs only when they exist and show a max of 3 signs
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
set inccommand=nosplit     " Show live substitution results as you type

set updatetime=100         " Decrease updatetime for faster visual response (gutter)
set ttimeout               " Whether to timeout when waiting for keystrokes
set ttimeoutlen=50         " Amount of time to wait for

set undofile               " Persistent undo
set backupskip=/tmp/*      " Do not back up temporary files.

set list                   " Show special characters for tabs, tr  ailing whitespace, etc
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set guifont=mononoki\ Nerd\ Font:h21

filetype plugin indent on
syntax on

" }}}1

" Autocommands {{{

function! s:GoToLastCursorLocation()
    if line("'\"") > 0 && line("'\"") <= line("$") && &filetype !~# 'commit'
        normal! g'"
    endif
endfunction

augroup LastCursor
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

" Cycle through completion with tab and shift tab
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Cycle through completion with ctrl-j and ctrl-k
inoremap <silent><expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>

" Telescope {{{
nnoremap <C-M> :Telescope find_files<CR>
nnoremap <leader><leader>o :Telescope oldfiles<CR>
nnoremap <leader><leader>r :Telescope lsp_references<CR>
nnoremap <leader><leader>a :Telescope lsp_code_actions<CR>
vnoremap <leader><leader>a :<C-U>Telescope lsp_range_code_actions<CR>
nnoremap <leader><leader>s :Telescope lsp_document_symbols<CR>
nnoremap <leader><leader>w :Telescope lsp_workspace_symbols<CR>
nnoremap <leader><leader>q :Telescope quickfix<CR>
nnoremap <leader><leader>b :Telescope buffers<CR>
nnoremap <leader><leader>g :Telescope live_grep<CR>
" }}}

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
" nnoremap <Up>       <NOP>
" nnoremap <Down>     <NOP>
" nnoremap <Left>     <NOP>
" nnoremap <Right>    <NOP>
nnoremap <PageUp>   <NOP>
nnoremap <PageDown> <NOP>
nnoremap <Home>     <NOP>
nnoremap <End>      <NOP>
inoremap <Esc>      <NOP>
" inoremap <Up>       <NOP>
" inoremap <Down>     <NOP>
" inoremap <Left>     <NOP>
" inoremap <Right>    <NOP>
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
nnoremap <leader>bd :%delete<CR>
nnoremap <leader>bw :setlocal wrap!<CR>
nnoremap <leader>x :BufferClose<CR>
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
nnoremap <expr> <leader>ec ':e ' .. stdpath('config') .. '/cheat40.txt<CR>'
nnoremap <expr> <leader>el ':e ' .. stdpath('config') .. '/lua/config.lua<CR>'
" }}}

" }}}1

" Plugins {{{1

" Managed by gokulsoumya/pac

" nvim-tree.lua {{{
let g:nvim_tree_side = 'right'
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ]
let g:nvim_tree_quit_on_open = 1
let g:nvim_tree_indent_markers = 1
let g:nvim_tree_hide_dotfiles = 1
let g:nvim_tree_disable_netrw = 1
let g:nvim_tree_hijack_netrw = 1
let g:nvim_tree_add_trailing = 1
" }}}

" vim-easy-align {{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
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

" vim-polyglot {{{

" rust provided by arzg/vim-rust-syntax-ext
" disable vim-sensible bundled plugin
" let g:polyglot_disabled = ['rust']

" }}}

" vim-cheat40 {{{
let g:cheat40_use_default = 0
" }}}

" vim-workspace {{{
let g:workspace_session_directory = $HOME . '/.vim/sessions/'
let g:workspace_persist_undo_history = 0
let g:workspace_autosave = 0
" }}}

" lsp-extensions {{{
" Inlay hints for rust
autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText", enabled = {"ChainingHint", "TypeHint"} }
" }}}

" }}}1

" Lua Config {{{

" LSP config in lua/lsp.lua
lua require('config')

" Folding based on treesitter
set nofoldenable   " Disable folds when opening files
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

augroup YankHi
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{timeout=300}
augroup END
" }}}

