" Do not insert comment character on newline with <cr> or 'o' or 'O'
setlocal formatoptions-=o

" folded section
inoreabbrev <buffer> cm --{{{<CR>-- }}}<ESC>k0f{i

" for `gf` to work properly with vim-apathy
set path+=lua/
