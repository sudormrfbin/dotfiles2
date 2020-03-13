function ee -d 'Stage changes to dotfiles'
    pushd $HOME

    set file (
                yadm diff --name-only |
                fzf --preview="yadm diff --color {}" --height=100% --multi --prompt="Stage: "
            )
    if test -n "$file"
        yadm add $file
        yadm diff --name-status --cached
    end

    popd
end
