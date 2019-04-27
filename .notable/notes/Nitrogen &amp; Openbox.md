---
title: Nitrogen &amp; Openbox
created: '2019-02-22T12:32:15.284Z'
modified: '2019-02-22T15:44:18.711Z'
tags: [bugs, bunsenlabs]
---

# Nitrogen & Openbox

## Wallpaper set using nitrogen is not persistent

Delete the following lines in `~/.config/nitrogen/bg-saved.cfg` after setting the wallpaper using gui:
```ini
[xin_-1]
file=/usr/share/images/bunsen/wallpapers/default/BL-beam.png
mode=5
bgcolor=#001e44
```

Then replace `[:0.0]` with `[xin_-1]`.

## Restart Openbox

`openbox --reconfigure`
