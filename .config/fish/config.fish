# Fish Config File

# X

if [ -z $DISPLAY ] && [ (tty) = /dev/tty1 ]
    exec startx
end

# Keybindings

set fish_cursor_default     block
set fish_cursor_insert      line
set fish_cursor_replace_one underscore

# Add a way to switch from insert to normal (command) mode.
# Note if we are paging, we want to stay in insert mode
# See #2871 in fish-shell github issues
bind -M insert -e \e

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
bind -M insert \e,    up-or-search
bind -M insert \e\<   down-or-search
bind -M insert "<>"   pathget-key
bind -M insert "><"   paste-path-from-prev-command
bind -M insert \e3    __fzf_reverse_isearch
bind -M insert \e-    'commandline -i ~/.config/'
bind -M insert \eo    __fish_preview_current_file

# Abbreviations

abbr -a -g u 'upto'

abbr -a -g fs 'funcsave'

abbr -a -g wd 'wget -q --show-progress'
abbr -a -g xc 'xclip -sel clip'

abbr -a -g ga   'git add'
abbr -a -g gl   'git log'
abbr -a -g gb   'git branch'
abbr -a -g gs   'git status'
abbr -a -g gc   'git commit -m'
abbr -a -g gd   'git diff --word-diff=color'
abbr -a -g gco  'git checkout'
abbr -a -g gsp  'git stash pop'
abbr -a -g gca  'git commit -am'
abbr -a -g gcam 'git commit --amend'
abbr -a -g gss  'git stash push --include-untracked --message'
abbr -a -g gcl  'git clone --depth=1'
abbr -a -g gcls 'git clone --depth=1 --shallow-submodules --recursive'

abbr -a -g pa  'pluck add'
abbr -a -g pg  'pluck export | grep'
abbr -a -g pgp 'pluck export | grep \#'

abbr -a -g t  'task'
abbr -a -g ta 'task add'
abbr -a -g td 'task done'
abbr -a -g tl 'task list'

abbr -a -g y  'yadm status'
abbr -a -g ya 'yadm add'
abbr -a -g yd 'yadm diff'
abbr -a -g yp 'yadm push'
abbr -a -g yc 'yadm commit -m'

# Variables

set -x EDITOR  "nvim"
set -x PATH    ~/.local/bin/ ~/go/bin/ $PATH
set -x BROWSER /mnt/MyStuff/Downloads/firefox/firefox

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

# Fisher

if not functions -q fisher
    echo -n "Installing fisher...\n"
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set -g fisher_path ~/.config/fish/fisher

set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2> /dev/null
end

# Disable ^R for fzf; alt-3 already bound
# These commands must be run after the fzf plugin is loaded
bind -e \cr
bind -M insert -e \cr
