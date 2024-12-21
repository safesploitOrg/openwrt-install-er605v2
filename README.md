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