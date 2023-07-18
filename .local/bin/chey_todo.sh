#!/bin/bash

if [ "$1" = "capture" ]; then
  todo=$(zenity --entry --text 'Add todo')
else
  echo "Invalid usage. Usage: chey_capture.sh capture"
  exit 1
fi

if [ "$todo" = "" ]; then
  exit 1
fi

echo "[ ] $todo" >> $TODO_FILE
notify-send "Todo created" "$todo"
