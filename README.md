# bonehubOS Meta Layer

[![Yocto Project](https://img.shields.io/badge/Yocto%20Project-styhead-brightgreen.svg)](https://www.yoctoproject.org/)
[![BeagleBone Black](https://img.shields.io/badge/BeagleBone%20Black-Supported-blue.svg)](https://beagleboard.org/black)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](COPYING.MIT)

## Overview

bonehubOS is a custom Yocto Project distribution designed specifically for the BeagleBone Black, featuring USB gadget support for easy development and deployment.

## Features

### 🔌 USB Gadget Support
- **Ethernet over USB** - Connect via USB cable for network access
- **SSH over USB** - Secure shell access without external network hardware
- **ConfigFS Integration** - Dynamic USB gadget configuration
- **Automatic Setup** - USB gadget configured on boot

### 🖥️ System Features
- **Custom Init System** - Optimized for embedded development
- **TTY Configuration** - Proper serial console setup for BBB
- **SSH Server** - Ready-to-use remote access
- **Package Management** - Extensible package system

### 🚀 Development Ready
- **Fast Boot** - Optimized startup sequence
- **Debug Support** - Comprehensive logging and debugging tools
- **Extensible** - Easy to add custom packages and configurations

## Quick Start

### Prerequisites
- Yocto Project build environment (styhead branch)
- BeagleBone Black hardware
- USB Type-A to Micro-B cable

### Build Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/meta-bonehub.git
   cd meta-bonehub
   ```

2. **Add the layer to your build**
   ```bash
   bitbake-layers add-layer /path/to/meta-bonehub
   ```

3. **Configure your build**
   ```bash
   # In conf/local.conf
   MACHINE = "beaglebone-yocto"
   DISTRO = "bonehubos"
   ```

4. **Build the image**
   ```bash
   bitbake core-image-base
   ```

5. **Flash to SD card**
   ```bash
   # Use the generated WIC image
   sudo dd if=core-image-base-beaglebone-yocto.rootfs.wic of=/dev/sdX bs=4M
   ```

### First Boot

1. **Insert SD card** into BeagleBone Black
2. **Connect USB cable** to your host computer
3. **Power on** the BeagleBone Black
4. **Wait for boot** (LEDs will indicate boot progress)
5. **SSH to device**
   ```bash
   ssh -o StrictHostKeyChecking=no root@192.168.7.2
   ```

## Architecture

```
BeagleBone Black (bonehubOS)          Host Computer
┌─────────────────────────┐          ┌─────────────────────────┐
│                         │          │                         │
│  ConfigFS USB Gadget    │◄────────►│  USB Ethernet Device    │
│  - RNDIS Function       │   USB    │  - Network Interface    │
│  - IP: 192.168.7.2      │  Cable   │  - IP: 192.168.7.1     │
│  - SSH Server           │          │  - SSH Client           │
│                         │          │                         │
└─────────────────────────┘          └─────────────────────────┘
```

## Layer Structure

```
meta-bonehub/
├── conf/
│   ├── distro/
│   │   └── bonehubos.conf          # Distribution configuration
│   └── machine/
│       └── beaglebone-yocto.conf   # Machine-specific settings
├── recipes-core/
│   ├── base-files/
│   │   ├── base-files_%.bbappend   # USB gadget init script
│   │   └── files/
│   │       └── usb-gadget-init     # USB gadget setup script
│   ├── busybox/
│   │   └── busybox-inittab_%.bbappend  # TTY configuration
│   └── images/
│       └── core-image-base.bbappend    # Image customization
└── README.md
```

## Configuration

### USB Gadget Settings
- **Vendor ID**: 0x1d6b (Linux Foundation)
- **Product ID**: 0x0104 (Multifunction Composite Gadget)
- **Network IP**: 192.168.7.2/24
- **SSH Port**: 22

### Serial Console
- **Device**: ttyS0
- **Baud Rate**: 115200
- **Configuration**: Optimized for BeagleBone Black

## Development

### Adding Custom Packages
```bitbake
# In your recipe
DESCRIPTION = "My custom package"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=..."

SRC_URI = "file://source.tar.gz"
S = "${WORKDIR}"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/my-app ${D}${bindir}/
}
```

### Modifying USB Gadget Configuration
Edit `meta-bonehub/recipes-core/base-files/files/usb-gadget-init` to customize:
- USB device strings
- Network configuration
- Additional USB functions

## Troubleshooting

### Common Issues

**USB gadget not appearing**
```bash
# Check if configfs is mounted
mount | grep configfs

# Check USB gadget status
ls /sys/kernel/config/usb_gadget/
```

**SSH connection refused**
```bash
# Check if SSH daemon is running
ps aux | grep sshd

# Check network interface
ifconfig usb0
```

**TTY errors on boot**
```bash
# Check serial console configuration
cat /etc/inittab | grep tty
```

### Debug Commands
```bash
# Check system status
systemctl status
dmesg | tail -20

# Check USB gadget
lsusb
cat /sys/kernel/config/usb_gadget/g1/UDC

# Check network
ip addr show
ip route show
```

## Version History

### [1.0.0] - 2024-08-16
- **Initial release** with USB gadget support
- **SSH over USB** functionality
- **TTY configuration** for BeagleBone Black
- **Base system** integration

### [1.1.0] - Planned
- **Systemd migration** for modern init system
- **NetworkManager integration** for advanced networking
- **udev integration** for better device management

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [COPYING.MIT](COPYING.MIT) file for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/meta-bonehub/issues)
- **Documentation**: [Wiki](https://github.com/yourusername/meta-bonehub/wiki)
- **Community**: [Discussions](https://github.com/yourusername/meta-bonehub/discussions)

## Acknowledgments

- [Yocto Project](https://www.yoctoproject.org/) for the build system
- [BeagleBoard.org](https://beagleboard.org/) for the hardware platform
- [Texas Instruments](https://www.ti.com/) for the AM335x SoC

---

**Made with ❤️ for the embedded Linux community**
