local theme = {}

theme.onedark = {
    black       = "#282c34", -- RGB(40, 44, 52)
    white       = "#abb2bf", -- RGB(171, 178, 191)
    red         = "#e06c75", -- RGB(224, 108, 117)
    maroon      = "#be5046", -- RGB(190, 80, 70)
    green       = "#98c379", -- RGB(152, 195, 121)
    yellow      = "#e5c07b", -- RGB(229, 192, 123)
    orange      = "#d19a66", -- RGB(209, 154, 102)
    blue        = "#61afef", -- RGB(97, 175, 239)
    magenta     = "#c678dd", -- RGB(198, 120, 221)
    cyan        = "#56b6c2", -- RGB(86, 182, 194)
    grey        = "#5c6370", -- RGB(92, 99, 112)
    gutter_grey = "#3f4952", -- RGB(63, 73, 82)
    light_grey  = "#2C323C", -- RGB(44, 50, 60)
}

theme.onedark.fg = theme.onedark.white
theme.onedark.bg = theme.onedark.gutter_grey

return theme
