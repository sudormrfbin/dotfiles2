unbind-key -n C-a
set -g prefix ^A
set -g prefix2 ^A
bind a send-prefix

unbind -n S-Up
unbind -n S-Down
unbind -n S-Right
unbind -n S-Left

bind -n F5 select-pane -L
bind -n F6 select-pane -D
bind -n F7 select-pane -U
bind -n F8 select-pane -R

bind -n F10 command-prompt -p "(rename-window) " "rename-window '%%'"
bind -n F12 copy-mode

bind -n S-F5 source $BYOBU_PREFIX/share/byobu/profiles/tmuxrc
bind -n C-S-F9 new-window -k -n config byobu-config

