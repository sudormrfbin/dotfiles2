function show-man-page
    if test (commandline) = ""
        commandline -r $history[1]
        __fish_man_page
        commandline -r ""
        commandline -f repaint
    else
        __fish_man_page
    end
end
