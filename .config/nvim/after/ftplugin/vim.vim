" Vim filetype overrides

" Do not insert comment character on newline with <cr> or 'o' or 'O'
setlocal formatoptions-=r
setlocal formatoptions-=o

setlocal foldenable
setlocal foldmethod=marker
setlocal keywordprg=:botright\ help

" folded section
inoreabbrev <buffer> cm "{{{<CR>" }}}<ESC>k0f{i

let b:vcm_tab_complete = 'vim'
