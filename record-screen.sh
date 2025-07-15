#!/bin/sh

lock_file="/tmp/rec_lock"
output_directory="/home/$USER/Videos/Recordings"
output_file="$output_directory/screen_recording_$(date +"%Y-%m-%d_%H-%M-%S").mp4"

record_screen() {
    pkill -23 dwmblocks
    mkdir -p "$output_directory"
    notify-send "🎥 start recording screen 🎥" "$output_file"
    
    gpu-screen-recorder -w screen -f 60 -a "default_output|default_input" -ac aac -fm cfr -oc yes -o "$output_file" &

    echo $! > $lock_file
}

end_recording() {
    kill -2 $(cat $lock_file)
    notify-send "🎥 ended recording 🎥"
    pkill -23 dwmblocks
    rm $lock_file
}
if [ "$1" = "-s" ]; then
    if [ -f "$lock_file" ]; then
        echo "🎥 recording"
    else
        echo ""
    fi
else
    if [ -f "$lock_file" ]; then
        end_recording
    else
        record_screen
        pkill -23 dwmblocks
    fi
fi
