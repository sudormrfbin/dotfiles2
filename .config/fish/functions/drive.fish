function drive -w drive
    pushd ~/gdrive >/dev/null
    command drive $argv
    popd >/dev/null
end
