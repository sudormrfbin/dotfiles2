function power-key
    set -l cmdline (commandline -b | string collect)
    if test "$cmdline" = "  "
        history merge
        commandline -r ""
    else if test "$cmdline" = ""
        __fzf_reverse_isearch
    else if test "$cmdline" = " "
        commandline -r $history[1]
    else
        commandline -f accept-autosuggestion
    end
end
