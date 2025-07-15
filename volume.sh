#/bin/sh

case "$1" in
    +)
        wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 4%+ ;;
    -)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%- ;;
    m)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

        vol="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
        
        [ "$vol" != "${vol%\[MUTED\]}" ] && notify-send "Volume Muted 🔇" && pkill -RTMIN+2 dwmblocks && exit
        
        notify-send "Volume Unmuted 🔊" && pkill -RTMIN+2 dwmblocks && exit ;;
    *)
        echo "Invalid operation. Please use +, -, or 'm'."
        exit 1
        ;;
esac

pkill -RTMIN+2 dwmblocks

vol="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk -F': ' '{print $2}' | awk '{print int($1 * 100)}')"

notify-send "🔊Volume🔊" \
    -h int:value:$vol
