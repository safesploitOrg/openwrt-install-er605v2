#!/bin/sh

# Global variables
VOL_COUNT=0
VOL_KERNEL=""
VOL_KERNELB=""
INITRAMFS_IMAGE=""

# Function to display usage information
usage() {
    echo "Usage: $0 <path to openwrt-initramfs.bin>"
    echo "Example: $0 ./openwrt-initramfs.bin"
}

# Function to check and parse command-line arguments
parse_args() {
    if [ $# -ne 1 ]; then
        usage
        exit 1
    fi
    INITRAMFS_IMAGE="$1"
}

# Function to check for the kernel volumes and set global variables
find_kernel_volumes() {
    VOL_COUNT=$(cat /sys/class/ubi/ubi0/volumes_count)

    # Loop through all volumes to find the "kernel" and "kernel.b" partitions
    i=0
    while [ $i -lt $VOL_COUNT ]; do
        NAME=$(cat /sys/class/ubi/ubi0_$i/name)

        case $NAME in
            "kernel")
                VOL_KERNEL=$i
                ;;
            "kernel.b")
                VOL_KERNELB=$i
                ;;
        esac
        i=$((i + 1))
    done
}

# Function to check if the required UBI volumes exist
check_volumes() {
    if [ -z "$VOL_KERNEL" ] || [ -z "$VOL_KERNELB" ]; then
        echo "ERROR: Required UBI volumes ('kernel' and 'kernel.b') not found."
        exit 1
    fi
}

# Function to flash the initramfs image to the kernel volumes
flash_kernel_volumes() {
    echo "Found kernel UBI partitions: ubi0_$VOL_KERNEL and ubi0_$VOL_KERNELB."
    echo "Flashing the initramfs.bin image to both partitions..."

    # Flash the initramfs image to the "kernel" and "kernel.b" volumes
    ubiupdatevol /dev/ubi0_$VOL_KERNEL "$INITRAMFS_IMAGE"
    ubiupdatevol /dev/ubi0_$VOL_KERNELB "$INITRAMFS_IMAGE"

    # Sync to ensure all changes are written
    sync
}

# Main function to orchestrate the script
main() {
    parse_args "$@"
    find_kernel_volumes
    check_volumes
    flash_kernel_volumes

    echo "Flashing complete!"
}

main "$@"
