function! statusline#get_statusline()
    call statusline#set_mode_color(mode())

    let l:sl  = ''
    let l:sl .= '%#StatusLineModeColor#'
    let l:sl .= ' %{statusline#get_mode_label(mode())} '     " mode
    let l:sl .= '%* '                     " reset color
    let l:sl .= &readonly ? '%r ' : ''
    let l:sl .= '%t '                     " filename
    let l:sl .= !&modifiable ? '[-] ' : &modified ? '[+] ' : ''
    let l:sl .= '%<'                      " truncate here if too long
    let l:sl .= '%#StatusLineFill#'
    let l:sl .= '%='                      " right align
    let l:sl .= 'w:%{winnr()} '           " current window number
    let l:sl .= 'b:%n '                   " current buffer number
    let l:sl .= '%y '                     " filetype
    let l:sl .= '%#StatusLineTabSel#'
    let l:sl .= '%{statusline#get_reg_recording()}'
    let l:sl .= '%*'                      " reset color
    let l:sl .= '%4p%% '                  " percent of file
    let l:sl .= '%#StatusLineModeColor#'
    let l:sl .= '%5l:%-2c '               " lineno:colno
    let l:sl .= '%*'                      " reset color

    return l:sl
endfunction

function! statusline#get_reg_recording()
    let l:current_reg = reg_recording()
    if l:current_reg ==# ''
        return ''
    else
        return ' rec: ' . l:current_reg . ' '
    endif
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

let s:circled_bufnr = ['❶', '❷', '❸', '❹', '❺', '❻', '❼', '❽', '❾', '❿', '⓫', '⓬', '⓭', '⓮', '⓯', '⓰', '⓱', '⓲', '⓳', '⓴',]

function! statusline#get_bufferline()
    let l:current_buffer = bufnr('%')
    let l:bufferlist = getbufinfo({'buflisted': 1})  " only buffers listed in :ls
    " dict to map displayed buffer number to actual buffer number
    let g:bufferline_bufnr_map = {}

    let l:bl = '%#StatusLineTab#'
    let l:bl .= ' B:' . len(l:bufferlist) . ' '  " total number of buffers

    let l:counter = 0
    for l:ibuffer in l:bufferlist
        let l:counter += 1
        let g:bufferline_bufnr_map[l:counter] = l:ibuffer['bufnr']

        let l:this_buffer  = ' ' . s:circled_bufnr[l:counter - 1]
        let l:this_buffer .= ' ' . statusline#get_short_fname(l:ibuffer['name']) . ' '
        let l:this_buffer .= l:ibuffer['changed'] == 1 ? '+ ' : ''

        if l:current_buffer == l:ibuffer['bufnr']  " highlight current buffer
            let l:this_buffer  = '%#StatusLineTabSel#' . l:this_buffer
            let l:this_buffer .= '%*'  " reset color
            let l:this_buffer .= '%#StatusLineTab#'
        endif

        let l:bl .= l:this_buffer
    endfor

    let l:bl .= '%*'  " reset color
    let l:bl .= '%#StatusLineTabFill#'  " end buffer items

    let l:tablist  = '%='  " right align
    let l:tablist .= '%#StatusLineTab# '
    let l:tablist .= join(range(1, tabpagenr('$'))) . ' '  " total tabs, numbered
    let l:tablist  = substitute(l:tablist, tabpagenr(), '[\0]', '')  " add a [ ] around the current tab

    return l:bl . l:tablist
endfunction

function! statusline#get_short_fname(long_name)
    if a:long_name == ''
        return '[No Name]'
    else
"        return pathshorten(fnamemodify(a:long_name, ':.'))
        return fnamemodify(a:long_name, ':t')
    endif
endfunction
