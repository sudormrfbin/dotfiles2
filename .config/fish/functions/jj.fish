function jj
    test -n "$argv"
    # split on all spaces because quoted values do not produce results in z
    or set -l argv (history search --prefix -n1 'j ' | string split ' ')[2..-1]
    # z sends the common directory component to stderr
    cd (j -l $argv 2>/dev/null | tr -s ' ' | cut -f2 -d' ' | fzf)
end
