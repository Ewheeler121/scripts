#!/bin/sh

suckless_dirs="
$HOME/Public/suckless/dmenu/
$HOME/Public/suckless/st/
$HOME/Public/suckless/dwm/
"

if [ $# -eq 0 ]; then
    echo "usage: $0 <wallpaper>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Wallpaper file not found: $1"
    exit 1
fi

sudo -v || { echo "failed to use sudo" && exit 1; }

wal -s -t -i "$1" 
pywalfox update

# hacky work-a-round for wal wanting a patch that breaks DWM
sed -i '/^[[:space:]]*\[SchemeUrg\]/d' "$HOME/.cache/wal/colors-wal-dwm.h"

for dir in $suckless_dirs; do
        cd "$dir" || { printf "failed to enter %s\n" "$1" && exit; }
        make clean
        sudo make install
        make clean
done

rm ~/.fehbg
kill -HUP $(pgrep -x dwm)
