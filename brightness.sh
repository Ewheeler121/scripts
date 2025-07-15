#!/bin/sh

case "$1" in
    +) brightnessctl s +5% ;;
    -) brightnessctl s 5%- ;;
    *) echo "Invalid Option use + or -"
       exit 1 ;;
esac

bright_level=$(echo "$(brightnessctl g) / $(brightnessctl m) * 100" | bc -l)
notify-send "☀️Brightness☀️" -h int:value:$bright_level
