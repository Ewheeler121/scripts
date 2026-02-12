#!/bin/sh

suckless_dirs="
$HOME/Public/suckless/dmenu/
$HOME/Public/suckless/st/
$HOME/Public/suckless/dwm/
"

default=false
wallpaper=""

while getopts "d" opt; do
    case $opt in
        d) 
            default=true;;
        *) 
            echo "usage: $0 <wallpaper>"
            exit 1;;
    esac
done

shift $((OPTIND - 1))

if [ $# -lt 1 ]; then
    echo "Error: file argument is required"
    echo "Usage: $0 [-d] <wallpaper>"
    exit 1
fi

wallpaper="$1"

if [ ! -f "$wallpaper" ]; then
    echo "Wallpaper file not found: $1"
    exit 1
fi

sudo -v || { echo "failed to use sudo" && exit 1; }

wal -s -t -i "$wallpaper" 
pywalfox update

# hacky work-a-round for wal wanting a patch that breaks DWM
sed -i '/^[[:space:]]*\[SchemeUrg\]/d' "$HOME/.cache/wal/colors-wal-dwm.h"

for dir in $suckless_dirs; do
        cd "$dir" || { printf "failed to enter %s\n" "$1" && exit; }
        make clean
        if $default; then
            sudo make install
        else
            sudo -E make install
        fi
        make clean
done

rm ~/.fehbg
kill -HUP $(pgrep -x dwm)
