function gclt -d 'Git shallow clone a repo to /tmp and cd to it'
    if not string match -qr '^https://' $argv
        set argv (string join '' 'https://github.com/' $argv)
    end
    set repo (string split -rm 1 '/' "$argv")[2]
    git clone --depth 1 $argv "/tmp/$repo"
    cd "/tmp/$repo"
end
