function toggle-comment
    if test (commandline -b | string collect) = ""
        commandline -r (history search -p "#" -z | read -z | string collect)
    end
    __fish_toggle_comment_commandline
end
