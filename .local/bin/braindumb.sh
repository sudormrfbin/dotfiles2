#!/bin/bash
# deps: dmenu taskwarrior jq

dmenucmd='dmenu -fn mononoki-14 -i'

# https://stackoverflow.com/questions/46131727/printing-multiple-values-on-the-same-line
# https://stackoverflow.com/questions/28164849/using-jq-to-parse-and-display-multiple-fields-in-a-json-serially
# https://stackoverflow.com/questions/34834519/how-do-i-select-multiple-fields-in-jq

tasklist=$(task +braindump +READY export | jq -r '.[] | "\(.id) ▪ \(.description)"')

if selected=$(echo "$tasklist" | $dmenucmd -l $(echo "$tasklist" | wc -l))
then
    if id=$(echo $selected | grep -oP '^\d+')
    then
        # selected an old item; mark as completed
        task done $id
    else
        # typed in a new item; add it to list
        task add +braindump "$selected"
    fi
fi
