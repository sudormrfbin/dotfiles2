#h Fish Config File

# X

# if [ -z $DISPLAY ] && [ (tty) = /dev/tty1 ]
#     exec startx /usr/bin/openbox-session
# end

if test -z $DISPLAY
    if string match -qe 'archlinux' < /proc/version
        switch (tty)
            case "/dev/tty1"
                exec startx
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
abbr -a icat 'kitty +kitten icat'
abbr -a nnn 'nnn -P p' # run preview plugin on startup

abbr -a -  'cd -'

abbr -a g   'git'
abbr -a m   'man'
abbr -a v   'hx'
abbr -a py  'python3'
abbr -a l ls

abbr -a x   'chmod +x'
abbr -a vv  'sudoedit'
abbr -a imd 'systemctl poweroff'
abbr -a ins 'paru -S'
abbr -a upd 'paru -Sy'
abbr -a upg 'paru -Syu'

abbr -a rl 'exec fish'

abbr -a xo 'xdg-open'
abbr -a xc 'xclip -sel clip'

abbr -a c  'cargo'
abbr -a cf 'cargo fmt'
abbr -a ch 'cargo check'
abbr -a cr 'cargo run --'
abbr -a cl 'cargo clippy'

abbr -a g- 'git switch -'
abbr -a ga    'git add'
abbr -a gl    'git log'
abbr -a gb    'git branch --sort=-committerdate'
abbr -a gs    'git status'
abbr -a gc    'git commit -m'
abbr -a gd    'git diff'
abbr -a g1    'git clone --depth=1'
abbr -a gph   'git push'
abbr -a gpl   'git pull'
abbr -a gco   'git checkout'
abbr -a gsp   'git stash pop'
abbr -a gca   'git commit --amend'
abbr -a gcaan 'git commit --amend --all --no-edit'
abbr -a gss   'git stash push --include-untracked --message'
abbr -a gcl   'git clone --depth=1'
abbr -a gcam  'git commit -am'
abbr -a gpum  'git pull upstream master'
abbr -a gcls  'git clone --depth=1 --shallow-submodules --recursive'

# abbr -a t  'todo'
# abbr -a l  'todo list'
# abbr -a ta 'task add'
# abbr -a td 'task done'
# abbr -a tl 'task ready'

abbr -a y  'yadm status'
abbr -a ya 'yadm add'
abbr -a yd 'yadm diff'
abbr -a yp 'yadm push'
abbr -a yc 'yadm commit -m'

# typo correction
abbr -a sl ls

# Variables

set -x NOTES_DIR ~/Obsidian
set -x CAPTURE_FILE "$NOTES_DIR/Captures.md"
set -x TODO_FILE "$NOTES_DIR/todo.txt"

set -x EDITOR  "hx"
set -x PATH    ~/.local/bin/ ~/go/bin/ \
    ~/.cargo/bin/ ~/.pub-cache/bin/ \
    ~/.local/share/gem/ruby/3.0.0/bin \
    ~/Flutter/flutter/bin/ \
    $PATH
set -x BROWSER /usr/bin/firefox
set -x VIM_CONFIG_PATH ~/.config/nvim/
set -x ANDROID_SDK_ROOT ~/Android
set -x ANDROID_HOME $ANDROID_SDK_ROOT
set -x PATH \
    $ANDROID_HOME/cmdline-tools/latest/bin/ \
    $ANDROID_HOME/cmdline-tools/latest/ \
    $ANDROID_HOME/cmdline-tools/ \
    $ANDROID_HOME/emulator/ \
    $ANDROID_HOME/platform-tools/ \
    $ANDROID_HOME/kotlin-language-server/bin/ \
    $PATH

set -x RUST_BACKTRACE 1
set -x SXHKD_SHELL "/bin/bash"

set -x F_EXCLUDE '^/tmp/.+' '\.out$'

set __done_exclude $__done_exclude zathura feh

set -x Z_CMD "j"

set -x ZK_NOTEBOOK_DIR ~/zetnotes/

set -x NNN_FIFO /tmp/nnn.fifo
# prepended with - to prevent directory refreshing after running plugin
# appended with * to discard output (do not show press enter to continue prompt)
set -x NNN_PLUG 'y:-!echo -n "$nnn" | xclip -sel clip*;p:preview-tui;P:preview-tabbed'
set -x NNN_OPTS "ePp"

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
fzf_configure_bindings --directory=\co

# pnpm
set -gx PNPM_HOME "/home/gokul/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end