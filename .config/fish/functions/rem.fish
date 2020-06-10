# Defined in - @ line 1
function rem --description 'alias rem=sudo apt remove' -w "apt remove"
    sudo apt remove $argv
    sudo apt autoremove -y
end
