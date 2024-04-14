# Defined via `source`
function ls --wraps='eza --icons --classify --color-scale --group-directories-first' --description 'alias ls exa --icons --classify --color-scale --group-directories-first'
  eza --icons --classify --color-scale --group-directories-first --hyperlink $argv; 
end
