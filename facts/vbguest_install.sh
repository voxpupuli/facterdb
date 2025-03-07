#!/bin/bash

vbox=$(lsmod | grep -c vboxsf)
version=${1:-7.1.6}

if [[ $vbox -eq 0 ]]; then
    wget https://download.virtualbox.org/virtualbox/${version}/VBoxGuestAdditions_${version}.iso
    dnf install -y epel-release
    dnf install -y dkms gcc make kernel-devel bzip2 binutils patch libgomp glibc-headers glibc-devel kernel-headers elfutils-libelf-devel
    mount VBoxGuestAdditions_${version}.iso /mnt
    /mnt/VBoxLinuxAdditions.run --accept
fi
