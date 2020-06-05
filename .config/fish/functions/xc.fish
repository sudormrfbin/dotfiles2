function xc --description 'Copy piped input or argument to clipboard'
    if isatty stdin
        # *not* a pipe or redirection
        if test -z "$argv"  # no args
            echo $history[1] | xclip -selection clipboard
        else
            echo -n $argv | xclip -selection clipboard
        end
    else
        cat - | xclip -selection clipboard
    end
end
