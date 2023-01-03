#!/bin/bash

wid=$1
title=$(xtitle "$wid")
# notify-send "$title"

# The window title changes to something similar to
# "Android Emulator - android-emulator:5554" after
# starting up, but initially it is simply titled "Emulator"
if [[ "$title" == 'Emulator' ]]; then
    # notify-send $wid \
    # echo state=pseudo_tiled

    # prevent toolbar from floating over windows when other
    # windows are maximized
    # echo layer=below

    echo state=floating

    # `-f WM_CLASS 8s` means that WM_CLASS is a sequence of
    # bytes (8) and that it is a string (s)
    xprop -id "$wid" -f WM_CLASS 8s -set WM_CLASS emulator
fi
