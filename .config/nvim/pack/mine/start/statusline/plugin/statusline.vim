highlight StatusLine            guifg=#abb2bf guibg=#3e4452 ctermfg=145 ctermbg=236
highlight StatusLineFill        guifg=#abb2bf guibg=#282c34 ctermfg=114 ctermbg=236
highlight StatusLineInactive    guifg=#282c34 guibg=#abb2bf ctermfg=235 ctermbg=145
highlight StatusLineTab         guifg=#abb2bf guibg=#3e4452 ctermfg=145 ctermbg=236
highlight StatusLineTabFill     guifg=#98c379 guibg=#282c34 ctermfg=114 ctermbg=236
highlight StatusLineTabSel      guifg=#282C34 guibg=#ABB2BF ctermfg=235 ctermbg=145
highlight StatusLineTabType     guifg=#282C34 guibg=#C678DD ctermfg=235 ctermbg=170
highlight StatusLineInsertMode  guifg=#282c34 guibg=#61afef ctermfg=235 ctermbg=39
highlight StatusLineNormalMode  guifg=#282c34 guibg=#98c379 ctermfg=235 ctermbg=114
highlight StatusLineVisualMode  guifg=#282c34 guibg=#c678dd ctermfg=235 ctermbg=170
highlight StatusLineReplaceMode guifg=#282c34 guibg=#e06c75 ctermfg=235 ctermbg=204

highlight link StatusLineModeColor StatusLineNormalMode

set statusline=%!statusline#get_statusline()
set tabline=%!statusline#get_bufferline()
