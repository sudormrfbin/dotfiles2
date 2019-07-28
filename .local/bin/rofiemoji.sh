#!/bin/sh

# Modified from https://github.com/nkoehring/rofiemoji

URL="https://raw.githubusercontent.com/Mange/rofi-emoji/master/all_emojis.txt"
DIR="$HOME/.local/share"
FILE="$DIR/emoji.txt"

if [ ! -r $FILE ]
then
  if [ ! -d $DIR ]; then mkdir $DIR; fi
  curl $URL | cut -f1,4,5 --output-delimiter ' ' > $FILE
fi

if [ "$@" ]
then
  smiley=$(echo $@ | cut -d' ' -f1)
  echo -n "$smiley" | xsel -bi
  exit 0
fi

cat $FILE
