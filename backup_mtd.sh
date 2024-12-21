#!/bin/sh

# Script Name: backup_mtd.sh
# Description: This script performs backups of all MTD devices on the system.
#              It dynamically retrieves the list of MTD devices from /proc/mtd
#              and uses `nanddump` to create backup images for each device.
#              The backups are stored in a timestamped directory under /tmp.
#
# Author: safesploit
# Date: 2024-12-21

CURRENT_DATE=$(date +%Y%m%d)
BACKUP_DIR="/tmp/ER605_${CURRENT_DATE}"
mkdir -p "$BACKUP_DIR"

# Dynamically get the list of MTD devices from /proc/mtd
MTD_DEVICES=$(cat /proc/mtd | awk -F: '{print $1}' | grep -E '^mtd[0-9]+')

# Loop through each MTD device and run nanddump
for mtd_device in $MTD_DEVICES; do
    # Define backup filename
    backup_file="${BACKUP_DIR}/${mtd_device}_backup.img"
    
    # Output current backup operation
    echo "Backing up $mtd_device to $backup_file"
    
    # Perform the backup with nanddump
    nanddump --noecc --omitoob -l 0x80000 -f "$backup_file" "/dev/$mtd_device"
done

# Notify that the backup process is completed
echo "Backup completed for all MTD devices."
