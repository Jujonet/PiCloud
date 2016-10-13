# PiCloud
Script to backup Raspberry Pi SD card image to a Western Digital My Cloud
network attached storage drive.

## Requirements
- A Raspberry Pi (tested on RPi 2)
- A Western Digital MyCloud (or other network drive) with a share named
"raspi" with public access

## Before starting
Please note that creating the image and writing it to the MyCloud may take
in excess of thirty minutes, depending on SD card size and network speed.
This script is intended to run when the Pi is idle and not in use, and has
only been tested on a Raspberry Pi 2.

## Setup
Run the script with the -s option to create a necessary mount directory (/mnt/MyCloud)
and entry in /etc/fstab for the drive to mount on boot. Pass arguments that
specify the WD MyCloud IP on your network, and the username/password to
the "raspi" share. Example:
```
sudo ./picloud.sh -s "192.168.1.48 username password"
```

## Backup
Run the backup script any time you want to backup a new SD card image to the
MyCloud. SD card images are placed in date-stamped directories within /raspi/images
```
sudo ./picloud.sh
```

## Potential improvements
- Find a way to mount only one entry in /etc/fstab and verify MyCloud mount before every backup
- Run backups as a cron job
- Specify max backups and overwrite oldest when limit reached
