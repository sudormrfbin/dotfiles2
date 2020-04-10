#!/bin/bash

dmenucmd='dmenu -fn mononoki-14'

output=$(echo -e 'Yes\nNo' | $dmenucmd -p 'Shutdown')

if [ "$output" = 'Yes' ]
then
    systemctl poweroff
fi
