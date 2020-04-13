#!/bin/bash

pushd $HOME/gdrive/
drive push -quiet -no-prompt Linux\ Notes Bookmarks
popd

yadm push
