#!/bin/bash
set -x && cd ~
rpmdev-setuptree
[[ ! -f $(cat .kernel-rpm) ]] && yumdownloader --source kernel | grep -oE "kernel-.*.rpm" > .kernel-rpm
sudo yum-builddep $(cat .kernel-rpm)
rpm -Uvh $(cat .kernel-rpm)
cd ~/rpmbuild/SPECS
rpmbuild -bp --target=$(uname -m) kernel.spec > .kernel-rpm-build
cd ~/rpmbuild/BUILD/$(cat .kernel-rpm-build | grep -oE "kernel-.*/linux-.*.x86_64" | tail -n1)

kver=$(uname -a | cut -f3 -d' ' | cut -f1 -d'-')
version=$(echo $kver | cut -f1 -d.)
patchlevel=$(echo $kver | cut -f2 -d.)
sublevel=$(echo $kver | cut -f3 -d.)
extraver=$(uname -a | cut -f3 -d' ' | cut -f2 -d'-')
sed -i "s/^VERSION =.*/VERSION = ${version}/g" Makefile
sed -i "s/^PATCHLEVEL =.*/PATCHLEVEL = ${patchlevel}/g" Makefile
sed -i "s/^SUBLEVEL =.*/SUBLEVEL = ${sublevel}/g" Makefile
sed -i "s/^EXTRAVERSION =.*/EXTRAVERSION = -${extraver}/g" Makefile
cp configs/kernel-${kver}-x86_64.config .config
echo -e "\nCONFIG_ACPI_EC_DEBUGFS=m" >> .config
make modules_prepare

xzcat /boot/symvers-$(uname -r).xz | grep "drivers/acpi" > drivers/acpi/Module.symvers
xzcat /boot/symvers-$(uname -r).xz > Module.symvers
make M=drivers/acpi modules
cp drivers/acpi/ec_sys.ko ~

xzcat /boot/symvers-$(uname -r).xz | grep "drivers/media/usb/uvc" > drivers/media/usb/uvc/Module.symvers
( cd drivers/media/usb/uvc && patch -Np1 < ~/uvc_driver.patch )
make M=drivers/media/usb/uvc modules
UVC_ORIGINAL=$(find /usr/lib/modules/$(uname -r) -type f -iname "*uvcvideo*")
UVC_ORIGNAL_BASENAME=$(basename "$UVC_ORIGINAL")
UVC_ORIGNAL_DIRNAME=$(dirname "$UVC_ORIGINAL")
xz -z drivers/media/usb/uvc/uvcvideo.ko
sudo cp drivers/media/usb/uvc/uvcvideo.ko.xz "$UVC_ORIGNAL_DIRNAME"

# make binrpm-pkg
cd ~ && set +x
