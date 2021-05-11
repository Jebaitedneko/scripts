#!/bin/bash

folder=${PWD##*/}_${1}
[ -d ../$folder ] && rm -rf ../$folder && mkdir -p ../$folder || mkdir -p ../$folder

if [[ $1 == "" ]]; then
	echo -e "\nProvide DTB/DTBO Target Name" && exit
fi

if [[ $(find out/arch/arm64/boot/dts/qcom -type f -iname ".$1.dtbo.d.pre.tmp") ]]; then
	echo -e "\nDTBO Target Detected\n"
	file=".$1.dtbo.d.pre.tmp"
else
	if [[ $(find out/arch/arm64/boot/dts/qcom -type f -iname ".$1.dtb.d.pre.tmp") ]]; then
		echo -e "\nDTB Target Detected\n"
		file=".$1.dtb.d.pre.tmp"
	fi
fi

echo "
$(
	cat out/arch/arm64/boot/dts/qcom/"$file" | \
	cut -f2 -d ':' | \
	sed "s/ ..\///g;s/ \///g" | \
	cut -f1 -d '\' |
	sort -u
)
" | column -t | while read file; do echo -e "Copying $file"; cp --parents $file ../$folder; done

( cd ../$folder; git init; git add .; git commit -m "init" ) &> /dev/null

echo -e "\nInitialized Git Repo Over At $(pwd)/../$folder"
