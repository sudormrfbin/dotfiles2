function power-key
    if test (commandline) = "  "
        history merge
        commandline -r ""
    else if test (commandline) = ""
        __fzf_reverse_isearch
    else if test (commandline) = " "
        commandline -r $history[1]
    else
        commandline -f accept-autosuggestion
    end
end
