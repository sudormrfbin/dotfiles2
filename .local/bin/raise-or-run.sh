#!/bin/sh

# Requires: xprop, wmctrl, xdotool

# Usage: raise-or-run.sh CLASS SPAWN_CMD [hide_if_focused=true]
#
# CLASS           Class of the window (from xprop WM_CLASS)
# SPAWN_CMD       Command to run if window is not found
# hide_if_focused Whether to hide the window if it is already focused

xprop WM_CLASS -id $(xdotool getwindowfocus) | grep $1
is_focused=$?

if [ $is_focused -eq 0 ] && [ "$3" == "hide_if_focused=true" ]; then
    # if window with CLASS has focus, hide it
    xdotool windowminimize $(xdotool getwindowfocus)
    # wmctrl -x -r "$1" -b add,hidden
elif xdotool search --limit 1 --class "$1"; then
    # else focus it

    # wmctrl
    # -r  specify window to act on
    # -x  interpret arg to -r as class name
    # -b  add or remove window properties

    # wmctrl -x -r "$1" -b remove,hidden
    # wmctrl -a "$1"
    IFS='\n' window_ids=( $(xdotool search --class "$1") )
    for wid in "${window_ids[@]}"; do
        xdotool windowstate --remove HIDDEN "$wid"

        # failed command does not return non-zero status code
        # so grep for a fail string
        xdotool windowactivate "$wid" 2>&1 | grep "failed"
        if [ "$?" -ne 0 ]; then
            break
        fi
    done
    # xdotool search --class "$1" windowstate --remove HIDDEN windowactivate
else
    # if there's no window with a matching CLASS, run SPAWN_CMD
    $2 &
fi
