#!/bin/bash

dmenucmd='dmenu -fn mononoki-15'

function open-bookmark {
    # credited to: https://gitlab.com/benoliver999/buku-dmenu
    buku --print --format=4 |  # show url, title, tags; refer -f option in buku
        sed 's/\t/ /g' 2>/dev/null |       # convert tabs to spaces
        $dmenucmd -i -l 10 |   # case insensitive, vertical
        cut -d ' ' -f 1 |      # select url index
        xargs --no-run-if-empty buku -o
}

url=$(xclip -o -selection clipboard)  # could be other copied text

if echo "$url" | grep -E '^\w+://' > /dev/null 2>&1  # check if url
then
    # text in clipboard is a url; prompt to bookmark

    # full urls are usually long, so use domain name in prompt
    prompt=$(echo "$url" | cut -d/ -f3)

    # echo -n to have dmenu show no selection items
    if bukuargs=$(echo -n | $dmenucmd -p "Bookmark $prompt")
    then
        bukuoutput=$(buku --nc --add "$url" "$bukuargs")
        notify-send 'Bookmark addded' "'$bukuoutput'"
    else
        # esc or ctrl-c
        # user might've wanted to open a bookmark, but clipboard had a url
        open-bookmark
    fi
else
    open-bookmark
fi
