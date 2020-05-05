" TODO: maps for jumping to next tag or following tag under cursor
nnoremap <buffer> h <C-B>
nnoremap <buffer> j <C-E>
nnoremap <buffer> k <C-Y>
nnoremap <buffer> l <C-F>
nnoremap <buffer> <BS> <C-O>

nnoremap <buffer> <C-B> h
nnoremap <buffer> <C-E> j
nnoremap <buffer> <C-Y> k
nnoremap <buffer> <C-F> l

" Jump to next tagnd fo  llow it
" BUGS: - If there is no match but the word under the cursor is a valid
"       tag, it is followd
"       - If cursor is on a valid tag but another tag exist after it,
"         the following one is selected with <CR>; no problem with \
" TODO: breakout to function
nnoremap <buffer> <CR> :call search('\|\k\{-}\|', "sw", line("w$"))<CR>K
nnoremap <buffer> \  :call search('\|\k\{-}\|', "bs", line("w0"))<CR>K

" function! s:GoToNextTag() range
"     let cnt = v:count1
"     " let searchresult = 0
"     normal! B

"     while cnt
"         call search('\|\k\{-}\|', "sw")
"         let cnt -= 1
"     endwhile

"     normal! K
" endfunction

" nnoremap <buffer> , :call <SID>GoToNextTag()<CR>
