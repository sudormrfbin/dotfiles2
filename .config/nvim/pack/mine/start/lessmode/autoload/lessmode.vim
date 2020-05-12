function! lessmode#toggle_lessmode()
    if !exists('b:lessmode_enabled')
        let b:lessmode_enabled = 0
    endif

    if !b:lessmode_enabled
        nnoremap <buffer> h <C-B>
        nnoremap <buffer> j <C-E>
        nnoremap <buffer> k <C-Y>
        nnoremap <buffer> l <C-F>
        nnoremap <buffer> <C-B> h
        nnoremap <buffer> <C-E> j
        nnoremap <buffer> <C-Y> k
        nnoremap <buffer> <C-F> l

        let b:lessmode_enabled = 1
    else
        nunmap <buffer> h
        nunmap <buffer> j
        nunmap <buffer> k
        nunmap <buffer> l
        nunmap <buffer> <C-B>
        nunmap <buffer> <C-E>
        nunmap <buffer> <C-Y>
        nunmap <buffer> <C-F>

        let b:lessmode_enabled = 0
    endif
endfunction

function! lessmode#is_enabled()
    if !exists('b:lessmode_enabled') || b:lessmode_enabled == 0
        return 0
    else
        return 1
    endif
endfunction
