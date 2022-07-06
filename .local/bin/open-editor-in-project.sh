#!/usr/bin/env bash

frecedb="${XDG_CACHE_HOME:-$HOME/.cache}/projects-frece.txt"

project="$(frece print $frecedb | fzf)"

# if fzf is cancelled open a shell
[ $? -ne 0 ] && exec $SHELL

project_path="${project/#\~/$HOME}" # expand tilde to HOME
[ -d "$project_path" ] && frece increment "$frecedb" "$project" && cd "$project_path" && exec $EDITOR
