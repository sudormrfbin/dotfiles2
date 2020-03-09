function pathget-key
	if test (commandline) = ""
commandline -r $history[1]
end
commandline -a ' | path-extractor | fzf --bind "enter:execute(vim {})"'
end
