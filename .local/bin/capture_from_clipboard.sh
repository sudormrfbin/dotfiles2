#!/bin/bash
# Get the current date and time in "9 Jul 12:06 pm" format
datetime=$(date +"%-e %b %-l:%M %P")

# Set the capture source based on the argument
if [ "$1" = "clipboard" ]; then
    content=$(xclip -selection clipboard -o)
    source="Clipboard"
elif [ "$1" = "primary" ]; then
    content=$(xclip -selection primary -o)
    source="Mouse Selection"
elif [ "$1" = "manual" ]; then
    content=$(zenity --entry --text 'Add capture')
    source="Manual"
else
    echo "Invalid source. Usage: $0 manual|clipboard|primary"
    exit 1
fi

[ "$content" = "" ] && notify-send -u low "Capture Not Saved" "Empty capture content" && exit

content_with_datetime="\n$datetime\n\n$content\n\n----"

echo -ne "$content_with_datetime" >> "$CAPTURE_FILE" || notify-send -u critical "Capturing failed"
notify-send "$source Capture" "$content"

exit 0
