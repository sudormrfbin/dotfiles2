#!/bin/sh

# Requires: xprop, wmctrl, xdotool

bspwm_nav() {
  case "$1" in
    "down")
      bspc node --focus next.local.!hidden.window
      ;;
    "up")
      bspc node --focus prev.local.!hidden.window
      ;;
    "left")
      bspc node --focus west
      ;;
    "right")
      bspc node --focus east
      ;;
  esac
}

log() {
  notify-send -u normal -t 2000 "$1"
}

TERMINAL_CLASS="kitty"
KITTY_LISTEN_FILE="/tmp/kitty"
direction="$1"

focused_window=$(xdotool getwindowfocus)
xprop WM_CLASS -id "$focused_window" | grep "$TERMINAL_CLASS"
term_is_focused=$?

if [ $term_is_focused -eq 0 ]; then
  term_pid=$(xdotool getwindowpid "$focused_window")
  listen_file="$KITTY_LISTEN_FILE-$term_pid"

  kitty @ --to "unix:$listen_file" kitten winnav.py "$direction" 2> /dev/null

  if [ $? -ne 0 ]; then
    bspwm_nav "$direction"
  fi
else
  bspwm_nav "$direction"
fi