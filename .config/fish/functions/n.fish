function n
    set -l output (fd . --base-directory "$NOTES_DIR" | fzf --print-query --preview="bat $NOTES_DIR/{}")

    if test $status -eq 130
        return 1 # exit by esc or ctrl-c
    end

    set -l query "$output[1]"
    set -l selected "$output[2]"

    if test -n "$selected" # file exists
        $EDITOR "$NOTES_DIR/$selected"
    else
        $EDITOR "$NOTES_DIR/$query.md" # use query as filename
    end
end
