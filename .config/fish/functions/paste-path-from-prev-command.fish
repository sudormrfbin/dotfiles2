# Defined in /tmp/fish.sD1SCf/paste-path-from-prev-command.fish @ line 2
function paste-path-from-prev-command
	set -l file ( $history[1] | path-extractor | fzf )
    commandline -a "$file "
    commandline -f end-of-line
    commandline -f repaint
end
