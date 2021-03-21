# Fish Config File

# X

# if [ -z $DISPLAY ] && [ (tty) = /dev/tty1 ]
#     exec startx /usr/bin/openbox-session
# end

if test -z $DISPLAY
    if string match -qe 'archlinux' < /proc/version
        switch (tty)
            case "/dev/tty1"
                exec startx ~/Projects/wm/target/release/wm
            case "/dev/tty2"
                exec startx /usr/bin/awesome
        end
    else
        switch (tty)
            case "/dev/tty1"
                exec startx /usr/bin/openbox-session
            case "/dev/tty2"
                exec bash ~/.local/bin/starthotspot.sh
        end
    end
end

# Keybindings

set fish_cursor_default     block
set fish_cursor_insert      line
set fish_cursor_replace_one underscore

# Add a way to switch from insert to normal (command) mode.
# Note if we are paging, we want to stay in insert mode
# See #2871 in fish-shell github issues
bind -M insert -e \e

bind -M default :     repeat-jump

bind -M insert jk     "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint-mode; end"
bind -M insert \e\x7F backward-kill-word  # alt-backspace
bind -M insert \e\[P  delete-char  # delete key

bind -M insert \eu    undo
bind -M insert \eU    redo
bind -M insert .      expand-dot-to-dir
bind -M insert \ep    fish_paginate
bind -M insert \cx    copy-to-clipboard
bind -M insert \e/    toggle-comment
bind -M insert -k f12 show-man-page
bind -M insert "`"    power-key
bind -M insert \e1    forward-word
bind -M insert \e`    forward-bigword
bind -M insert \cp    up-or-search
bind -M insert \cn   down-or-search
bind -M insert \e3    __fzf_reverse_isearch
bind -M insert \e-    'commandline -i ~/.config/'
bind -M insert \e0    __fish_preview_current_file
bind -M insert \e\>   history-token-search-forward
bind -M insert \ej    task-id-insert
bind -M insert \ck    kill-line
bind -M insert \cq    'commandline -rt ""'

# Abbreviations

# A custom function is used instead of using `abbr` to speed up overall
# load time by 50ms. Note that the custom function doesn't escape or
# test the validness of abbr names. All abbrs are added in global scope.
# See __fish_abbr_add

# fast_add_abbr does _not_ escape non-alphanumeric characters in abbr names
abbr -ag -  'cd -'

fast_add_abbr m   'man'
fast_add_abbr v   'nvim'
fast_add_abbr c   'cmus'
fast_add_abbr d   'dnote'
fast_add_abbr py  'python3'
fast_add_abbr ppy 'ptpython'

fast_add_abbr x   'chmod +x'
fast_add_abbr vv  'sudoedit'
fast_add_abbr imd 'systemctl poweroff'
fast_add_abbr ins 'yay -S'
fast_add_abbr upd 'yay -Sy'
fast_add_abbr upg 'yay -Syu'
fast_add_abbr xk  'setxkbmap -option ctrl:swapcaps; xset r rate 250 25'

fast_add_abbr rl 'exec fish'

fast_add_abbr u 'upto'

fast_add_abbr fs 'funcsave'

fast_add_abbr xo 'xdg-open'
fast_add_abbr xc 'xclip -sel clip'
fast_add_abbr wd 'wget -q --show-progress'

fast_add_abbr dpl 'drive pull'
fast_add_abbr dph 'drive push'

fast_add_abbr ga   'git add'
fast_add_abbr gl   'git log'
fast_add_abbr gb   'git branch'
fast_add_abbr gs   'git status'
fast_add_abbr gc   'git commit -m'
fast_add_abbr gd   'git diff'
fast_add_abbr gph  'git push'
fast_add_abbr gpl  'git pull'
fast_add_abbr gco  'git checkout'
fast_add_abbr gsp  'git stash pop'
fast_add_abbr gca  'git commit --amend'
fast_add_abbr gss  'git stash push --include-untracked --message'
fast_add_abbr gcl  'git clone --depth=1'
fast_add_abbr gcam 'git commit -am'
fast_add_abbr gpum 'git pull upstream master'
fast_add_abbr gcls 'git clone --depth=1 --shallow-submodules --recursive'

fast_add_abbr pa  'pluck add'
fast_add_abbr pg  'pluck export | grep'
fast_add_abbr pgp 'pluck export | grep \#'

fast_add_abbr re  'crow -s en -t es'
fast_add_abbr rs  'crow -s es -t en'

fast_add_abbr t  'task'
fast_add_abbr ta 'task add'
fast_add_abbr td 'task done'
fast_add_abbr tl 'task ready'

fast_add_abbr y  'yadm status'
fast_add_abbr ya 'yadm add'
fast_add_abbr yd 'yadm diff'
fast_add_abbr yp 'yadm push'
fast_add_abbr yc 'yadm commit -m'

# Variables

set -x EDITOR  "nvim"
set -x PATH    ~/.local/bin/ ~/go/bin/ ~/.cargo/bin/ $PATH
set -x BROWSER /usr/bin/vivaldi-stable
set -x VIM_CONFIG_PATH ~/.config/nvim/

set -x F_EXCLUDE '^/tmp/.+' '\.out$'

set __done_exclude $__done_exclude zathura feh

set -x Z_CMD "j"
set -x FZF_LEGACY_KEYBINDINGS 0
# {+} expands to space seperated list of multi selected items or current item
# use printf to properly quote selections "\'%s\'"
set -x FZF_DEFAULT_OPTS '--bind "ctrl-x:execute-silent(printf \'%s \' {+} | xclip -selection clipboard)+abort" --height=20% --cycle'

set -gx LESSHISTFILE "$HOME/.cache/.lesshist"

set -x LESS_TERMCAP_ue (printf "\e[0m")
set -x LESS_TERMCAP_me (printf "\033[0m")
set -x LESS_TERMCAP_se (printf "\033[0m")
set -x LESS_TERMCAP_us (printf "\e[01;32m")
set -x LESS_TERMCAP_mb (printf "\033[01;31m")
set -x LESS_TERMCAP_md (printf "\033[01;31m")
set -x LESS_TERMCAP_so (printf "\033[00;47;30m")

# set SPACEFISH_PROMPT_ORDER dir exec_time vi_mode line_sep exit_code char

set -g fisher_path ~/.config/fish/fisher

set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    builtin source $file
end

# Disable ^R for fzf; alt-3 already bound
# These commands must be run after the fzf plugin is loaded
bind -e \cr
bind -M insert -e \cr
