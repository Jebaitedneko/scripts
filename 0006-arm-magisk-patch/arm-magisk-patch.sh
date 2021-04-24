#!/bin/bash

echo -e "\ncarving out boot-headers from ${1}..."
dd if=$1 of=boot-headers bs=1 skip=0 count=$(grep -obUaPHn "\x00\x00\xA0\xE1\x00\x00" $1 | cut -f3 -d ":" | head -n1)

echo -e "\ncarving out kernel-bits from ${1} ..."
dd if=$1 of=kernel-bits bs=1 skip=$(grep -obUaPHn "\x00\x00\xA0\xE1\x00\x00" $1 | cut -f3 -d ":" | head -n1)

echo -e "\ncarving out arm header from kernel-bits ..."
dd if=kernel-bits of=arm-header bs=1 skip=0 count=$(grep -obUaPHn "\x1F\x8B\x08" kernel-bits | cut -f3 -d ":" | head -n1)

echo -e "\ncarving out Image.gz-dtb from kernel-bits ..."
dd if=kernel-bits of=Image.gz-dtb bs=1 skip=$(grep -obUaPHn "\x1F\x8B\x08" kernel-bits | cut -f3 -d ":" | head -n1)

rm kernel-bits

echo -e "\ncarving out dtbs from Image.gz-dtb ..."
dd if=Image.gz-dtb of=dtbs bs=1 skip=$(grep -obUaPHn "\xD0\x0D\xFE\xED" Image.gz-dtb | cut -f3 -d ":" | head -n1)

echo -e "\ngunzip Image.gz-dtb in progress ..."
mv Image.gz-dtb Image.gz
gunzip -N Image.gz

echo -e "\npatching for magisk (skip_initramfs -> want_initramfs) ..."
sed -i "s|\x73\x6b\x69\x70\x5f\x69\x6e\x69\x74\x72\x61\x6d\x66\x73|\x77\x61\x6e\x74\x5f\x69\x6e\x69\x74\x72\x61\x6d\x66\x73|g" Image

echo -e "\ngzip Image in progress ..."
gzip -N9 Image

echo -e "\nAppending dtbs to the end of Image.gz ..."
cat dtbs >> Image.gz && rm dtbs

echo -e "\nRenaming Image.gz to Image.gz-dtb ..."
mv Image.gz Image.gz-dtb

echo -e "\nAppending Image.gz-dtb to the end of arm header ..."
cat Image.gz-dtb >> arm-header && rm Image.gz-dtb

echo -e "\nAppending arm-header to the end of boot-headers ..."
cat arm-header >> boot-headers && rm arm-header

echo -e "\nRenaming to ${1::-4}_repacked.img"
mv boot-headers ${1::-4}_repacked.img
