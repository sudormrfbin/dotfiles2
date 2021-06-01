" Do not insert comment character on newline with <cr> or 'o' or 'O'
setlocal formatoptions-=r
setlocal formatoptions-=o

setlocal foldmethod=marker
" folded section
inoreabbrev cm --{{{<CR>-- }}}<ESC>k0f{i

" for `gf` to work properly with vim-apathy
set path+=lua/
