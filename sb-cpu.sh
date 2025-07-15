#!/bin/sh

# From Lukesmith's LUKS Scripts

case $BUTTON in
	1) notify-send "🖥 CPU hogs" "$(ps axch -o cmd:15,%cpu --sort=-%cpu | head)\\n(100% per core)" ;;
	2) notify-send "🖥 CPU module " "\- Shows CPU temperature.
        - Click to show intensive processes.
        - Middle click to open htop." ;;
    3) setsid -f "$TERMINAL" -e htop ;;
	6) setsid -f "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

sensors | awk '/^Core/ {sum+=$3; count++} END {if (count > 0) print "🌡" int(sum/count) "°C"; else print "No temperature data found"}'
