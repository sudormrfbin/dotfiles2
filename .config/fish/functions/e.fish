# Defined in /tmp/fish.9yscR3/e.fish @ line 2
function e
	set -l file (frece print ~/.cache/yadm-files.txt | fzf)
        if test ! $file = ""
                frece increment /home/gokul/.cache/yadm-files.txt $file
                $EDITOR $file
        end
end
