# Defined in - @ line 1
function gd --description 'alias gd=git diff --word-diff=color' -w "git diff"
	git diff --word-diff=color $argv;
end
