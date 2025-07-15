#!/bin/sh

selected_emoji=$(cut -d ';' -f1 ~/.local/share/chars/* | dmenu -i -l 30 | sed "s/ .*//")

[ -z "$selected_emoji" ] && exit

if [ -n "$1" ]; then
	xdotool type "$selected_emoji"
else
	printf "%s" "$selected_emoji" | xclip -selection clipboard
	notify-send "'$selected_emoji' copied to clipboard."
fi
