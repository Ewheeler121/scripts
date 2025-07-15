#!/bin/sh

output_dir="$HOME/Pictures/Screenshots"
output_file="$output_dir/screenshot_$(date +%Y%m%d_%H%M%S).png"

if [ "$1" == "-c" ]; then
    scrot -s -f -F "$output_file"
else
    scrot -F "$output_file"
fi

if [ $? -ne 0 ]; then
    notify-send "❌📷 screenshot failed ❌📷" "$output_file"
else
    notify-send "📸 screenshot taken 📸" "$output_file"
fi

cat "$output_file" | xclip -selection clipboard -target image/png -i

# gimp "$output_file"
# rm $output_file
