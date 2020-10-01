## 2. build.sh ##

### About: ###

Build script and zipping script using GCC-4.9 + CCACHE for legacy devices.

### Advantage: ###

We all know GCC-4.9 is painfully slow to compile with. (well it's been well over 7 years since it's release but there are plenty of legacy devices that need to use it even today)
With CCACHE on Arch i was able to get a consecutive build time of 33s.

### Usage: ###

Edit L#18 in build.sh to point to your device defconfig.

Change L#41 in build.sh to whatever you want the zip name to be.

Change L#30 in build.sh to get Image, Image.gz, Image.gz-dtb or whichever one you want to use

L#32 and L#33 uses DTBTOOL to compile dt.img from dts in out/ so you may or may not need it. Configure as needed.

You can edit anykernel.sh in anykernel dir to change the message to be displayed while flashing (this will be later used instead of the sh in anykernel)

Build will be timed so you can see the difference in consecutive build.

Clone to kernel root (might need to merge the gitignore or ignore it and add the entries from here to the ignore in the kernel)

Run build.sh

Toolchains will be auto-downloaded to ~/android/TOOLS/GCC by default (you can edit this in build.sh XD)
