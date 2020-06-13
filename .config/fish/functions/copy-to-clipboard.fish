function copy-to-clipboard
    # From fish_clipboard_copy
    # Copy the current selection, or the entire commandline if that is empty.
    # If commandline itself is empty, copy previous command
    set -l cmdline (commandline --current-selection | string collect)
    test -n "$cmdline"; or set cmdline (commandline | string collect)
    test -n "$cmdline"; or set cmdline "$history[1]"
    if type -q pbcopy
        printf '%s' $cmdline | pbcopy
    else if set -q WAYLAND_DISPLAY; and type -q wl-copy
        printf '%s' $cmdline | wl-copy
    else if type -q xsel
        # Silence error so no error message shows up
        # if e.g. X isn't running.
        printf '%s' $cmdline | xsel --clipboard 2>/dev/null
    else if type -q xclip
        printf '%s' $cmdline | xclip -selection clipboard 2>/dev/null
    end
end
