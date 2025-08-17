IMAGE_INSTALL:append = " \
    usbutils \
    util-linux \
    procps \
    python3 \
    opkg \
    opkg-utils \
    net-tools \
    iproute2 \
    openssh \
    openssh-sftp-server \
    busybox-mdev \
    busybox-syslog \
    busybox-udhcpc \
"
IMAGE_FEATURES:append = " ssh-server-openssh"
