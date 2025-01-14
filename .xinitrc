#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xset r rate 250 25

# redshift &
# start-pulseaudio-x11 &
# libinput-gestures-setup start &

# polybar -r main &
# xsetroot -cursor_name left_ptr &  # set default cursor for root window
# picom --experimental-backends &  # jonaburg's fork
# feh --bg-fill $(find ~/Pictures/colors/ -type f | shuf -n1) &

# export _JAVA_AWT_WM_NONREPARENTING=1
# wmname LG3D

# exec bspwm

export DESKTOP_SESSION=plasma
exec startplasma-x11
