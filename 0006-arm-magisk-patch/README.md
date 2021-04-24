## 6. arm-magisk-patch.sh ##

### About: ###
kernel patcher for arm devices
input file should be Image.gz, zImage or Image.gz-dtb (or equivalent)

### Usage: ###
1. `git clone https://github.com/SebaUbuntu/AIK-Linux-mirror AIK && cd AIK`
2. copy over stock boot image into AIK dir as boot.img
3. `./unpackimg.sh boot.img`
4. `cd split_img`
5. `curl -LSsO https://github.com/Jebaitedneko/scripts/raw/master/0006-arm-magisk-patch/arm-magisk-patch.sh`
6. `chmod +x arm-magisk-patch.sh`
7. `./arm-magisk-patch.sh boot.img-zImage`
8. delete old boot.img-zImage and rename boot.img-zImage_repacked to boot.img-zImage
9. `cd ..`
10. `./repackimg.sh`
11. repacked image will be image-new.img
