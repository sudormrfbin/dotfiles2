# Defined in - @ line 1
function ls --description 'alias ls=ls -hp --color=auto --group-directories-first' -w 'ls'
	command ls -hp --color=auto --group-directories-first $argv;
end
