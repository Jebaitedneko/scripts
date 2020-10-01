#!/bin/bash
for f in $(find . -maxdepth 1 -iname "*.dtb"); do cat $f >> $1; done
mv $1 Image.gz-dtb
