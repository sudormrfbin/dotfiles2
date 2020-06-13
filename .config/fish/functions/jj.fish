function jj
    test -n "$argv";
        or set -l argv (history search --prefix -n1 'j ' | string split -m1 ' ')[2]
    # z sends the common directory component to stderr
    cd (j -l $argv 2>/dev/null | tr -s ' ' | cut -f2 -d' ' | fzf)
end
