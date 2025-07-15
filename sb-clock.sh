#!/bin/sh

# From Lukesmith's LUKS Scripts

case $BUTTON in
    1) notify-send "📅   Calender" "$(cal)" ;;
    2) notify-send "📅     Calender module" "
        - Left click to show Calender.
        - Right click to show Calender.
        - Shift click to edit." ;;
    3) notify-send "📅   Calender" "$(cal)" ;;
    6) setsid -f "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

clock=$(date '+%I')

case "$clock" in
	"00") icon="🕛" ;;
	"01") icon="🕐" ;;
	"02") icon="🕑" ;;
	"03") icon="🕒" ;;
	"04") icon="🕓" ;;
	"05") icon="🕔" ;;
	"06") icon="🕕" ;;
	"07") icon="🕖" ;;
	"08") icon="🕗" ;;
	"09") icon="🕘" ;;
	"10") icon="🕙" ;;
	"11") icon="🕚" ;;
	"12") icon="🕛" ;;
esac

date "+%Y %b %d (%a) $icon%I:%M%p"
