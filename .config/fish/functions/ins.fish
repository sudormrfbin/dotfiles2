# Defined in - @ line 1
function ins --description 'alias ins=sudo apt install' -w "apt install"
    sudo apt install $argv
end
