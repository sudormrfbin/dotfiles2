function yt --wraps='youtube-dl' -d 'download music from youtube in mp3'
    pushd /mnt/MyStuff/Music/New/NEW/
    youtube-dl -f bestaudio -x --audio-format mp3 -o "%(title)s.%(ext)s" $argv
    set -l filename (youtube-dl -f bestaudio -x --audio-format mp3 -o "%(title)s.%(ext)s" --get-filename $argv)
    set -l filename (echo -s (string split -r -m1 '.' $filename)[1] .mp3)
    ffplay $filename
    popd
end
