#!/bin/sh

case $BUTTON in
    1) notify-send "🧠 Memory hogs" "$(ps axch -o cmd:15,%mem,rss --sort=-rss | awk '{ hr[1024**2]="GB"; hr[1024]="MB";
        for (x=1024**3; x>=1024; x/=1024) {
        if ($3>=x) { printf ("%-15s %2.2f%s\n",$1,$3/x,hr[x]); break } }}' | head)" ;;
    2) notify-send "🧠 Memory module" "\- Shows Memory Used/Total.
        - Left click to show memory hogs.
        - Right click to open htop.
        - Shift click to edit." ;;
	3) setsid -f "$TERMINAL" -e htop ;;
	6) setsid -f "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

free --mebi | sed -n '2{p;q}' | awk '{printf ("🧠%2.2fGiB/%2.2fGiB\n", ( $3 / 1024), ($2 / 1024))}'
