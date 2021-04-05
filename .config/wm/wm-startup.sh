#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run {
   if (command -v $1 && ! pgrep $1); then
     $@&
   fi
}

## run (only once) processes which spawn with different name
if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    start-pulseaudio-x11 &
fi

run libinput-gestures-setup start
run redshift
run setxkbmap -option ctrl:swapcaps
run xset r rate 250 25
# jonaburg's fork
run picom --experimental-backends
run polybar -r main
run feh --bg-fill $(find ~/Pictures/colors/ -type f | shuf -n1)
