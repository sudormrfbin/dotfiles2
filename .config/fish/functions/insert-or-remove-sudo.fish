function insert-or-remove-sudo
  if string match "" (commandline) > /dev/null
    commandline "sudo $history[1]"
  else if string match -r "^sudo" (commandline) > /dev/null
    commandline (string replace -r "^sudo " "" (commandline))
  else
    commandline "sudo "(commandline)
  end
end
