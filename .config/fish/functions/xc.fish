function xc --description 'Copy piped input or argument to clipboard'
    if isatty stdin
        # not a pipe or redirection
        echo -n $argv | xclip -selection clipboard
    else
        cat - | xclip -selection clipboard
    end
end
