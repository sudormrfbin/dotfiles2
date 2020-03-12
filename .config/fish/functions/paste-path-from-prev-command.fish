# Defined in /tmp/fish.sD1SCf/paste-path-from-prev-command.fish @ line 2
function paste-path-from-prev-command
	set -l file ( eval $history[1] | path-extractor | fzf --multi )
    if test -n "$file"  # quoting is necesssary
        commandline -a "$file "
        commandline -f end-of-line
    end
    commandline -f repaint
end
