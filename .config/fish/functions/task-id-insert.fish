function task-id-insert
    commandline -i (
        task rc.verbose:nothing \
           rc.report.fzf.columns:id,project,description.truncated \
           rc.report.fzf.sort:entry- \
           rc.report.fzf.filter:status:pending fzf |
        fzf | awk '{ print $1 }'
    )
    commandline -f repaint
end
