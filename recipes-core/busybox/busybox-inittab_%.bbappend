FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Force SERIAL_CONSOLES to only include ttyS0
SERIAL_CONSOLES:forcevariable = "115200;ttyS0"

do_install:append() {
    # Add USB gadget init to inittab
    echo "# Start USB Gadget and SSH" >> ${D}${sysconfdir}/inittab
    echo "::sysinit:/etc/init.d/usb-gadget-init" >> ${D}${sysconfdir}/inittab
}
