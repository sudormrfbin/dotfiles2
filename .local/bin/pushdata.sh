#!/bin/bash

pushd $HOME/gdrive/
pluck export > Backups/Pluckeye/pluckeye.plu
drive push -quiet -no-prompt Backups
popd

yadm push
