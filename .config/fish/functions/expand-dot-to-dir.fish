# https://github.com/fish-shell/fish-shell/issues/1891#issuecomment-71141210
function expand-dot-to-dir --description 'expand ... to ../.. etc'
    # Get commandline up to cursor
    set -l cmd (commandline --cut-at-cursor)

    # Match last line
    switch $cmd[-1]
        case '*..'
            commandline --insert '/..'
        case '*'
            commandline --insert '.'
    end
end
