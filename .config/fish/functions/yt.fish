# Defined in - @ line 1
function yt --wraps='youtube-dl -f bestaudio -x --audio-format mp3 -o "%(title)s.%(ext)s"' --description 'alias yt youtube-dl -f bestaudio -x --audio-format mp3 -o "%(title)s.%(ext)s"'
  youtube-dl -f bestaudio -x --audio-format mp3 -o "%(title)s.%(ext)s" $argv;
end
