# meta-bonehub/recipes-core/images/core-image-base.bbappend
IMAGE_INSTALL:append = " \
    systemd \
    systemd-serialgetty \
    packagegroup-core-boot \
    openssh \
    openssh-sftp-server \
    openssh-sshd \
    usbutils \
    util-linux \
    procps \
    python3 \
    opkg \
    opkg-utils \
    net-tools \
    iproute2 \
    e2fsprogs \
    e2fsprogs-mke2fs \
    dosfstools \
    sudo \
    rsync \
"

IMAGE_FEATURES:append = " ssh-server-openssh"

# Remove busybox packages that conflict with systemd
IMAGE_INSTALL:remove = "busybox-mdev busybox-syslog busybox-udhcpc"