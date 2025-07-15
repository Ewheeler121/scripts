#!/bin/sh

# From Lukesmith's LUKS Scripts

# Displays number of unread news items and an loading icon if updating.
# When clicked, brings up `newsboat`.

case $BUTTON in
        1) setsid "$TERMINAL" -e newsboat ;;
        2) notify-send "📰 News module" "\- Shows unread news items
            - Shows 🔃 if updating with \`newsup\`
            - Left click opens newsboat
            - Middle click syncs RSS feeds
            <b>Note:</b> Only one instance of newsboat (including updates) may be running at a time." ;;
        3) setsid "$TERMINAL" -e newsboat ;;
#   3) setsid -f newsup >/dev/null && exit ;;
	6) setsid -f "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

cat /tmp/newsupdate 2>/dev/null || echo "$(newsboat -x print-unread | awk '{ if ($1=="Error:") print "📰🔃"; else print "📰" $1}')$(cat "${XDG_CONFIG_HOME:-$HOME/.config}"/newsboat/.update 2>/dev/null)"
