#!/bin/bash
# deps: pluckeye yadm drive gpg task

pushd $HOME/gdrive/
pluck export > Backups/Pluckeye/pluckeye.plu
gpg -o Backups/fish_history --encrypt -r gokul --yes ~/.local/share/fish/fish_history
task export | gpg -o Backups/taskwarrior --encrypt -r gokul --yes
drive push -quiet -no-prompt Backups
popd

yadm push
