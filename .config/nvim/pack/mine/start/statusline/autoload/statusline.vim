function! statusline#get_statusline()
    call statusline#set_mode_color(mode())

    let l:sl  = ''
    let l:sl .= '%#StatusLineModeColor#'
    let l:sl .= ' %{statusline#get_mode_label(mode())} '     " mode
    let l:sl .= '%* '                     " reset color
    let l:sl .= '%r '                     " readonly
    let l:sl .= '%t '                     " filename
    let l:sl .= '%m '                     " modified
    let l:sl .= '%#StatusLineFill#'
    let l:sl .= '%= '                     " right align
    let l:sl .= 'w:%{winnr()} '           " current window number
    let l:sl .= 'b:%n '                   " current buffer number
    let l:sl .= '%y '                     " filetype
    let l:sl .= '%*'                      " reset color
    let l:sl .= '%4p%% '                  " percent of file
    let l:sl .= '%#StatusLineModeColor#'
    let l:sl .= '%5l:%-2c '               " lineno:colno
    let l:sl .= '%*'                      " reset color

    return l:sl
endfunction

function! statusline#get_mode_label(mode)
    if a:mode =~# '[ncitRsS]'
        return toupper(a:mode)
    elseif a:mode ==# ''
        return 'VB'
    elseif a:mode ==# 'V'
        return 'VL'
    elseif a:mode ==# 'v'
        return 'VC'
    elseif a:mode ==# ''
        return 'SB'
endfunction

function! statusline#set_mode_color(mode)
    if a:mode =~# '[nc]'
        highlight link StatusLineModeColor StatusLineNormalMode
    elseif a:mode ==# 'i'
        highlight link StatusLineModeColor StatusLineInsertMode
    elseif a:mode =~# '[vVsS]'
        highlight link StatusLineModeColor StatusLineVisualMode
    elseif a:mode ==# 't'
        highlight link StatusLineModeColor StatusLineReplaceMode
    elseif a:mode ==# 'R'
        highlight link StatusLineModeColor StatusLineReplaceMode
    endif
endfunction
