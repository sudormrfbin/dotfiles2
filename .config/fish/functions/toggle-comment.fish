function toggle-comment
	if test (commandline) = ""
commandline -r (history search -p "#")[1]
end
__fish_toggle_comment_commandline 
end
