-- Lua plugin configs

-- lspconfig {{{
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)

    -- buflspnkey {{{
    local function buflspnkey(key, action, mode)
        if not mode then mode = 'n' end
        action = '<cmd>lua vim.lsp.' .. action .. '<CR>'
        local opts = { noremap=true, silent=true }

        vim.api.nvim_buf_set_keymap(bufnr, mode, key, action, opts)
    end
    -- }}}

    -- Mappings {{{
    buflspnkey('gD',         'buf.declaration()')
    buflspnkey('gd',         'buf.definition()')
    buflspnkey('K',          'buf.hover()')
    buflspnkey('gi',         'buf.implementation()')
    buflspnkey('<C-k>',      'buf.signature_help()', 'i')
    buflspnkey('gy',         'buf.type_definition()')
    buflspnkey('<leader>lr', 'buf.rename()')
    buflspnkey('gr',         'buf.references()')
    buflspnkey('<C-k>',      'diagnostic.show_line_diagnostics()')
    buflspnkey('[d',         'diagnostic.goto_prev()')
    buflspnkey(']d',         'diagnostic.goto_next()')
    buflspnkey('<leader>lq', 'diagnostic.set_loclist()')

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buflspnkey("<leader>lf", "buf.formatting()")
    elseif client.resolved_capabilities.document_range_formatting then
        buflspnkey("<leader>lf", "buf.range_formatting()")
    end
    -- }}}

    -- Document highlight {{{
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
    -- }}}

    -- LSP completion icons {{{
    require('vim.lsp.protocol').CompletionItemKind = {
        -- https://github.com/hrsh7th/nvim-compe/issues/135#issuecomment-773522031
        '';   -- Text          = 1;
        '';   -- Method        = 2;
        'ƒ';   -- Function      = 3;
        '';   -- Constructor   = 4;
        '識';  -- Field         = 5;
        '勇';  -- Variable      = 6;
        '';   -- Class         = 7;
        'ﰮ';   -- Interface     = 8;
        '';   -- Module        = 9;
        '';   -- Property      = 10;
        '';   -- Unit          = 11;
        '';   -- Value         = 12;
        '了';  -- Enum          = 13;
        '';   -- Keyword       = 14;
        '﬌';   -- Snippet       = 15;
        '';   -- Color         = 16;
        '';   -- File          = 17;
        '渚';  -- Reference     = 18;
        '';   -- Folder        = 19;
        '';   -- EnumMember    = 20;
        '';   -- Constant      = 21;
        '';   -- Struct        = 22;
        '鬒';  -- Event         = 23;
        'Ψ';   -- Operator      = 24;
        '';   -- TypeParameter = 25;
    }
    -- }}}
end

-- Rust LSP {{{
nvim_lsp.rust_analyzer.setup { on_attach = on_attach }
-- }}}

-- Lua LSP {{{
local lua_settings = {
    runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
    },
    diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
    },
    workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        }
    }
}

nvim_lsp.sumneko_lua.setup {
    cmd = {"/usr/bin/lua-language-server", "-E", "/usr/share/lua-language-server/main.lua"},
    on_attach = on_attach,
    settings = { Lua = lua_settings },
}
-- }}}

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

-- nvim-bufferline {{{
require'bufferline'.setup{
    options = {
        view = "default",
        numbers = "ordinal",
        number_style = "",
        mappings = true,
        modified_icon = '⚫︎',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is deduplicated
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or ""
            return " " .. icon .. " " .. count
        end,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = {'thick', 'thick'} ,
        enforce_regular_tabs = false, -- whether to enforce same tab length
        always_show_bufferline = false,
        sort_by = 'extension',
    }
}

vim.api.nvim_set_keymap('n', '[b', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']b', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
-- }}}

-- galaxyline {{{
local gl = require('galaxyline')
local colors = require('colors').onedark
local condition = require('galaxyline.condition')
local gls = gl.section
gl.short_line_list = {'NvimTree','vista','dbui','packer'}

-- Statusline components {{{

local ModeIndicator = {
    provider = function()
        -- auto change color according the vim mode
        local normal = {'n', 'no', }
        local mode_color = {
            n      = colors.green,
            no     = colors.green,
            i      = colors.blue,
            ic     = colors.blue,
            v      = colors.magenta,
            [""] = colors.magenta,
            V      = colors.magenta,
            c      = colors.blue,
            cv     = colors.blue,
            ce     = colors.blue,
            s      = colors.orange,
            S      = colors.orange,
            [""] = colors.orange,
            R      = colors.red,
            Rv     = colors.red,
            r      = colors.green, -- hit enter prompt
            rm     = colors.green, -- --more--
            ["r?"] = colors.cyan,
            ["!"]  = colors.blue,
            t      = colors.red
        }
        -- name of hi group derived from table name name
        vim.api.nvim_command("hi GalaxyModeIndicator guifg=" .. mode_color[vim.fn.mode()])
        return "▊ "
    end,
    highlight = {colors.green, colors.bg, "bold"}
}

local FileIcon = {
        provider = 'FileIcon',
        condition = condition.buffer_not_empty,
        highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.bg},
    }

local FileName = {
        provider = 'FileName',
        condition = condition.buffer_not_empty,
        highlight = {colors.white,colors.bg,'italic'}
    }

local LineInfo = {
        provider = 'LineColumn',
        icon = '   ',
        separator_highlight = {'NONE',colors.bg},
        highlight = {colors.fg,colors.bg},
    }

local Percent = {
        provider = 'LinePercent',
        separator = ' ',
        separator_highlight = {'NONE',colors.bg},
        highlight = {colors.fg,colors.bg,'bold'},
    }

local DiagnosticError = {
        provider = 'DiagnosticError',
        icon = '  ',
        highlight = {colors.red,colors.bg}
    }

local DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '  ',
        highlight = {colors.yellow,colors.bg},
    }

local DiagnosticHint = {
        provider = 'DiagnosticHint',
        icon = '  ',
        highlight = {colors.cyan,colors.bg},
    }

local DiagnosticInfo = {
        provider = 'DiagnosticInfo',
        icon = '  ',
        highlight = {colors.blue,colors.bg},
    }

local Separator = {
    provider = function() return '' end,
    highlight = {nil, colors.light_grey}
}

local SeparatorStop = {
    provider = function() return ' ' end,
    highlight = {nil, colors.bg}
}

local LspServer = {
        provider = function() return '   ' end,
        condition = condition.check_active_lsp,
        highlight = {colors.yellow,colors.bg,'bold'}
    }

local GitBranch = {
        provider = 'GitBranch',
        icon = '  ',
        condition = condition.check_git_workspace,
        highlight = {colors.blue,colors.bg},
    }

local DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.green,colors.bg},
  }

local DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' 柳',
    highlight = {colors.orange,colors.bg},
  }

local DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.red,colors.bg},
  }

local BufferType = {
        provider = 'FileTypeName',
        separator = ' ',
        separator_highlight = {'NONE',colors.light_grey},
        highlight = {colors.blue,colors.light_grey}
}

local SFileName = {
        provider =  'SFileName',
        condition = condition.buffer_not_empty,
        highlight = {colors.fg,colors.light_grey, 'reverse'}
    }

-- }}}

gls.left = {
    {ModeIndicator   = ModeIndicator},
    {FileIcon        = FileIcon},
    {FileName        = FileName},
    {GitBranch       = GitBranch},
    {LspServer       = LspServer},
    {DiagnosticError = DiagnosticError},
    {DiagnosticWarn  = DiagnosticWarn},
    {DiagnosticInfo  = DiagnosticInfo},
    {DiagnosticHint  = DiagnosticHint},
    -- separator fills the middle
    {Separator       = Separator},
}

gls.right = {
    -- nitpick to show one character blank in front
    {SeparatorStop = SeparatorStop},
    {DiffAdd       = DiffAdd},
    {DiffModified  = DiffModified},
    {DiffRemove    = DiffRemove},
    {LineInfo      = LineInfo},
    {Percent       = Percent},
}

gls.short_line_left = {
    {SFileName = SFileName},
    {Separator = Separator},
}

gls.short_line_right = {

}

-- }}}

-- telescope {{{
local actions = require('telescope.actions')
require('telescope').setup{
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<C-J>"] = actions.move_selection_next,
                ["<C-K>"] = actions.move_selection_previous,
            },
        },
    }
}
-- }}}
