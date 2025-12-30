#!/bin/sh

# From Lukesmith's LUKS Scripts

# Displays number of unread mail and an loading icon if updating.
# When clicked, brings up `neomutt`.

case $BUTTON in
	1) setsid -w -f "$TERMINAL" -e neomutt ;;
	2) notify-send "📬 Mail module" "\- Shows unread mail
- Shows 🔃 if syncing mail
- Left click opens neomutt
- Middle click syncs mail" ;;
    3) setsid -f mailsync > /dev/null ;;
	6) setsid -f "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

unread="$(find "${XDG_DATA_HOME:-$HOME/.local/share}"/mail/*/[Ii][Nn][Bb][Oo][Xx]/new/* -type f 2>/dev/null | wc -l 2>/dev/null)"

icon=""

pidof mbsync >/dev/null 2>&1 && icon="🔃"

echo "📬$unread$icon"

[ "$unread" = "0" ] && [ "$icon" = "" ] || echo "📬$unread$icon"
