#/bin/sh

# From Lukesmith's LUKS Scripts

case $BUTTON in
    1) playerctl play-pause ;;
    2) notify-send "🎧 MPD module 🎧" "
        - Left click to pause/play.
        - right click to open ncmpcpp.
        - Shift click to edit." ;;
    3) setsid -f "$TERMINAL" -e "ncmpcpp" ;;
    4) playerctl next ;;
    5) playerctl previous ;;
    6) setsid -f "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

case "$(playerctl status)" in
    "Playing")
        offset="🎧 <="
        ;;
    "Paused")
        offset="⏸ <="
        ;;
    *)
        echo "🎵 no playlist"
        exit 0
        ;;
esac

text="$(playerctl metadata --format '{{artist}} - {{title}}') "
state_file="/tmp/sb-mstate"
len=15

text_len=${#text}

if [ ! -f "$state_file" ]; then
    echo 0 > "$state_file"
fi

position=$(cat "$state_file")

if [ $((position + len)) -le $text_len ]; then
    output="${text:$position:$len}"
else
    part1="${text:$position}"
    part2="${text:0:$((len - ${#part1}))}"
    output="${part1}${part2}"
fi

echo "$offset $output"

if [ ! -n "$BUTTON" ]; then
    new_position=$(( (position + 1) % text_len ))
    echo "$new_position" > "$state_file"
fi
