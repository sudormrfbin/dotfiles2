local wezterm = require'wezterm';

return {
    color_scheme = "OneHalfDark",
    font = wezterm.font_with_fallback({
        -- "mononoki Nerd Font Mono",
        "mononoki",
    }),
    font_size = 17,
    hide_tab_bar_if_only_one_tab = true,
    force_reverse_video_cursor = true,
    -- allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"
    -- freetype_load_target = "Normal",
}
