#!/bin/bash
for f in $(find . -maxdepth 1 -iname "*.dts"); do dtc -I dts -O dtb -o ${f/\.dts/}_recompiled.dtb $f; done
