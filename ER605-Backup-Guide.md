# Full MTD Backup and Restore Guide for TP-Link ER605 v2 Router

Before making any changes to your router, such as flashing OpenWRT or performing other major operations, it is crucial to create a full backup of your router's flash memory. This guide explains how to back up and restore the full flash memory (MTD) of your router.

## Table of Contents

1. [What is an MTD Backup?](#what-is-an-mtd-backup)
2. [Creating a Full MTD Backup](#creating-a-full-mtd-backup)
3. [Restoring a Full MTD Backup](#restoring-a-full-mtd-backup)

## What is an MTD Backup?

MTD (Memory Technology Device) backups allow you to back up the entire flash memory of your router. This includes all partitions, such as:

- **Bootloader**
- **Kernel**
- **Root filesystem**
- **Other partitions** (e.g., configuration, settings)

Creating an MTD backup ensures that you can restore your router to its original state, including the stock firmware, settings, and configurations.

## Creating a Full MTD Backup

To create a full MTD backup of your router, follow these steps:

### Requirements

- **SSH access** to your router.
- A **working router** with sufficient free space (e.g., USB storage or a large enough partition).

### Steps:

1. **SSH into the Router**:
    - Use an SSH client (such as PuTTY or terminal) to access your router. The default IP address is `192.168.1.1`:
      ```bash
      ssh root@192.168.1.1
      ```

2. **Identify MTD Partitions**:
    - Once logged in, list all MTD partitions to verify the ones you want to back up:
      ```bash
      cat /proc/mounts
      ```
    - This command will show you the available MTD partitions like the bootloader, kernel, root filesystem, and other partitions.

3. **Backup All MTD Partitions**:
    - You can use the `nanddump` or `mtd` commands to create a full backup of all partitions. For example, to back up the entire flash memory:
      ```bash
      mtd --backup=/tmp/backup.bin
      ```
    - This command creates a backup file (`backup.bin`) of the router's flash memory.

4. **Copy the Backup to Your Local System**:
    - After the backup is created, use `scp` (secure copy) to download the backup file to your local machine:
      ```bash
      scp root@192.168.1.1:/tmp/backup.bin /path/to/save/backup/
      ```
    - Alternatively, you can use a file transfer method like FTP or OpenWRT’s file system manager to download the backup.

5. **Check Backup Integrity**:
    - It's a good idea to check that the backup was created successfully and isn't corrupted. You can do this by comparing checksums before and after transferring the backup file:
      ```bash
      sha256sum /tmp/backup.bin
      ```
    - Compare this checksum with the one on your local machine to ensure the file is intact.

### Important Notes:

- **Storage Space**: Ensure you have enough storage space available on the router or external storage for the backup.
- **Backup Size**: The size of the backup may vary depending on the router model and the size of the partitions.

---

## Restoring a Full MTD Backup

If you need to restore your router to its original state, you can use the full MTD backup created earlier.

### Steps:

1. **SSH into the Router**:
    - Log back into your router via SSH:
      ```bash
      ssh root@192.168.1.1
      ```

2. **Upload the Backup File**:
    - Upload the `backup.bin` file you previously downloaded to the `/tmp` directory on your router using `scp` or a similar method:
      ```bash
      scp /path/to/backup.bin root@192.168.1.1:/tmp/
      ```

3. **Restore the Backup**:
    - Once the backup file is uploaded, restore the full backup using the following command:
      ```bash
      mtd --restore=/tmp/backup.bin
      ```
    - This command will restore the original MTD partitions from the backup file.

4. **Reboot the Router**:
    - After the restore process is complete, reboot the router:
      ```bash
      reboot
      ```

5. **Verify the Restoration**:
    - After rebooting, verify that the router has been restored to its original firmware and configuration.

### Important Notes:

- **Restoration Caution**: Restoring the full MTD backup will erase any changes or configurations made since the backup. Make sure to have a backup of any newer settings before proceeding.
- **Recovery from Bricked Router**: If your router becomes unresponsive or bricked, restoring a full MTD backup can help bring it back to a working state.

### Debricking:

https://openwrt.org/toh/tp-link/er605_v2#debricking

---

## Conclusion

Creating a full MTD backup is an essential step before making significant changes to your router, such as flashing OpenWRT or upgrading firmware. This ensures that you can always revert back to the original firmware and settings if anything goes wrong. Keep your backups in a secure location and use them whenever you need to restore your router’s configuration.
