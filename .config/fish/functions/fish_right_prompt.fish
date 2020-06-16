function fish_right_prompt
    set -l last_pipestatus $pipestatus
    set -l last_status $status
    # Write pipestatus
    set -l prompt_status (__fish_print_pipestatus $last_status " [" "]" "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus)

    echo -n -s $prompt_status (fish_vcs_prompt)
end
