# TP-Link ER605 v2 OpenWRT Installation Guide

This guide outlines the steps to install OpenWRT on the TP-Link ER605 v2 router. OpenWRT provides a customizable, open-source router firmware that offers improved functionality and flexibility.

## Prerequisites

Before starting, ensure you have the following:

- **TP-Link ER605 v2 Router**: This guide is specifically for the v2 model.
- **OpenWRT Firmware**: Download the appropriate firmware for the TP-Link ER605 v2 from the [official OpenWRT website](https://openwrt.org/).
- **Backup** of your current router configuration (optional but recommended).
- **Hardware**:
    - **USB-to-serial adapter** (if you need to use serial recovery mode).
    - **Ethernet Cable**: For a wired connection between your router and PC.


## Steps to Install

### Enable SSH Access

1. **Log into the ER605 Web Interface**: Open a browser and navigate to `http://192.168.0.1`.
2. **Navigate to Remote Assistance**:
    - Go to **System Tools > Diagnostics > Remote Assistance**.
    - Enable **Remote Assistance**.

3. **Generate SSH Password**:
    - Generate your SSH password by clicking the provided link for password generation.

4. **SSH into Your ER605**:
    - Open a terminal and connect to the router via SSH:
      ```bash
      ssh -o hostkeyalgorithms=ssh-rsa root@192.168.0.1
      ```
    - If your SSH client complains about no matching host key or key exchange method, use these additional options:
      ```bash
      ssh -o hostkeyalgorithms=ssh-rsa -o KexAlgorithms=+diffie-hellman-group1-sha1 root@192.168.0.1
      ```

    - If using **version 2.0.1 or below**, login using the username `root` and the generated password.
    - For **version 2.1.1 and above**, log in using your web configuration credentials and run the following commands:
      ```bash
      enable
      debug
      ```
      When prompted for a password, use the "CLI debug mode password" generated earlier.

### Download the Files

1. **Backup MTD Partitions** (Recommended):
   - Backup your MTD partitions. For more details, follow this guide: [OpenWRT Backup Guide](https://openwrt.org/docs/guide-user/installation/generic.backup?do=#create_full_mtd_backup).

2. **Download the Necessary Files**:
    - SSH into the router and execute the following commands to download the required files:
      ```bash
      cd /tmp
      curl -o er605v2_write_initramfs.sh https://raw.githubusercontent.com/chill1Penguin/er605v2_openwrt_install/main/er605v2_write_initramfs.sh
      curl -o openwrt-initramfs-compact.bin https://raw.githubusercontent.com/chill1Penguin/er605v2_openwrt_install/main/openwrt-initramfs-compact.bin
      chmod +x er605v2_write_initramfs.sh
      ```

### Verify the Image

1. **Verify the Checksum**:
   - To ensure that the `openwrt-initramfs-compact.bin` image file has not been corrupted, verify its checksum by running:
      ```bash
      md5sum openwrt-initramfs-compact.bin
      ```
   - Compare the output with the checksum in the `md5sums` file to verify its integrity.

### Install the Firmware

1. **Run the Installation Script**:
    - Execute the following command to flash the initramfs image to your ER605:
      ```bash
      ./er605v2_write_initramfs.sh openwrt-initramfs-compact.bin
      ```
   
2. **Reboot the ER605**:
    - After the flashing process completes, reboot the ER605 router.

3. **Access the Web Interface**:
    - Open a web browser and go to `http://192.168.1.1/`. If the page does not load, wait a bit longer or clear your browser cache. Ensure there are no other routers or DHCP servers on the same network to avoid IP conflicts.

4. **Follow the Setup Instructions**:
    - After successfully accessing the web interface, follow the on-screen instructions to complete the setup.

5. **Upgrade to Latest OpenWRT Version**:
    - Download the latest sysupgrade image from [OpenWRT Downloads](https://downloads.openwrt.org).
    - Use the web interface to upload and upgrade to the latest stable release.

### Reboot and Enjoy OpenWRT!

Once the upgrade is complete, your ER605 should be running OpenWRT. Enjoy the enhanced features and flexibility!

## Post-Installation

1. **Configure OpenWRT**:
    - Set up your Wi-Fi networks, firewall, and routing preferences.
    - Change your root password for security.

2. **Restore Backup (if applicable)**:
    - If you made a backup of your MTD partitions, you can restore them at this point.

## Troubleshooting

- **Router not booting**: If the router fails to boot into OpenWRT, you may need to perform a **serial recovery** using a USB-to-serial adapter and the proper recovery commands.
- **Can't access web interface**: Try disconnecting all unnecessary devices from the router to avoid IP conflicts.
- **Firmware Mismatch**: Ensure that the firmware file is correct for the ER605v2 version you have.


---
Else

## Flashing OpenWRT onto the ER605 v2

### Step 1: Prepare the Router
1. **Connect your router to your PC** via Ethernet cable.
2. **Ensure the router is powered off** before proceeding to the next steps.
3. **Enter Recovery Mode**:
   - Hold down the **reset button** while powering on the router. Continue holding for around 5-10 seconds until the power LED starts flashing rapidly.

### Step 2: Install OpenWRT via TFTP
1. **Configure TFTP Client**:
   - Set up your TFTP client with the IP address of the router in recovery mode (usually `192.168.0.66`).
   - Specify the correct path to the OpenWRT firmware file that you downloaded.
2. **Transfer the Firmware**:
   - Start the TFTP transfer and wait for the router to flash the firmware.

### Step 3: Post-Installation Setup
Once the router has flashed OpenWRT, you can access the LuCI web interface for initial configuration.

1. **Access LuCI**: Open a browser and navigate to `http://192.168.1.1` (default IP).
2. **Set a Root (Debug) Password**: You will be prompted to set a password for the `root` user upon first login.

### Step 4: Configure Network and Wireless
1. **Configure LAN and WAN**:
   - Go to **Network > Interfaces** in LuCI to configure your LAN and WAN interfaces according to your network setup.
2. **Enable Wireless**:
   - Configure wireless settings under **Network > Wireless**.

### Step 5: Install Additional Packages (Optional)
To install additional packages, such as LuCI for web management, run the following command:

```bash
opkg update
opkg install luci
```

### Step 6: Configure Security
For enhanced security, disable password authentication for SSH and configure SSH keys.

1. **Disable Password Authentication**:
Edit the `/etc/config/dropbear` file and set `PasswordAuth` to `off`.

2. **Restart the Dropbear service**:

```bash
/etc/init.d/dropbear restart
```

## Credits

- This guide is based on community contributions and research from various OpenWRT forums.
- Special thanks to [chill1Penguin](https://github.com/chill1Penguin) for the original setup and guidance on flashing the TP-Link ER605v2 with OpenWRT.