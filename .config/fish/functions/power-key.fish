function power-key
        if test (commandline) = ""
                history merge
        else if test (commandline) = " "
                commandline -r (history)[1]
        else
                commandline -f accept-autosuggestion
        end
end
