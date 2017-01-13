#!/bin/bash
# PiCloud - backup your Raspberry Pi SD card image to a Western Digital
# MyCloud network attached storage drive

function main(){
  while getopts "s:" opt; do
    case $opt in
      s )
        set -f
        IFS=' '
        array=($OPTARG)
        setup "${array[@]}"
        ;;
      * )
        usage
        exit 1
        ;;
    esac
  done

  # Create compressed backup of sd card image
  echo "Creating backup. This may take a while."
  if mount -a; then
	sync # Syncs files in cache
    dd if=/dev/mmcblk0p7 bs=1M | gzip > /mnt/MyCloud/images/"$(date +%d-%b-%y_%T)".gz
    echo "Backup complete at $(date +%d-%b-%y_%T)"
  else
    echo "Mounting MyCloud failed"
    exit 1
  fi

  exit 0
}

# Setup auto mount for MyCloud in /etc/fstab and create mount dir
function setup() {
  local ip="$1"
  local user="$2"
  local pass="$3"
  local automount="//$ip/raspi /mnt/MyCloud cifs username=$user,password=$pass,iocharset=utf8,file_mode=0777,dir_mode=0777 0 0"

  echo "Running setup..."
  mkdir /mnt/MyCloud
  echo "$automount" | tee -a /etc/fstab > /dev/null

  if ! mount -a; then
    rmdir /mnt/MyCloud
    echo "Mounting MyCloud failed during setup"
    exit 1
  fi
  echo "Setup done!"
}

# Display usage message - raw tabs here mandatory
function usage() {
	cat <<-USAGEMESSAGE
	Usage: ./picloud [options]
	Create a SD card image backup for a Raspberry Pi and write it to
	a Western Digital MyCloud share mounted at /mnt/MyCloud

	Options:
	-s "i u p" setup auto mount for MyCloud at i ip address with username u and
	password p (MUST run before first backup)
	USAGEMESSAGE
}

main "$@"
