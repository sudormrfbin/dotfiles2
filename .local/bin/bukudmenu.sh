#!/bin/bash

dmenucmd='dmenu -fn mononoki-14 -i'
notifycmd='notify-send -u low -t 1000'  # low priority, 1 second
bukudb="$HOME/.local/share/buku/bookmarks.db"

function open-bookmark {
    # adapted from: https://gitlab.com/benoliver999/buku-dmenu
    # using buku to print urls is slow; directly access the database
    sqlite3 -separator ' ▪ ' "$bukudb" 'select id, url, metadata, desc from bookmarks' |
        $dmenucmd -i -l 10 |          # case insensitive, vertical
        cut -d ' ' -f 1 |             # select url index
        xargs --no-run-if-empty buku -o
}

url=$(xclip -o -selection clipboard)  # could be other copied text

if echo "$url" | grep -E '^\w+://' > /dev/null 2>&1  # check if url
then
    # text in clipboard is a url; prompt to bookmark

    # full urls are usually long, so use domain name in prompt
    prompt="Bookmark $(echo "$url" | cut -d/ -f3)"

    # echo -n to have dmenu show no selection items
    if bukuargs=$(echo -n | $dmenucmd -p "$prompt")
    then
        bukuoutput=$(buku --nc --add "$url" "$bukuargs")
        $notifycmd 'Bookmark addded' "'$bukuoutput'"
    else
        # esc or ctrl-c
        # user might've wanted to open a bookmark, but clipboard had a url
        open-bookmark
    fi
else
    open-bookmark
fi
