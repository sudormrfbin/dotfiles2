function ll --wraps=locate --wraps=ls
    locate $argv | fzf --bind "enter:execute(vim {+})" --multi --prompt "Open: "
end
