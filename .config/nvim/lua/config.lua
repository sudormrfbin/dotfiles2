-- Lua plugin configs

-- lspconfig {{{
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    -- local function bufkey(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function bufopt(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    bufopt('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local function buflspnkey(key, action, mode)
        if not mode then mode = 'n' end
        local action = '<cmd>lua vim.lsp.' .. action .. '<CR>'
        local opts = { noremap=true, silent=true }

        vim.api.nvim_buf_set_keymap(bufnr, mode, key, action, opts)
    end

    -- Mappings.
    buflspnkey('gD',         'buf.declaration()')
    buflspnkey('gd',         'buf.definition()')
    buflspnkey('K',          'buf.hover()')
    buflspnkey('gi',         'buf.implementation()')
    buflspnkey('<C-k>',      'buf.signature_help()', 'i')
    buflspnkey('gy',         'buf.type_definition()')
    buflspnkey('<leader>lr', 'buf.rename()')
    buflspnkey('gr',         'buf.references()')
    buflspnkey('<leader>ld', 'diagnostic.show_line_diagnostics()')
    buflspnkey('[d',         'diagnostic.goto_prev()')
    buflspnkey(']d',         'diagnostic.goto_next()')
    buflspnkey('<leader>lq', 'diagnostic.set_loclist()')

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buflspnkey("<leader>lf", "buf.formatting()")
    elseif client.resolved_capabilities.document_range_formatting then
        buflspnkey("<leader>lf", "buf.range_formatting()")
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
-- }}}

-- nvim-compe {{{
require 'compe'.setup {
    enabled = true;
    -- auto open popup
    autocomplete = true;
    debug = false;
    -- min chars to trigger completion on
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
        path = true;
        buffer = true;
        nvim_lsp = true;
        nvim_lua = true;
    };
}
-- }}}

-- -- lspsaga {{{
-- local saga = require 'lspsaga'

-- saga.init_lsp_saga {
--     use_saga_diagnostic_sign = true,
--     error_sign = '',
--     warn_sign = '',
--     hint_sign = '',
--     infor_sign = '',
--     dianostic_header_icon = '   ',
--     code_action_icon = ' ',
--     code_action_prompt = {
--         enable = true,
--         sign = true,
--         sign_priority = 20,
--         virtual_text = true,
--     },
--     finder_definition_icon = '  ',
--     finder_reference_icon = '  ',
--     max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
--     finder_action_keys = {
--         open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
--     },
--     code_action_keys = {
--         quit = 'q',exec = '<CR>'
--     },
--     rename_action_keys = {
--         quit = '<C-c>',exec = '<CR>'  -- quit can be a table
--     },
--     definition_preview_icon = '  ',
--     -- 1: thin border | 2: rounded border | 3: thick border | 4: ascii border
--     border_style = 1,
--     rename_prompt_prefix = '➤',

-- }
-- -- }}}

-- nvim-treesitter {{{
require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "gnn",
            scope_incremental = "gns",
            node_decremental = "gnN",
        },
    },
    indent = {
        enable = true,
    },
}
-- }}}
