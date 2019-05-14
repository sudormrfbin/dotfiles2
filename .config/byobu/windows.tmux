new-session -n dashboard -s new ;
set-window-option monitor-activity off ;

send-keys task Space list Enter ;

split-window -h -b -p 30 cmus ;

split-window -v -p 80 less /home/gokul/.cache/ly.txt ;

select-pane -t 2 ;
split-window -v htop ;

