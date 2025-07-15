#!/bin/sh

# From Lukesmith's LUKS Scripts

# Module showing network traffic. Shows how much data has been received (RX) or
# transmitted (TX) since the previous time this script ran. So if run every
# second, gives network traffic per second.

case $BUTTON in
    1) notify-send "starting Ping to archlinux.org"
        notify-send "$(ping archlinux.org -c 1)";;
	2) notify-send "🌐 Network traffic module" "🔻: Traffic received
                    🔺: Traffic transmitted" ;;
	3) wireshark ;;
	6) setsid -f "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

update() {
    sum=0
    for arg; do
        read -r i < "$arg"
        sum=$(( sum + i ))
    done
    cache=/tmp/${1##*/}
    [ -f "$cache" ] && read -r old < "$cache" || old=0
    printf %d\\n "$sum" > "$cache"
    printf %d\\n $(( sum - old ))
}

rx=$(update /sys/class/net/[ew]*/statistics/rx_bytes)
tx=$(update /sys/class/net/[ew]*/statistics/tx_bytes)

printf "🔻%4sB 🔺%4sB\\n" $(numfmt --to=iec $rx $tx)
