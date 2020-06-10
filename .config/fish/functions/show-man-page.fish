function show-man-page
    if test (commandline) = ""
        commandline -r $history[1]
        __fish_man_page
        commandline -r ""
        commandline -f repaint
    else if test (commandline -o)[1] = sudo
        man (commandline -o)[2]
    else
        __fish_man_page
    end
end
