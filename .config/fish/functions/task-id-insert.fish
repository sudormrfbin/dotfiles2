function task-id-insert
    set -l fzfcmd 'fzf --bind "alt-p:reload(task _unique project)"'
    printf $fzfcmd | read -at fzfcmd
    commandline -i (
        task rc.verbose:nothing \
           rc.report.fzf.columns:id,project,description.truncated \
           rc.report.fzf.sort:entry- \
           rc.report.fzf.filter:status:pending fzf |
        $fzfcmd | awk '{ print $1 }'
    )
    commandline -f repaint
end
