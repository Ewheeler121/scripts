#!/bin/sh

# From Lukesmith's LUKS Scripts

# Prints the current volume or 🔇 if muted.

case $BUTTON in
	1) setsid -w -f "$TERMINAL" -e ncpamixer; pkill -RTMIN+2 "${STATUSBAR:-dwmblocks}" ;;
    2) notify-send "📢 Volume module" "\- Shows volume 🔊, 🔇 if muted.
        - Left click to open ncpamixer.
        - Right click to mute
        - Shift click to edit" ;;
	3) volume.sh m ;;
	4) volume.sh + ;;
	5) volume.sh - ;;
	6) setsid -f "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

vol="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"

# If muted, print 🔇 and exit.
[ "$vol" != "${vol%\[MUTED\]}" ] && echo 🔇 && exit

vol="${vol#Volume: }"

split() {
	# For ommiting the . without calling and external program.
	IFS=$2
	set -- $1
	printf '%s' "$@"
}

vol="$(printf "%.0f" "$(split "$vol" ".")")"

case 1 in
	$((vol >= 70)) ) icon="🔊" ;;
	$((vol >= 30)) ) icon="🔉" ;;
	$((vol >= 1)) ) icon="🔈" ;;
	* ) echo 🔇 && exit ;;
esac

echo "$icon$vol%"
