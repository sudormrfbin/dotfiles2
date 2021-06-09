-- vim: fdm=marker:fdl=0:fml=1

-- Lua plugin configs
local colors = require("colors").onedark

-- LSP {{{
local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
    -- buflspnkey {{{
    local function buflspnkey(key, action, mode)
        if not mode then mode = "n" end
        action = "<cmd>lua vim.lsp." .. action .. "<CR>"
        local opts = {noremap = true, silent = true}

        vim.api.nvim_buf_set_keymap(bufnr, mode, key, action, opts)
    end
    -- }}}

    -- Mappings {{{
    buflspnkey("gD", "buf.declaration()")
    -- Set with telescope
    -- buflspnkey("gd", "buf.definition()")
    -- buflspnkey("gi", "buf.implementation()")
    -- buflspnkey("gr", "buf.references()")
    -- buflspnkey("<leader>lq", "diagnostic.set_loclist()")
    buflspnkey("K", "buf.hover()")
    buflspnkey("<C-a>", "buf.signature_help()", "i")
    buflspnkey("gy", "buf.type_definition()")
    buflspnkey("<leader>lr", "buf.rename()")
    buflspnkey("<C-k>", "diagnostic.show_line_diagnostics()")
    buflspnkey("[d", "diagnostic.goto_prev()")
    buflspnkey("]d", "diagnostic.goto_next()")

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
    require("vim.lsp.protocol").CompletionItemKind = {
        -- https://github.com/hrsh7th/nvim-compe/issues/135#issuecomment-773522031
        "", -- Text          = 1;
        "", -- Method        = 2;
        "ƒ", -- Function      = 3;
        "", -- Constructor   = 4;
        "識", -- Field         = 5;
        "勇", -- Variable      = 6;
        "", -- Class         = 7;
        "ﰮ", -- Interface     = 8;
        "", -- Module        = 9;
        "", -- Property      = 10;
        "", -- Unit          = 11;
        "", -- Value         = 12;
        "了", -- Enum          = 13;
        "", -- Keyword       = 14;
        "﬌", -- Snippet       = 15;
        "", -- Color         = 16;
        "", -- File          = 17;
        "渚", -- Reference     = 18;
        "", -- Folder        = 19;
        "", -- EnumMember    = 20;
        "", -- Constant      = 21;
        "", -- Struct        = 22;
        "鬒", -- Event         = 23;
        "Ψ", -- Operator      = 24;
        "" -- TypeParameter = 25;
    }
    -- }}}
end

-- Diagnostics {{{

function dhl(severity, color)
    -- default colors used in eg. diagnostics popup
    vim.cmd("hi clear LspDiagnosticsDefault" .. severity)
    vim.cmd("hi LspDiagnosticsDefault" .. severity .. " gui=bold guifg=" ..
                color)
    -- curly underlines for diagnostics like IDEs
    vim.cmd("hi clear LspDiagnosticsUnderline" .. severity)
    vim.cmd(
        "hi LspDiagnosticsUnderline" .. severity .. " gui=undercurl guisp=" ..
            color)
    -- colors for in text diagnostics
    vim.cmd("hi clear LspDiagnosticsVirtualText" .. severity)
    vim.cmd("hi LspDiagnosticsVirtualText" .. severity ..
                " guibg=#3E4452 guifg=" .. color)

    -- Color line numbers instead of showing icons in signcolumn
    vim.fn.sign_define("LspDiagnosticsSign" .. severity,
                       {text = "", numhl = "LspDiagnosticsDefault" .. severity})
end

dhl("Error", colors.red)
dhl("Warning", colors.yellow)
dhl("Information", colors.blue)
dhl("Hint", colors.green)

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
            spacing = 2,
            prefix = " ■",
            severity_limit = "Warning"
        },
        severity_sort = true
    })
-- }}}

-- Rust LSP {{{
nvim_lsp.rust_analyzer.setup({on_attach = on_attach})
-- }}}

-- Lua LSP {{{
local lua_settings = {
    runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = vim.split(package.path, ";")
    },
    diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {"vim"}
    },
    workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
        }
    }
}

local lsp_opts = {
    cmd = {
        "/usr/bin/lua-language-server", "-E",
        "/usr/share/lua-language-server/main.lua"
    },
    on_attach = on_attach,
    settings = {Lua = lua_settings}
}

local luadev = require("lua-dev").setup({lspconfig = lsp_opts})

nvim_lsp.sumneko_lua.setup(luadev)
-- }}}

-- Python LSP {{{
nvim_lsp.pyright.setup({on_attach = on_attach})
vim.api.nvim_command(
    "autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync()")
-- }}}

-- EFM General LSP {{{
-- provides formatting for LSPs like pyright and sumneko_lua which do not
-- have their own
nvim_lsp.efm.setup({
    on_attach = on_attach,
    init_options = {documentFormatting = true},
    root_dir = vim.loop.cwd,
    settings = {
        rootMarkers = {".git/"},
        languages = {
            lua = {{formatCommand = "lua-format -i", formatStdin = true}},
            python = {{formatCommand = "black --fast -q -", formatStdin = true}}
        }
    }
})
-- }}}

-- }}}

-- nvim-compe {{{
require("compe").setup({
    enabled = true,
    -- auto open popup
    autocomplete = true,
    debug = false,
    -- min chars to trigger completion on
    min_length = 1,
    preselect = "enable",
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,

    source = {
        path = true,
        buffer = true,
        nvim_lsp = true,
        nvim_lua = true,
        tabnine = {sort = false, priority = 1, show_prediction_strength = false}
    }
})
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()",
                        {noremap = true, silent = true, expr = true})
-- }}}

-- nvim-treesitter {{{
require("nvim-treesitter.configs").setup({
    indent = {enable = true},
    highlight = {enable = true},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "gnn",
            scope_incremental = "gns",
            node_decremental = "gnN"
        }
    },
    textsubjects = {
        enable = true,
        keymaps = {
            -- this is a text object
            ['.'] = 'textsubjects-smart',
        }
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["am"] = "@function.outer",
                ["im"] = "@function.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = false, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },
})
-- }}}

-- barbar.nvim {{{
vim.api.nvim_set_keymap("n", "<C-P>", ":BufferPrevious<CR>",
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-N>", ":BufferNext<CR>",
                        {noremap = true, silent = true})
-- }}}

-- feline {{{
-- Initialize the components table
local components = {
    left = {active = {}, inactive = {}},
    mid = {active = {}, inactive = {}},
    right = {active = {}, inactive = {}}
}

local vi_mode_colors = {
    NORMAL = colors.green,
    OP = colors.green,
    INSERT = colors.blue,
    VISUAL = colors.magenta,
    BLOCK = colors.magenta,
    ["V-REPLACE"] = colors.magenta,
    REPLACE = colors.red,
    ENTER = colors.green,
    MORE = colors.green,
    SELECT = colors.orange,
    COMMAND = colors.blue,
    SHELL = colors.blue,
    TERM = colors.red,
    NONE = colors.yellow
}

local lsprovider = require("feline.providers.lsp")

local mode_color_fg = function()
    local val = {}

    -- val.name = require('feline.providers.vi_mode').get_mode_highlight_name()
    val.fg = require("feline.providers.vi_mode").get_mode_color()

    return val
end

local space_bg_sep = {str = " ", hl = {bg = colors.bg}}

-- Statusline components {{{

local ModeIndicator = {
    provider = "▊",
    hl = function()
        local val = {}

        val.name = require("feline.providers.vi_mode").get_mode_highlight_name()
        val.fg = require("feline.providers.vi_mode").get_mode_color()
        val.style = "bold"

        return val
    end,
    -- icon = '',
    right_sep = space_bg_sep
}

local FileName = {
    provider = "file_info",
    type = "unique",
    hl = {bg = colors.bg, style = "italic"}
}

local FileNameInactive = {
    provider = "file_info",
    file_modified_icon = '[+]',
    icon = '',
    type = "unique",
    hl = {bg = colors.white, fg = colors.black, style = "italic"}
}

local get_line_info = function(component)
    local curline = vim.fn.line('.')
    local curcol = vim.fn.col('.')
    local lines = vim.fn.line('$')
    local percent

    if curline == 1 then
        percent = "Top"
    elseif curline == lines then
        percent = "Bot"
    else
        percent = vim.fn.round(curline / lines * 100)
        percent = string.format("%2d%%%%", percent)
    end

    return string.format(component.icon .. "%d:%-2d %3s ", lines, curcol,
                         percent)
end

local LineInfo = {
    provider = get_line_info,
    icon = "  ",
    -- separator_highlight = {'NONE',colors.bg},
    hl = {bg = colors.bg},
    left_sep = ' '
}

local LineInfoInactive = {
    provider = get_line_info,
    icon = '',
    hl = {bg = colors.white, fg = colors.black},
    left_sep = {str = ' ', hl = {bg = colors.white}}
}

local ScrollBar = {provider = "scroll_bar", hl = mode_color_fg}

local DiagnosticError = {
    provider = "diagnostic_errors",
    enabled = function() return lsprovider.diagnostics_exist("Error") end,
    icon = "  ",
    hl = {fg = colors.red}
}

local DiagnosticWarn = {
    provider = "diagnostic_warnings",
    enabled = function() return lsprovider.diagnostics_exist("Warning") end,
    icon = "  ",
    hl = {fg = colors.yellow}
}

local DiagnosticHint = {
    provider = "diagnostic_hints",
    enabled = function() return lsprovider.diagnostics_exist("Hint") end,
    icon = "  ",
    hl = {fg = colors.green}
}

local DiagnosticInfo = {
    provider = "diagnostic_info",
    enabled = function() return lsprovider.diagnostics_exist("Information") end,
    icon = "  ",
    hl = {fg = colors.blue}
}

-- local Separator = {
--     provider = function() return '' end,
--     highlight = {nil, colors.light_grey}
-- }

-- local SeparatorStop = {
--     provider = function() return ' ' end,
--     highlight = {nil, colors.bg}
-- }

local LspServer = {
    provider = "  ",
    enabled = lsprovider.is_lsp_attached,
    hl = {fg = colors.yellow, style = "bold"}
}

local GitBranch = {
    provider = "git_branch",
    icon = "  ",
    hl = {fg = colors.blue}
}

local DiffAdd = {
    provider = "git_diff_added",
    icon = "  ",
    hl = {fg = colors.green}
}

local DiffModified = {
    provider = "git_diff_changed",
    icon = " 柳",
    hl = {fg = colors.orange}
}

local DiffRemove = {
    provider = "git_diff_removed",
    icon = "  ",
    hl = {fg = colors.red}
}

local SeparatorInactive = {
    provider = '',
    hl = {bg = colors.black, style = 'strikethrough'}
}

-- }}}

-- LuaFormatter off

components.left.inactive = {
    FileNameInactive,
    SeparatorInactive,
}

components.right.inactive = {
    LineInfoInactive
}

components.left.active = {
    ModeIndicator,
    FileName,
    GitBranch,
    LspServer,
    DiagnosticError,
    DiagnosticWarn,
    DiagnosticInfo,
    DiagnosticHint,
}
components.right.active = {
    DiffAdd,
    DiffModified,
    DiffRemove,
    LineInfo,
    ScrollBar,
}
-- LuaFormatter on

local properties = {
    force_inactive = {filetypes = {}, buftypes = {}, bufnames = {}}
}

require("feline").setup({
    default_bg = colors.light_grey,
    default_fg = colors.white,
    colors = vi_mode_colors,
    components = components,
    properties = properties,
    vi_mode_colors = vi_mode_colors
})
-- }}}

-- telescope {{{
local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<C-J>"] = actions.move_selection_next,
                ["<C-K>"] = actions.move_selection_previous
            }
        },
        -- clean sharp corners: thick and thin styles
        -- borderchars = {"━", "┃", "━", "┃", "┏", "┓", "┛", "┗"}
        borderchars = {"─", "│", "─", "│", "┌", "┐", "┘", "└"}
    }
})
-- }}}

-- autopairs {{{
require("nvim-autopairs").setup()
-- }}}

-- gitsigns.nvim {{{
require("gitsigns").setup({
    sign_priority = 6, -- default
    signs = {
        add = {
            hl = "SignifySignAdd",
            -- text = "┃",
            text = "│",
            numhl = "GitSignsAddNr",
            linehl = "GitSignsAddLn"
        },
        change = {
            hl = "SignifySignChange",
            -- text = "╏",
            text = "╎",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn"
        },
        delete = {
            hl = "SignifySignDelete",
            text = "▸",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn"
        },
        topdelete = {
            hl = "SignifySignDelete",
            text = "▴",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn"
        },
        changedelete = {
            hl = "SignifySignChange",
            text = "▸",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn"
        }
    }
})
-- }}}

-- nvim-lightbulb {{{
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
vim.fn.sign_define('LightBulbSign', { text = "", texthl = "LspDiagnosticsDefaultInformation" })
-- }}}

-- treesitter-textobjects {{{
---- }}}

-- goto-preview {{{
require('goto-preview').setup {
    width = 120; -- Width of the floating window
    height = 15; -- Height of the floating window
    default_mappings = true; -- Bind default mappings
    opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
  }
---- }}}

-- Pretty print any object
function D(obj)
    print(vim.inspect(obj))
end
