function mpsyt --description 'Restart mpsyt after clearing cache if it fails to start'
    command mpsyt $argv
    if [ $status -ne 0 ]
        rm ~/.config/mps-youtube/cache_py_*
        command mpsyt $argv
    end
end
