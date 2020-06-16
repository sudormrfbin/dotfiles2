# Modified from __fish_paginate
function fish_paginate --description 'Paginate current command using default pager'

    set -l colored_cmds grep ls
    set -l cmd "less -R"
    if set -q PAGER
        echo $PAGER | read -at cmd
    end

    if test -z (commandline -j | string join '')
        commandline -a $history[1]
    end

    if commandline -j | string match -q -r -v "$cmd *\$"

        # get last command on the command line
        set -l cursor_pos (commandline -C)
        commandline -C 999999
        set -l last_cmd (commandline -op)[1]
        commandline -C $cursor_pos

        if contains -- $last_cmd $colored_cmds
            commandline -aj " --color=always"
        end

        commandline -aj " &| $cmd"
    end
end
