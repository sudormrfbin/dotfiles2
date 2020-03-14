# Defined in - @ line 1
function upd --description 'alias upd=sudo apt update' -w 'apt update'
	sudo apt update $argv;
end
