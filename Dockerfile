FROM debian:11
LABEL maintainer='iYong'
RUN echo 'deb http://mirrors.aliyun.com/debian bullseye main\ndeb http://mirrors.aliyun.com/debian-security bullseye-security main\ndeb http://mirrors.aliyun.com/debian bullseye-updates main' >/etc/apt/sources.list \
    && apt update -y \
    && apt install -y gconf2 qemu-system-arm qemu-utils qemu-efi ipxe-qemu libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager seabios vgabios gir1.2-spiceclientgtk-3.0 xauth \
    && apt install -y fonts-noto* xz-utils vim wget \
    && apt install -y openssh-server \
    && sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config \
    && sed -i "s/#Port 22/Port 1022/g" /etc/ssh/sshd_config && sed -i "s/#X11Forwarding yes/X11Forwarding yes/g" /etc/ssh/sshd_config \
    && sed -i "s/#X11DisplayOffset/X11DisplayOffset/g" /etc/ssh/sshd_config && sed -i "s/#X11UseLocalhost yes/X11UseLocalhost no/g" /etc/ssh/sshd_config \
    && sed -i 's/#user = "root"/user = "root"/' /etc/libvirt/qemu.conf && sed -i 's/#group = "root"/group = "root"/' /etc/libvirt/qemu.conf \
    && echo 'root:debian' | chpasswd \
    && echo '#!/bin/bash\nLOGTIME=$(date "+%Y-%m-%d %H:%M:%S")\necho "[$LOGTIME] startup run..."\nservice ssh start\nlibvirtd -d && virtlogd -d' >/init.sh && chmod +x /init.sh \
    && echo 'if [ -f /init.sh ]; then\n      ./init.sh\nfi' >>/root/.bashrc
