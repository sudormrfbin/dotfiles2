function n
    set -l selection (command ls ~/notes/ | fzf --print-query --preview="cat $HOME/notes/{}" --height=100%)
    if test $status -eq 130
        return 1 # exit by esc or ctrl-c
    end
    if test -n "$selection[2]" # file exists
        nvim "$HOME/notes/$selection[2]"
    else
        nvim "$HOME/notes/$selection[1].md" # use query as filename
    end
end
