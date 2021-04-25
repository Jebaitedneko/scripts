#!/bin/bash

echo -e "\ncarving out headers from ${1}..."
dd if=$1 of=headers bs=1 skip=0 count=$(grep -obaP "\x1F\x8B\x08" $1 | cut -f1 -d ":" | head -n1)

echo -e "\ncarving out Image.gz-dtb from ${1} ..."
dd if=$1 of=Image.gz-dtb bs=1 skip=$(grep -obaP "\x1F\x8B\x08" $1 | cut -f1 -d ":" | head -n1)

echo -e "\ncarving out dtbs from ${1} ..."
dd if=$1 of=dtbs bs=1 skip=$(grep -obaP "\xD0\x0D\xFE\xED" Image.gz-dtb | cut -f1 -d ":" | head -n1)

echo -e "\ngunzip Image.gz-dtb in progress ..."
mv Image.gz-dtb Image.gz && gunzip -N Image.gz

echo -e "\npatching for magisk (skip_initramfs -> want_initramfs) ..."
sed -i "s|\x73\x6b\x69\x70\x5f\x69\x6e\x69\x74\x72\x61\x6d\x66\x73|\x77\x61\x6e\x74\x5f\x69\x6e\x69\x74\x72\x61\x6d\x66\x73|g" Image

echo -e "\ngzip Image in progress ..."
gzip -N9 Image

echo -e "\nAppending dtbs to the end of Image.gz ..."
cat dtbs >> Image.gz && rm dtbs && mv Image.gz Image.gz-dtb

echo -e "\nAppending Image.gz-dtb to the end of arm header ..."
cat Image.gz-dtb >> headers && rm Image.gz-dtb

echo -e "\nRenaming to ${1::-4}_repacked.img"
mv headers ${1::-4}_repacked.img
