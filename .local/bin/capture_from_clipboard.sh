#!/bin/bash
# Get the current date and time in "9 Jul 12:06 pm" format
datetime=$(date +"%-e %b %-l:%M %P")

# Set the selection source based on the argument
if [ "$1" = "clipboard" ]; then
    selection="-selection clipboard"
    source="Clipboard"
elif [ "$1" = "primary" ]; then
    selection="-selection primary"
    source="Mouse Selection"
else
    echo "Invalid selection source. Please use either 'clipboard' or 'primary' as the argument."
    exit 1
fi

# Get the clipboard contents using xclip with the specified selection source
clipboard=$(xclip $selection -o)

content_with_datetime="\n$datetime\n\n$clipboard\n\n----"

# Append clipboard contents with date and time to the Markdown file
echo -ne "$content_with_datetime" >> "$CAPTURE_FILE" || notify-send -u critical "Capturing failed"

# Send desktop notification with the captured contents
notify-send "$source Capture" "$clipboard"

exit 0
