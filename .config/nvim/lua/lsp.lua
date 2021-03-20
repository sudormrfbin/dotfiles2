local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    -- local function bufkey(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function bufopt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    bufopt('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local function buflspnkey(key, action)
        local action = '<cmd>lua vim.lsp.' .. action .. '<CR>'
        local opts = { noremap=true, silent=true }
        vim.api.nvim_buf_set_keymap(bufnr, 'n', key, action, opts)
    end

    -- Mappings.
    buflspnkey('gD',        'buf.declaration()')
    buflspnkey('gd',        'buf.definition()')
    buflspnkey('K',         'buf.hover()')
    buflspnkey('gi',        'buf.implementation()')
    buflspnkey('<C-k>',     'buf.signature_help()')
    buflspnkey('<space>wa', 'buf.add_workspace_folder()')
    buflspnkey('<space>wr', 'buf.remove_workspace_folder()')
    buflspnkey('<space>D',  'buf.type_definition()')
    buflspnkey('<space>rn', 'buf.rename()')
    buflspnkey('gr',        'buf.references()')
    buflspnkey('<space>e',  'diagnostic.show_line_diagnostics()')
    buflspnkey('[d',        'diagnostic.goto_prev()')
    buflspnkey(']d',        'diagnostic.goto_next()')
    buflspnkey('<space>q',  'diagnostic.set_loclist()')

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buflspnkey("<space>f", "buf.formatting()")
    elseif client.resolved_capabilities.document_range_formatting then
        buflspnkey("<space>f", "buf.range_formatting()")
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
            hi LspReferenceRead gui=underline
            hi LspReferenceText gui=bold
            hi LspReferenceWrite gui=underline,italic,reverse
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
    ]], false)
    end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "rust_analyzer" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach }
end
