#!/bin/bash
fol=${PWD##*/}_${1}
[ -d ../$fol ] && rm -rf ../$fol && mkdir -p ../$fol || mkdir -p ../$fol
cat out/arch/arm64/boot/dts/qcom/".$1.dtb.d.pre.tmp" | sort -u | grep -v ".o:" | grep -v "\.h" | grep "\.dts" | sed -e 's/ ..\///g' -e 's/ \\//g' | grep -v "skeleton" | xargs cp -r -t ../$fol
