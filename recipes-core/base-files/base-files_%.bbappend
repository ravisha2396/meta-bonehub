
# meta-bonehub/recipes-core/base-files/base-files_%.bbappend
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://usb-gadget.service file://usb-gadget-init file://sd-card-flasher.sh"

# Add bash dependency since sd-card-flasher.sh requires /bin/bash
RDEPENDS:${PN} += "bash"

do_install:append() {
    # Install systemd service
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/usb-gadget.service ${D}${systemd_system_unitdir}/
    
    # Install setup script
    install -d ${D}${bindir}
    install -m 0755 ${S}/usb-gadget-init ${D}${bindir}/
    
    # Enable service
    install -d ${D}${systemd_system_unitdir}/multi-user.target.wants
    ln -sf ../usb-gadget.service ${D}${systemd_system_unitdir}/multi-user.target.wants/
    
    # Add configfs entry to existing fstab
    echo "configfs  /sys/kernel/config  configfs  defaults  0  0" >> ${D}${sysconfdir}/fstab
    
    # Create SSH directories
    install -d ${D}/var/run/sshd
    install -d ${D}/var/empty
    chmod 755 ${D}/var/run/sshd
    chmod 755 ${D}/var/empty
    
    # Create /home/root directory and install eMMC flasher
    install -d ${D}/home/root
    install -m 0755 ${S}/sd-card-flasher.sh ${D}/home/root/
    chmod 755 ${D}/home/root
}