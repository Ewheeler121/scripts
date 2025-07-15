#!/bin/sh

sudo -v || echo "failed to use sudo" && exit 1

sudo modprobe v4l2loopback video_nr=9 card_label=Video-Loopback exclusive_caps=1

dummy_device=$(v4l2-ctl --list-devices | grep -A 1 "Video-Loopback" | grep -oE "/dev/video[0-9]+")

if [ $? -eq 1]; then
    notify-send "error modeprobe loopback device"
    exit
fi

notify-send "🎥 started recording screen to loopback 🎥" "$dummy_device"

ffmpeg -f x11grab -framerate 60 -i $DISPLAY -vf format=yuv420p -f v4l2 $dummy_device

notify-send "🎥 stopped recording screen to loopback 🎥" "$dummy_device"
