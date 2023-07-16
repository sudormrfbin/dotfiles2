function n
    set -l NDIR "$HOME/Obsidian/"
    set -l output (fd . --base-directory "$NDIR" | fzf --print-query --preview="bat {}")

    if test $status -eq 130
        return 1 # exit by esc or ctrl-c
    end

    set -l query "$output[1]"
    set -l selected "$output[2]"

    if test -n "$selected" # file exists
        $EDITOR "$NDIR/$selected"
    else
        $EDITOR "$NDIR/$query.md" # use query as filename
    end
end
