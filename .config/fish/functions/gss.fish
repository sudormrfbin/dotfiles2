# Defined in - @ line 1
function gss --description 'alias gss=git stash push --include-untracked --message'
	git stash push --include-untracked --message $argv;
end
