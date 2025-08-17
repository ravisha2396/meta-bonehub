FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://usb-gadget-init"

do_install:append() {
    # Install USB gadget init script
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${S}/usb-gadget-init ${D}${sysconfdir}/init.d/
    
    # Add configfs entry to existing fstab
    echo "configfs  /sys/kernel/config  configfs  defaults  0  0" >> ${D}${sysconfdir}/fstab
    
    # Create SSH directories
    install -d ${D}/var/run/sshd
    install -d ${D}/var/empty
    chmod 755 ${D}/var/run/sshd
    chmod 755 ${D}/var/empty
    
    # Create rc.d directory and symlink
    install -d ${D}${sysconfdir}/rc.d
    ln -sf ../init.d/usb-gadget-init ${D}${sysconfdir}/rc.d/S40usb-gadget
}
