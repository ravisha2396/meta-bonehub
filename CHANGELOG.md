# Changelog

All notable changes to the bonehubOS meta layer will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Systemd migration for modern init system
- NetworkManager integration for advanced networking
- udev integration for better device management
- Package manager integration
- ISP gateway routing via USB interface

## [1.0.0] - 2024-08-16

### Added
- Initial bonehubOS distribution configuration
- USB gadget support with ConfigFS integration
- RNDIS (Ethernet over USB) functionality
- SSH server with automatic host key generation
- Custom TTY configuration for BeagleBone Black
- USB gadget initialization script (`/etc/init.d/usb-gadget-init`)
- Automatic USB network interface setup (192.168.7.2/24)
- ConfigFS mount point in `/etc/fstab`
- Init script integration via `busybox-inittab` override
- Base-files integration for system configuration

### Changed
- Modified `SERIAL_CONSOLES` to use only `ttyS0` (removed `ttyO0` and `ttyAMA0`)
- Updated `core-image-base` to include SSH packages and USB utilities
- Configured `busybox-inittab` for proper serial console setup
- Enhanced base-files installation with custom init scripts

### Fixed
- TTY configuration issues causing boot errors
- USB gadget file installation path problems
- Shell compatibility issues (changed from bash to sh)
- Build system integration and dependency resolution

### Technical Details
- **USB Gadget Configuration**:
  - Vendor ID: 0x1d6b (Linux Foundation)
  - Product ID: 0x0104 (Multifunction Composite Gadget)
  - Network Interface: usb0
  - IP Address: 192.168.7.2/24
  - SSH Port: 22
- **Serial Console**: ttyS0 at 115200 baud
- **Init System**: mdev-busybox with custom configuration
- **Build System**: Yocto Project styhead branch

### Dependencies
- meta (core)
- meta-poky
- meta-yocto-bsp
- Yocto Project styhead branch

### Known Issues
- Limited to mdev-busybox init system (planned migration to systemd)
- Manual network configuration on host side required
- No persistent USB gadget configuration across reboots

---

## Version Information

### Build Environment
- **Yocto Project**: styhead branch
- **Poky**: styhead branch
- **Meta**: styhead branch
- **Target**: BeagleBone Black (AM335x)

### Layer Information
- **Layer Name**: meta-bonehub
- **Layer Priority**: 10
- **Compatibility**: styhead
- **Dependencies**: core, yocto-bsp

### Distribution Information
- **Distro Name**: bonehubOS
- **Distro Version**: 1.0.0
- **Init Manager**: mdev-busybox
- **Device Manager**: busybox-mdev
- **Login Manager**: busybox
