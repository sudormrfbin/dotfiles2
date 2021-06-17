set formatoptions-=ro

" https://github.com/plasticboy/vim-markdown#adjust-new-list-item-indent
let g:vim_markdown_new_list_item_indent = 0
inoremap <expr> <CR> getline(".") =~ '\v^\s*(\-\|\*)\s*$' ? "\<C-u><CR>" : "\<CR>"
