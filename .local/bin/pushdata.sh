#!/bin/bash
# deps: pluckeye yadm drive gpg

pushd $HOME/gdrive/
pluck export > Backups/Pluckeye/pluckeye.plu
gpg -o Backups/fish_history --encrypt -r gokul --yes ~/.local/share/fish/fish_history
drive push -quiet -no-prompt Backups
popd

yadm push
