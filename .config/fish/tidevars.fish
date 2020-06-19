# DO NOT SOURCE DIRECTLY
exit 1
# tide bug-report | sed 's/^/set -U /' > /home/gokul/.config/fish/tidevars.fish
set -U tide_newline true
set -U tide_prompt_connection_color 6C6C6C
set -U tide_prompt_connection_icon ─
set -U tide_left_prompt_items pwd git_prompt newline prompt_char
set -U tide_right_prompt_items status cmd_duration context jobs
set -U tide_prompt_char_success_color 5FD700
set -U tide_prompt_char_failure_color F73555
set -U tide_prompt_char_icon ❯
set -U tide_pwd_truncate_margin 10
set -U tide_pwd_unwritable_icon 
set -U tide_pwd_max_dirs 0
set -U tide_pwd_anchors first last git
set -U tide_pwd_color_anchors 00AFFF
set -U tide_pwd_color_dirs 0087AF
set -U tide_pwd_color_truncated_dirs 8787AF
set -U __fish_git_prompt_show_informative_status true
set -U __fish_git_prompt_showstashstate true
set -U __fish_git_prompt_char_stateseparator 
set -U __fish_git_prompt_char_cleanstate 
set -U __fish_git_prompt_char_upstream_ahead  ⇡
set -U __fish_git_prompt_char_upstream_behind  ⇣
set -U __fish_git_prompt_char_stagedstate  +
set -U __fish_git_prompt_char_dirtystate  !
set -U __fish_git_prompt_char_untrackedfiles  ?
set -U __fish_git_prompt_char_stashstate  *
set -U __fish_git_prompt_color_branch 5FD700
set -U __fish_git_prompt_color_upstream 5FD700
set -U __fish_git_prompt_color_stagedstate D7AF00
set -U __fish_git_prompt_color_dirtystate D7AF00
set -U __fish_git_prompt_color_untrackedfiles 00AFFF
set -U __fish_git_prompt_color_stashstate 5FD700
set -U tide_status_success_icon ✔
set -U tide_status_success_color 5FAF00
set -U tide_status_failure_icon ✘
set -U tide_status_failure_color F73555
set -U tide_cmd_duration_color 87875F
set -U tide_cmd_duration_decimals 0
set -U tide_cmd_duration_threshold 3000
set -U tide_context_ssh_color D7AF87
set -U tide_context_root_color D7AF00
set -U tide_jobs_icon 
set -U tide_jobs_color 5FAF00
set -U tide_time_color 5F8787
set -U tide_time_format %r
