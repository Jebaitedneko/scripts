## 1. dtsi_collector.sh ##

### About: ###

Grabs all the DTSIs used to build a device-specific dtb.

This makes rebasing DTSI changes to caf way more easier.

### Usage: ###

First compile the kernel source with a bootable defconfig.

If you're just grabbing from a fresh caf tree, build it using the default CAF defconfig.

Place this script inside the root directory of kernel source.

Open a terminal in kernel rootdir.

`./dtsi_collector.sh dtbname`

A folder with the format KERNEL-DIR-NAME_DTB-NAME would be created outside the kernel dir with all the dtsis used to build that specific dtb.

If unsure about which is the proper name still, open arch/arm(64)/boot/dts/qcom/Makefile and search for parts of the name you found out earlier from DMESG.

### Example: ###

For msm8953 sd625 mido, the dts name is `msm8953-qrd-sku3`.

This can be found out easily by grabbing a DMESG from a normal boot cycle and search for any line with `(DT)` or `MACHINE`.

You should see a similar string. That is the name of the dtb that the kernel uses to identify the hardware layout and configurations of your device.

So here, the usage would be:

`./dtsi_collector.sh msm8953-qrd-sku3`
