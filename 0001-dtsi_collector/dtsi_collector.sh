#!/bin/bash
fol=${PWD##*/}_${1}
[ -d ../$fol ] && rm -rf ../$fol && mkdir -p ../$fol || mkdir -p ../$fol

magic=`cat out/arch/arm64/boot/dts/qcom/".$1.dtb.d.pre.tmp" | \
cut -f 2 -d ':' | \
sed -e "s/ ..\///g" -e "s/ \///g" | \
grep -v "skeleton" |
cut -f 1 -d '\' |
sort -u`

cmd=$(for l in $magic; do echo $l; done)

cp --parents $cmd ../$fol

( cd ../$fol; git init; git add .; git commit -m "init" )
