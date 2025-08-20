#!/bin/bash

# BoneHubOS eMMC Flasher Script
# This script helps automate the partitioning and formatting of the eMMC
# on BeagleBone Black with bonehubos

# Copyright (C) 2024 BoneHub Project
# Based on original script by Dhiren Wijesinghe (Texas Instruments)

set -e  # Exit on any error

echo "Starting BoneHubOS eMMC Flashing Script..."
echo "This script will partition and format the eMMC for bonehubos"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root (use sudo)"
    exit 1
fi

# Function to cleanup on exit
cleanup() {
    echo "Cleaning up..."
    umount /tmp/boot 2>/dev/null || true
    umount /tmp/root 2>/dev/null || true
    umount /tmp/sd_boot 2>/dev/null || true
    rmdir /tmp/boot 2>/dev/null || true
    rmdir /tmp/root 2>/dev/null || true
    rmdir /tmp/sd_boot 2>/dev/null || true
}

trap cleanup EXIT

# Set eMMC device (mmcblk1)
EMMC_DEVICE="/dev/mmcblk1"

# Validate device exists
if [ ! -b "$EMMC_DEVICE" ]; then
    echo "Error: eMMC device $EMMC_DEVICE does not exist"
    exit 1
fi

# Safety check
echo ""
echo "WARNING: This will completely erase all data on $EMMC_DEVICE (eMMC)"
echo "Make sure you have selected the correct device!"
read -p "Do you want to continue [y/N]? " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled"
    exit 1
fi

# Unmount any existing partitions
echo "Unmounting existing partitions..."
for partition in ${EMMC_DEVICE}p*; do
    if [ -b "$partition" ]; then
        umount "$partition" 2>/dev/null || true
    fi
done

# Partition the eMMC
echo "Partitioning eMMC..."
fdisk "$EMMC_DEVICE" << EOF
o
p
n
p
1
2048
+16M
y
t
e
a
n
p
2


y
p
w
EOF

# Wait for partitions to be created
sleep 2

# Format partitions
echo "Formatting partitions..."

# Format boot partition (FAT16)
echo "Formatting boot partition (FAT16)..."
mkfs.vfat -F 16 "${EMMC_DEVICE}p1"

# Format root partition (ext4)
echo "Formatting root partition (ext4)..."
mkfs.ext4 "${EMMC_DEVICE}p2"

# Create mount points
mkdir -p /tmp/boot /tmp/root /tmp/sd_boot

# Mount eMMC partitions
echo "Mounting eMMC partitions..."
mount "${EMMC_DEVICE}p1" /tmp/boot
mount "${EMMC_DEVICE}p2" /tmp/root

# Mount SD card boot partition temporarily
echo "Mounting SD card boot partition..."
mount /dev/mmcblk0p1 /tmp/sd_boot

# Copy boot files from SD card to eMMC
echo "Copying boot files from SD card to eMMC..."
if [ -f "/tmp/sd_boot/MLO" ]; then
    cp /tmp/sd_boot/MLO /tmp/boot/
    echo "MLO copied"
else
    echo "Warning: MLO not found on SD card"
fi

if [ -f "/tmp/sd_boot/u-boot.img" ]; then
    cp /tmp/sd_boot/u-boot.img /tmp/boot/
    echo "u-boot.img copied"
else
    echo "Warning: u-boot.img not found on SD card"
fi

if [ -f "/tmp/sd_boot/zImage" ]; then
    cp /tmp/sd_boot/zImage /tmp/boot/
    echo "zImage copied"
else
    echo "Warning: zImage not found on SD card"
fi

if [ -f "/tmp/sd_boot/am335x-boneblack.dtb" ]; then
    cp /tmp/sd_boot/am335x-boneblack.dtb /tmp/boot/
    echo "Device tree copied"
else
    echo "Warning: Device tree not found on SD card"
fi

# Copy rootfs from current system to eMMC
echo "Copying rootfs from current system to eMMC..."
echo "This may take several minutes..."

# Copy all files from current rootfs to eMMC root partition
# Exclude special filesystems and temporary directories
rsync -a --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/tmp --exclude=/run --exclude=/var/run --exclude=/var/tmp --exclude=/boot / /tmp/root/

echo "Rootfs copied successfully"

# Unmount partitions
echo "Unmounting partitions..."
umount /tmp/boot
umount /tmp/root

# Cleanup
rmdir /tmp/boot /tmp/root

echo ""
echo "eMMC flashing complete!"
echo "You can now reboot to boot from eMMC."
echo ""
echo "To boot from eMMC:"
echo "1. Remove the SD card"
echo "2. Power cycle the BeagleBone Black"
echo "3. The system should boot from eMMC automatically"
echo ""
