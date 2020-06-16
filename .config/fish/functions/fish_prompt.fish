# Defined in /tmp/fish.vG9G6L/fish_prompt.fish @ line 2
function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    set -l normal (set_color normal)
    set -l color_suffix (set_color normal)
    # cannot directly check $status because it will have status of command just above
    if test $last_status -ne 0
        set color_suffix (set_color red)
    end

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix '>'
    if contains -- $USER root toor
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    echo -n -s (set_color $color_cwd) (prompt_pwd) $color_suffix $suffix $normal " "
end
