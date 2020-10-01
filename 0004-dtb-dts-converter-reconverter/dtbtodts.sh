#!/bin/bash
for f in $(find . -maxdepth 1 -iname "*.dtb"); do dtc -I dtb -O dts -o ${f/\.dtb/}_extracted.dts $f; done
