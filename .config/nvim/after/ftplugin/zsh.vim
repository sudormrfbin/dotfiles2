" Do not insert comment character on newline with <cr> or 'o' or 'O'
setlocal formatoptions-=r
setlocal formatoptions-=o

" folded section
inoreabbrev cm #{{{<CR># }}}<ESC>k0f{i
