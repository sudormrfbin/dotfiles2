# Defined in - @ line 1
function upg --description 'alias upg=sudo apt full-upgrade' -w 'apt full-upgrade'
    sudo apt full-upgrade $argv
end
