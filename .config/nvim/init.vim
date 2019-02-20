" Neovim Config

" Map the leader key to SPACE
let mapleader="\<SPACE>"

set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set noshowmode          " Do not show current mode as lightline will do so
set ruler               " Show the line and column numbers of the cursor.
set number              " Show the line numbers on the left side.
set formatoptions+=o    " Continue comment marker in new lines.
set textwidth=0         " Hard-wrap long lines as you type them.
set expandtab           " Insert spaces when TAB is pressed.
set guicursor=          " Fix bug where wierd chars are shown when pressing i, :, etc

set noerrorbells        " No beeps.
set modeline            " Enable modeline.
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

if !&scrolloff
  set scrolloff=3       " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
  set sidescrolloff=5   " Show next 5 columns while side-scrolling.
endif
set nostartofline       " Do not jump to first character with page commands.

" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list                " Show problematic characters.

" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$\|\t/

set ignorecase          " Make searching case insensitive
set smartcase           " ... unless the query has capital letters.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif


" Esc by `jk`
inoremap jk <esc>

" Highlight current line
set cursorline

" Open file at same line number
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Vim Plug
call plug#begin('~/.vim/plugged')

Plug 'Shougo/deoplete.nvim'

Plug 'joshdick/onedark.vim'

" Plug 'airblade/vim-gutter'

Plug 'zchee/deoplete-jedi'

Plug 'itchyny/lightline.vim'

Plug 'ervandew/supertab'

Plug 'scrooloose/nerdtree'

Plug 'mgee/lightline-bufferline'

" Plug 'w0rp/ale'

call plug#end()

colorscheme onedark
