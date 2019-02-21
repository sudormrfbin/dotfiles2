# Fish Config File

# ---------- Keybindings

bind \e/ toggle-comment  # Alt-/
bind -k ic __fish_man_page  # Insert
bind "`" accept-autosuggestion
bind "L:" "commandline -a '| less'"
bind \x1B\x1B insert-or-remove-sudo  # Esc-Esc

# ---------- Variables

set -x EDITOR "nvim"
set -x PATH ~/.local/bin/ $PATH

set -x Z_CMD "j"
set -x FZF_LEGACY_KEYBINDINGS 0

set -x LESS_TERMCAP_ue (printf "\e[0m")
set -x LESS_TERMCAP_me (printf "\033[0m")
set -x LESS_TERMCAP_se (printf "\033[0m")
set -x LESS_TERMCAP_us (printf "\e[01;32m")
set -x LESS_TERMCAP_mb (printf "\033[01;31m")
set -x LESS_TERMCAP_md (printf "\033[01;31m")
set -x LESS_TERMCAP_so (printf "\033[00;47;30m")
