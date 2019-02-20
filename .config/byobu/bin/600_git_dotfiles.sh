#!/bin/sh

DISP="⌥ ⋅"

cd ~/.dotfiles

if ! git diff-index --quiet HEAD
then
        echo $DISP

elif ! git diff-index --quiet origin/master
then
        echo $DISP
fi
