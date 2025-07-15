#!/bin/sh

EMAIL_FROM="ewheeler121@outlook.com"
EMAIL_TO="ewheeler121@outlook.com"
URL="https://mods.snootbooru.com/"
URLS=("snoot" "wani" "standalone" "wani/SnootCoreLib Mods")

CACHE="/home/ewheeler121/.local/state/snoot"

BODY=""

for BASE in "${URLS[@]}"; do
    cache_file="$CACHE/$(echo "$BASE" | sed 's/\//_/').txt"
    pull=$(lynx -dump -width=1000 "$URL$BASE")

    if [ -f "$cache_file" ]; then
        new=$(diff "$cache_file" <(echo "$pull") | grep '^>' | sed 's/^> //')
        if [ -n "$new" ]; then
            notify-send "New $BASE mods!!!" "$new"
            BODY="${BODY}$(printf "\n\nnew/modified $BASE mods:\n%s" "$new")"
        fi
    fi
    
    echo "$pull" > "$cache_file"
done

if [ -n "$BODY" ]; then
    # msmtp -a "$EMAIL_FROM" "$EMAIL_TO" < <(printf "To: %s\nFrom: %s\nSubject: New Snoot/Wani mods\n\nNew Mods: \n%s\n" "$EMAIL_TO" "$EMAIL_FROM" "$new")
    cat <(printf "To: %s\nFrom: %s\nSubject: New Snoot/Wani mods\n\n%s\n" "$EMAIL_TO" "$EMAIL_FROM" "$BODY")
fi
