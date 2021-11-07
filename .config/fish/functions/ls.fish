# Defined via `source`
function ls --wraps='exa --icons --classify --color-scale --group-directories-first' --description 'alias ls exa --icons --classify --color-scale --group-directories-first'
  exa --icons --classify --color-scale --group-directories-first $argv; 
end
