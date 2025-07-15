#!/bin/sh

bookmark_file="${XDG_DATA_HOME}/bookmarks"
bookmark_selection=$(awk -F '##' '{print $1}' "$bookmark_file" | dmenu -i -l 10 -p "Select Bookmark:")
selected_url=$(grep "$bookmark_selection" "$bookmark_file" | awk -F '##' '{print $2}')

if [ -z "$bookmark_selection" ]; then
    notify-send "No bookmark selected."
    exit 1
fi

if [ -z "$selected_url" ]; then
    notify-send "No URL found for the selected bookmark."
    exit 1
fi

if [ "$1" = "-c" ]; then
    echo -n "$selected_url" | xclip -selection clipboard
    notify-send "Bookmark Copied" "$selected_url"
else
    setsid -f xdg-open "$selected_url"
    notify-send "Bookmark Launched" "$selected_url"
fi
