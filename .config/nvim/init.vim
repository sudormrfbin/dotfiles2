" vim: fdm=marker:fdl=0:fml=0

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
set guifont=mononoki\ Nerd\ Font\ Mono:h11.5:w5.5

filetype plugin indent on
syntax on

" }}}1

" Autocommands {{{

function! s:GoToLastCursorLocation()
    if line("'\"") > 0 && line("'\"") <= line("$") && &filetype !~# 'commit'
        normal! g'"
    endif
endfunction

augroup lastcursor
    autocmd!
    autocmd BufReadPost * call s:GoToLastCursorLocation()
augroup END

" https://github.com/jeffkreeftmeijer/vim-numbertoggle/tree/main/plugin
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
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

inoremap jk <ESC>
nnoremap <CR> :w<CR>

" Cycle through completion with tab and shift tab
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Cycle through completion with ctrl-j and ctrl-k
inoremap <silent> <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>

nnoremap <silent> gt :lua require("FTerm").toggle()<CR>
tnoremap <silent> gt <C-\><C-n>:lua require("FTerm").toggle()<CR>

nnoremap ga <c-^>

" Force line wise paste
nnoremap [p :let [content, type] =
    \ [getreg(v:register), getregtype(v:register)] \|
    \ call setreg(v:register, content, "V")<CR>[p
    \:call setreg(v:register, content, type)<CR>
nnoremap ]p :let [content, type] =
    \ [getreg(v:register), getregtype(v:register)] \|
    \ call setreg(v:register, content, "V")<CR>]p
    \:call setreg(v:register, content, type)<CR>

nnoremap <leader>f :lua vim.lsp.buf.formatting()<CR>

" Telescope {{{
nnoremap <BS> :Telescope find_files<CR>
nnoremap g' :Telescope resume<CR>
nnoremap go :Telescope oldfiles<CR>
nnoremap gr :Telescope lsp_references<CR>
nnoremap gd :Telescope lsp_definitions<CR>
nnoremap gi :Telescope lsp_implementations<CR>
nnoremap gs :Telescope lsp_document_symbols<CR>
nnoremap gy :Telescope lsp_type_definitons<CR>
nnoremap gw :Telescope lsp_dynamic_workspace_symbols<CR>
nnoremap gb :Telescope buffers<CR>
nnoremap gh :Telescope live_grep<CR>
nnoremap gx :Telescope quickfix<CR>
" }}}

" Lines {{{
" Move lines up and down
nnoremap [e        :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e        :<c-u>execute 'move +'. v:count1<cr>
" Add newlines above and below
nnoremap gk mp:<c-u>put! =repeat(nr2char(10), v:count1)<cr>`p
nnoremap gj mp:<c-u>put =repeat(nr2char(10), v:count1)<cr>`p
" }}}

" Search {{{
nnoremap <expr> n  'Nn'[v:searchforward]
xnoremap <expr> n  'Nn'[v:searchforward]
onoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]
xnoremap <expr> N  'nN'[v:searchforward]
onoremap <expr> N  'nN'[v:searchforward]
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
" nnoremap gj j
" nnoremap gk k
" }}}

" Buffer {{{
nnoremap <leader>by :%yank+<CR>
nnoremap <leader>bd :%delete<CR>
nnoremap <leader>bw :setlocal wrap!<CR>
nnoremap <leader>x :BufferClose<CR>
" }}}

" Config File {{{
nnoremap <leader>ee :edit $MYVIMRC<CR>
nnoremap <expr> <leader>el ':e ' .. stdpath('config') .. '/lua/config.lua<CR>'
" }}}

" }}}1

" Plugins {{{1

" Managed by gokulsoumya/pac

" vim-easy-align {{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }}}

" " vim-sneak {{{
" nmap : <Plug>Sneak_;
" let g:sneak#label = 1
" " Repeat last search with single s
" let g:sneak#s_next = 1
" " Case sensitivity determined by 'ignorecase' and 'smartcase'
" let g:sneak#use_ic_scs = 1
" " ; always moves forward, , always backwards
" let g:sneak#absolute_dir = 1

" nnoremap <C-Q> q

" " 2-character Sneak (default)
" nmap q <Plug>Sneak_s
" nmap Q <Plug>Sneak_S
" " visual-mode
" xmap q <Plug>Sneak_s
" xmap Q <Plug>Sneak_S
" " operator-pending-mode
" omap q <Plug>Sneak_s
" omap Q <Plug>Sneak_S

" " 1-character enhanced 'f'
" nmap f <Plug>Sneak_f
" nmap F <Plug>Sneak_F
" " visual-mode
" xmap f <Plug>Sneak_f
" xmap F <Plug>Sneak_F
" " operator-pending-mode
" omap f <Plug>Sneak_f
" omap F <Plug>Sneak_F

" " 1-character enhanced 't'
" nmap t <Plug>Sneak_t
" nmap T <Plug>Sneak_T
" " visual-mode
" xmap t <Plug>Sneak_t
" xmap T <Plug>Sneak_T
" " operator-pending-mode
" omap t <Plug>Sneak_t
" omap T <Plug>Sneak_T
" " }}}

" lightspeed.nvim {{{
nmap ' <Plug>Lightspeed_s
nmap <A-'> <Plug>Lightspeed_S
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

" indent-blankline {{{
" let g:indent_blankline_char = '┃'
let g:indent_blankline_char = '│'
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_filetype_exclude = ['help']
let g:indent_blankline_show_current_context = v:true
let g:indent_blankline_context_patterns = ['class', 'function', 'method', 'while', 'closure', 'for']
let g:indent_blankline_viewport_buffer = 50
" }}}

" gitsigns.nvim {{{
nnoremap <leader>hs :Gitsigns stage_hunk<CR>
nnoremap <leader>hr :Gitsigns reset_hunk<CR>
nnoremap <leader>hu :Gitsigns undo_stage_hunk<CR>
nnoremap <leader>hp :Gitsigns preview_hunk<CR>
nnoremap <leader>hb :Gitsigns blame_line<CR>
nnoremap [c         :Gitsigns prev_hunk<CR>
nnoremap ]c         :Gitsigns next_hunk<CR>
" }}}

" }}}1

" Lua Config {{{

" LSP config in lua/lsp.lua
lua require('config')

" Folding based on treesitter
" set nofoldenable   " Disable folds when opening files
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
" set foldlevelstart=99  " Start editing buffer with all folds open
set foldminlines=20   " Only fold when there are lines greater than this

augroup YankHi
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{timeout=300}
augroup END
" }}}

nnoremap <leader>ww :e ~/Notes/life.md<CR>

