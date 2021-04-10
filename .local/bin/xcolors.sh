#!/bin/sh
# https://gist.github.com/bohoomil/4182181

colors=($(xrdb -query | sed -n 's/.*color\([0-9]\)/\1/p' | sort -nu | cut -f2))
names=(black red green yellow blue magenta cyan white)

echo

for i in {0..7}; do
    echo -en "\e[$((30+$i))m █ ${colors[i]} color$i ${names[i]}\e[0m \n"
done

echo

for i in {8..15}; do
    echo -en "\e[1;$((22+$i))m █ ${colors[i]} color$i bright${names[(i-8)]}\e[0m \n"
done
