function ll --wraps=locate
    set -l files (locate $argv | fzf --multi --prompt "Open: " | string escape -n $paths)
    or return 0
    commandline -r (printf '%s ' $EDITOR $files)
    commandline -f execute
end
