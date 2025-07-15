#!/bin/sh

options="Logout\nReboot\nShutdown"
choice=$(echo -e "$options" | dmenu -i -p "Choose an action: ")

case "$choice" in
    "Logout") pkill -KILL -u "$("whoami")" ;;
    "Reboot") reboot ;;
    "Shutdown") poweroff ;;
    *) ;;
esac
