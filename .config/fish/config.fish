# Fish Config File

# X

if [ -z $DISPLAY ] && [ (tty) = /dev/tty1 ]
    startx
end

# Keybindings

bind \e/ toggle-comment  # Alt-/
bind -k ic show-man-page  # Insert
bind "`" power-key
bind "L:" "commandline -a ' --color=always| less -R'"
bind \e1 forward-word
bind \x1B\x1B insert-or-remove-sudo  # Esc-Esc
bind \e, up-or-search
bind "<>" pathget-key
bind "><" paste-path-from-prev-command

# Variables

set -x EDITOR "nvim"
set -x PATH ~/.local/bin/ ~/go/bin/ $PATH

set -x Z_CMD "j"
set -x FZF_LEGACY_KEYBINDINGS 0
set -x FZF_DEFAULT_OPTS '--bind "ctrl-c:execute-silent(echo -n {} | xclip -selection clipboard)+abort"'

set -x LESS_TERMCAP_ue (printf "\e[0m")
set -x LESS_TERMCAP_me (printf "\033[0m")
set -x LESS_TERMCAP_se (printf "\033[0m")
set -x LESS_TERMCAP_us (printf "\e[01;32m")
set -x LESS_TERMCAP_mb (printf "\033[01;31m")
set -x LESS_TERMCAP_md (printf "\033[01;31m")
set -x LESS_TERMCAP_so (printf "\033[00;47;30m")

set SPACEFISH_PROMPT_ORDER dir exec_time line_sep exit_code char

# Fisher

set -g fisher_path ~/.config/fish/fisher

set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2> /dev/null
end
