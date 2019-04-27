---
title: Slow Bootups
created: '2019-02-22T15:29:50.559Z'
modified: '2019-04-27T05:10:06.254Z'
tags: [bunsenlabs, linux, speedup]
---

# Slow Bootups

- `sudo systemctl disable apt-daily-upgrade.timer apt-daily.timer`

Performs apt update and upgrade; not required if system is manually updated often

- `sudo systemctl disable NetworkManager-wait-online.service`

From [askubuntu](https://askubuntu.com/questions/1018576/what-does-networkmanager-wait-online-service-do):

> In some multi-user environments the part of the boot-up process can come from the network. For this case systemd defaults to waiting for the network to come on-line before certain steps are taken.

Hence not required for majority of desktop users.

- Uninstall graphical display manager like lightdm and login using tty

X will have to started manually using the `startx` command, instead add the following to `~/.profile` (file executed in login shells):

```sh
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
startx
fi
```

If fish shell is the default login shell, add this to `~/.config/fish/config.fish`:

```fish
if [ -z $DISPLAY ] && [ (tty) = /dev/tty1 ]
    startx
end
```

- Run `sudo dmesg --color=always | less -R` and inspect time differences.

If this error is shown:

`[drm:drm_atomic_helper_commit_cleanup_done [drm_kms_helper]] *ERROR* [CRTC:26:pipe A] flip_done timed out`

(from [askubuntu](https://askubuntu.com/questions/893817/boot-very-slow-because-of-drm-kms-helper-errors)):  

open `/etc/default/grub` and append `video=SVIDEO-1:d` to `GRUB_CMDLINE_LINUX_DEFAULT`. If the problem persists, remove the package `xserver-xorg-video-intel` (may introduce screen tearing)
