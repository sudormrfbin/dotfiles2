#!/bin/bash

pushd $HOME/gdrive/
pluck export > Pluckeye/pluckeye.plu
drive push -quiet -no-prompt Linux\ Notes Bookmarks Pluckeye
popd

yadm push
