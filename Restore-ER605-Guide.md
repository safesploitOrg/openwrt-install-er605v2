# TP-Link ER605 v2 Restore Guide

This guide will walk you through the steps to restore your TP-Link ER605 v2 router to its factory firmware or OpenWRT firmware. Restoration may be required if the router becomes bricked or if you need to revert to the original firmware.

> ⚠️ **Warning**: Proceed with caution. Restoring the firmware incorrectly may cause the device to become bricked. Ensure you follow the steps carefully.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Restoring to Factory Firmware](#restoring-to-factory-firmware)
    - [Using Serial Recovery Mode](#using-serial-recovery-mode)
    - [Using U-Boot for Recovery](#using-u-boot-for-recovery)
3. [Restoring OpenWRT Firmware](#restoring-openwrt-firmware)
4. [Troubleshooting](#troubleshooting)
5. [Credits](#credits)

## Prerequisites

Before you begin, ensure you have the following:

- **TP-Link ER605 v2** router.
- **USB-to-serial adapter** to connect to the router for serial recovery (if necessary).
- **A computer** with terminal or SSH client.
- **Factory firmware** or **OpenWRT firmware** image files.
- **A serial cable** (if using serial recovery mode).
- **A backup** of your MTD partitions (if available).

## Restoring to Factory Firmware

If you need to restore your ER605 v2 to its factory firmware, you can use the **serial recovery mode**. This method is typically used when the router is bricked and cannot boot into its web interface.

### Using Serial Recovery Mode

1. **Prepare the Serial Connection**:
   - Connect the USB-to-serial adapter to your computer.
   - Use the appropriate serial cable to connect the adapter to the router’s serial console pins (TX, RX, GND).
   - Ensure that you have the necessary terminal software (such as **PuTTY** or **minicom**) installed on your computer to interact with the serial console.

2. **Enter U-Boot Mode**:
   - Power off the router.
   - Hold down the **reset button** while powering the router back on.
   - Continue holding the reset button until you see the U-Boot prompt on the terminal (usually a `CFE>` or `U-Boot>` prompt).

3. **Upload the Factory Firmware**:
   - At the U-Boot prompt, use the `tftpboot` command to upload the factory firmware image:
     ```bash
     tftpboot 0x81000000 openwrt-factory-image.bin
     ```
   - Replace `openwrt-factory-image.bin` with the path to the factory firmware file you have downloaded.

4. **Flash the Firmware**:
   - After the firmware is loaded into memory, use the following command to flash the router:
     ```bash
     mtd write 0x81000000 firmware
     ```
   - This will write the firmware to the router’s flash memory.

5. **Reboot the Router**:
   - Once the flashing process is complete, reboot the router:
     ```bash
     reboot
     ```

6. **Access the Web Interface**:
   - After rebooting, open a web browser and navigate to `http://192.168.0.1` to access the router's web interface.

7. **Factory Settings**:
   - If you restored the factory firmware, log in with the default credentials to complete the initial setup.

### Using U-Boot for Recovery

If you cannot use serial recovery mode, you can attempt to use the **U-Boot recovery mode**:

1. **Access U-Boot Recovery**: Follow the steps above to get to the U-Boot prompt.
2. **Transfer the Factory Firmware**: You can use a **TFTP** server on your computer to upload the firmware image. Ensure you have set up a TFTP server on your PC.
3. **Install the Firmware**: Use the `tftpboot` and `mtd write` commands in U-Boot as described earlier to upload and flash the factory firmware.

## Restoring OpenWRT Firmware

If you have OpenWRT installed and would like to restore it, follow these steps:

1. **Access the Router via SSH**:
   - If you can still access the router’s SSH interface, SSH into the router:
     ```bash
     ssh root@192.168.1.1
     ```
   - If SSH is not available, proceed with serial recovery mode as described above.

2. **Download OpenWRT Firmware**:
   - On the router, download the latest OpenWRT firmware image:
     ```bash
     cd /tmp
     curl -o openwrt-sysupgrade.bin https://downloads.openwrt.org/path/to/openwrt-firmware.bin
     ```

3. **Flash the Firmware**:
   - Flash the OpenWRT firmware using the following command:
     ```bash
     sysupgrade /tmp/openwrt-sysupgrade.bin
     ```
   - The router will automatically reboot after flashing.

4. **Verify Installation**:
   - After the router reboots, navigate to `http://192.168.1.1` to verify that OpenWRT is installed correctly.

## Troubleshooting

- **Router not responding after flashing**: Ensure the firmware was properly flashed using the correct method. If necessary, retry using the serial recovery mode.
- **Can’t access the web interface**: If the router doesn’t boot into the web interface, ensure no other devices are causing IP conflicts. Try accessing via serial mode to diagnose.
- **Check Firmware Version**: If you accidentally flashed the wrong firmware version, use the appropriate steps to restore the correct firmware.