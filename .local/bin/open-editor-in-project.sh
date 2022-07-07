#!/usr/bin/env bash

FRECE_DB="${XDG_CACHE_HOME:-$HOME/.cache}/projects-frece.txt"
PROJECTS_DIR="$HOME/Projects"

list-projects() {
    find "$PROJECTS_DIR" -maxdepth 1 -mindepth 1 -type d
}

refresh-projects-list() {
    frece update --purge-old $FRECE_DB <(list-projects)
}

refresh-projects-list-in-fzf() {
    refresh-projects-list
    frece print $FRECE_DB
}

pick-project() {
    rebind_cmd="ctrl-r:reload($0 --refresh-projects)"
    project="$( \
        frece print $FRECE_DB | \
        # XXX: THIS WILL BREAK IF $PROJECTS_DIR CHANGES
        cut -d/ -f5 | \
        fzf --header 'ctrl-r to reload' \
            --bind "$rebind_cmd" \
            # --expect ctrl-e \
            # ctrl-e signals to edit in helix
    )"

    # if fzf is cancelled open a shell
    [ $? -ne 0 ] && exec $SHELL

    # IFS=\n read -r keybind project <<< "$output"
    # echo $project $editor
    # [ -z "$keybind" ] && editor=$EDITOR || editor=hx

    project="$PROJECTS_DIR/$project"
    # open-project "$project" "$editor"
    open-project "$project"

    # project_path="${project/#\~/$HOME}" # expand tilde to HOME
}

open-project() {
    project="$1"
    editor="${2:-$EDITOR}"

    [ -d "$project" ] && \
        frece increment "$FRECE_DB" "$project" && \
        cd "$project" && \
        exec $EDITOR
}

subcommand=$1
case $subcommand in
    "--refresh-projects")
        refresh-projects-list-in-fzf
        ;;
    "--open-project")
        open-project "$1" "$2"
        ;;
    *)
        pick-project
        ;;
esac

