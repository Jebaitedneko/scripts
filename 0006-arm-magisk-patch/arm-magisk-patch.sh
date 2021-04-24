#!/bin/bash

# carve out arm header
echo "carving out arm header from ${1} ..."
dd if=$1 of=arm-header bs=1 skip=0 count=$(grep -obUaPHn "\x1F\x8B\x08" $1 | cut -f3 -d ":" | head -n1)
echo "done"

# carve out Image.gz-dtb
echo "carving out Image.gz-dtb from ${1} ..."
dd if=$1 of=Image.gz-dtb bs=1 skip=$(grep -obUaPHn "\x1F\x8B\x08" $1 | cut -f3 -d ":" | head -n1)
echo "done"

# carve out dtbs from Image.gz-dtb
echo "carving out dtbs from Image.gz-dtb ..."
dd if=Image.gz-dtb of=dtbs bs=1 skip=$(echo $(grep -obUaPHn "\xD0\x0D\xFE\xED" $1) | cut -f3 -d ":" | head -n1)
echo "done"

# unpack Image.gz-dtb to Image.gz (dtbs will be ignored, need to be appended later)
echo "gunzip Image.gz-dtb in progress ..."
mv Image.gz-dtb Image.gz # for allowing gunzip to view it
gunzip -N Image.gz
echo "done"

# patch for magisk
# skip_initramfs -> want_initramfs
echo "patching for magisk (skip_initramfs -> want_initramfs) ..."
sed -i "s|\x73\x6b\x69\x70\x5f\x69\x6e\x69\x74\x72\x61\x6d\x66\x73|\x77\x61\x6e\x74\x5f\x69\x6e\x69\x74\x72\x61\x6d\x66\x73|g" Image
echo "done"

# repack Image to Image.gz
echo "gzip Image in progress ..."
gzip -N Image
echo "done"

# apend dtbs to the end of Image.gz
echo "Appending dtbs to the end of Image.gz ..."
cat dtbs >> Image.gz
echo "done"

# now it's Image.gz-dtb
echo "Renaming Image.gz to Image.gz-dtb ..."
mv Image.gz Image.gz-dtb
echo "done"

# apend Image.gz-dtb to the end of arm header
echo "Appending Image.gz-dtb to the end of arm header ..."
cat Image.gz-dtb >> arm-header
echo "done"

# now it's repacked
echo "Renaming to ${1}_repacked"
mv arm-header ${1}_repacked
rm Image.gz-dtb # remove stray file
rm dtbs
echo "done"
