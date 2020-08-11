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

For msm8953 sd625 mido, the master dts name is `msm8953-qrd-sku3`.

This can be found out easily by grabbing a DMESG from a normal boot cycle and search for any line with `(DT)` or `MACHINE`.

You should see a similar string. That is the name of the dtb that the kernel uses to identify the hardware layout and configurations of your device.

So here, the usage would be:

`./dtsi_collector.sh msm8953-qrd-sku3`

### Backstory: ###

So my OEM didn't release kernel sources for oreo and there were quite a few differences between the nougat dts and oreo dts when i compared the extracted ones with meld.

I wanted to create proper overlays by comparing to the DTSIs of best caf base and writing them that way but the dts/qcom folder had way too many DTSIs in there and it was getting difficult to navigate.

I was poking around in the `out/arch/arm64/boot/dts` folder one day and found this file named `.msm8953-qrd-sku3.dtb.d.pre.tmp`.

I opened it looking for any useful info and I was pleasantly surprised. It had the list of all the DTSIs which were parsed by DTC to build the final DTB in out/ so I got to work making a script which formats the aforementioned file and grabs the DTSIs and places them to a folder outside the kernel rootdir.

I did the same with the best caf base for the nougat oem source which i first built with caf defconfig and ran the script with same master dts name as argument. Now I had two folders which had the DTSIs used to build the same dtb in both best caf base and oem base.

I then opened up Meld and did folder diffing for both of them and was able to plan out the changes from there.

You can find the process i adopted in this repo: https://github.com/Jebaitedneko/android_kernel_10or_G/commits/3.18-dtsi-new
