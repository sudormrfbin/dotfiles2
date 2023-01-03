#!/bin/sh

# Usage: toggle-win-visible.sh CLASS
#
# CLASS           Class of the window (from xprop WM_CLASS)

window_ids=( $(wmctrl -l -x | grep -E "^\w+[ ]+\w+ $1" | awk '{print $1}') )

if [ -n "${window_ids}" ]; then
    for wid in "${window_ids[@]}"; do
        wmctrl -i -r "$wid" -b toggle,hidden
    done
fi

