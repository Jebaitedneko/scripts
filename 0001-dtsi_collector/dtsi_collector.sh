#!/bin/bash

folder=${PWD##*/}_${1}
[ -d ../$folder ] && rm -rf ../$folder && mkdir -p ../$folder || mkdir -p ../$folder

if [[ $(find out/arch/arm64/boot/dts/qcom -type f -iname ".$1.dtbo.d.pre.tmp") ]]; then
	echo -e "\nDTBO Target Detected."
	file=".$1.dtbo.d.pre.tmp"
else
	if [[ $(find out/arch/arm64/boot/dts/qcom -type f -iname ".$1.dtb.d.pre.tmp") ]]; then
		echo -e "\nDTB Target Detected."
		file=".$1.dtb.d.pre.tmp"
	fi
fi

echo "
$(
	cat out/arch/arm64/boot/dts/qcom/"$file" | \
	cut -f 2 -d ':' | \
	sed -e "s/ ..\///g" -e "s/ \///g" | \
	grep -v "skeleton" |
	cut -f 1 -d '\' |
	sort -u
)
" | while read file; do cp --parents $file ../$folder; done

( cd ../$folder; git init; git add .; git commit -m "init" )
