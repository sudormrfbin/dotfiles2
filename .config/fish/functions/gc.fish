# Defined in - @ line 1
function gc --description 'alias gc=git commit -m' -w "git commit -m"
	git commit -m $argv;
end
