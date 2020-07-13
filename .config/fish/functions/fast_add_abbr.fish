# See config.fish for note
function fast_add_abbr --argument abbr_name abbr_value
    set -g _fish_abbr_$abbr_name $abbr_value
end
