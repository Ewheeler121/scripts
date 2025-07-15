#!/bin/sh

status=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')

if [ "$status" == "no" ]; then
    pactl set-source-mute @DEFAULT_SOURCE@ 1
    notify-send "🎤 Microphone muted"
else
    pactl set-source-mute @DEFAULT_SOURCE@ 0
    notify-send "🎤 Microphone unmuted"
fi
