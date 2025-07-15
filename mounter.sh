#!/bin/bash

# Modified Version of Luke Smith's mounter Script, more aggressive when managing /media and removed some LUKS stuff

# Mounts Android Phones and USB drives (encrypted or not). This script will
# replace the older `dmenumount` which had extra steps and couldn't handle
# encrypted drives.
# TODO: Try decrypt for drives in crtypttab
# TODO: Add some support for connecting iPhones (although they are annoying).

IFS='
'
# Function for escaping cell-phone names.
escape(){ echo "$@" | iconv -cf UTF-8 -t ASCII//TRANSLIT | tr -d '[:punct:]' | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed "s/-\+/-/g;s/\(^-\|-\$\)//g" ;}

# Check for phones.
phones="$(simple-mtpfs -l 2>/dev/null | sed "s/^/📱/")"
mountedphones="$(grep "simple-mtpfs" /etc/mtab)"
# If there are already mounted phones, remove them from the list of mountables.
[ -n "$mountedphones" ] && phones="$(for phone in $phones; do
	for mounted in $mountedphones; do
		escphone="$(escape "$phone")"
		[[ "$mounted" =~ "$escphone" ]] && break 1
	done && continue 1
	echo "$phone"
done)"

# Check for drives.
lsblkoutput="$(lsblk -rpo "uuid,name,type,size,label,mountpoint,fstype")"
# Functioning for formatting drives correctly for dmenu:
filter() { sed "s/ /:/g" | awk -F':' '$7==""{printf "%s%s (%s) %s\n",$1,$3,$5,$6}' ; }

# Get all normal, non-encrypted or decrypted partitions that are not mounted.
normalparts="$(echo "$lsblkoutput"| grep -v crypto_LUKS | grep 'part\|rom\|crypt' | sed "s/^/💾 /" | filter )"

# Add all to one variable. If no mountable drives found, exit.
alldrives="$(echo "$phones
$normalparts" | sed "/^$/d;s/ *$//")"

# Quit the script if a sequential command fails.
set -e

test -n "$alldrives"

# Feed all found drives to dmenu and get user choice.
chosen="$(echo "$alldrives" | dmenu -p "Mount which drive?" -i)"

# Function for prompting user for a mountpoint.
getmount(){
    device=$(basename "$chosen" | sed 's/^📱//')
    mp="/media/$device"
    if [ -d "$mp" ]; then
        sudo rmdir "$mp"
        if [ -d "$mp" ]; then
            notify-send "%s failed to remove old mountpoint" "$mp"
            return 1
        fi
    fi
    mkdir -p "$mp" || sudo -A mkdir -p "$mp"
}

attemptmount(){
		# Attempt to mount without a mountpoint, to see if drive is in fstab.
		sudo -A mount "$chosen" || return 1
		notify-send "💾Drive Mounted." "$chosen mounted."
		exit
}

case "$chosen" in
	💾*)
		chosen="${chosen%% *}"
		chosen="${chosen:1}"	# This is a bashism.
		attemptmount || getmount
		sudo -A mount "$chosen" "$mp" -o uid="$(id -u)",gid="$(id -g)"
		notify-send "💾Drive Mounted." "$chosen mounted to $mp."
		;;

	📱*)
		notify-send "❗Note" "Remember to allow file access on your phone now."
		getmount
		number="${chosen%%:*}"
		number="${chosen:1}"	# This is a bashism.
		sudo -A simple-mtpfs -o allow_other -o fsname="simple-mtpfs-$(escape "$chosen")" --device "$number" "$mp"
		notify-send "🤖 Android Mounted." "Android device mounted to $mp."
		;;
esac
