#!/bin/bash

if [[ $1 == "" ]]; then
	echo -e "\nProvide DTB/DTBO Target Name" && exit
fi

if [[ $2 == "" ]]; then
	echo -e "\nSearching in arch/arm64/boot/dts/qcom by default."
	DTS_DIR="qcom"
else
	DTS_DIR=$2
fi

if [[ ! -d "out/arch/arm64/boot/dts/$DTS_DIR" ]]; then
	echo "$DTS_DIR is invalid. try again." && exit
fi

file=""
if [[ $(find out/arch/arm64/boot/dts/$DTS_DIR -type f -iname ".$1.dtbo.d.pre.tmp") ]]; then
	echo -e "\nDTBO Target Detected at $DTS_DIR\n"
	file=".$1.dtbo.d.pre.tmp"
else
	if [[ $(find out/arch/arm64/boot/dts/$DTS_DIR -type f -iname ".$1.dtb.d.pre.tmp") ]]; then
		echo -e "\nDTB Target Detected at $DTS_DIR\n"
		file=".$1.dtb.d.pre.tmp"
	fi
fi

if [[ $file == "" ]]; then
	echo "$1 not found. try again." && exit
fi

folder=${PWD##*/}_${1}
[ -d ../$folder ] && rm -rf ../$folder && mkdir -p ../$folder || mkdir -p ../$folder

echo "
$(
	cat out/arch/arm64/boot/dts/$DTS_DIR/"$file" | \
	cut -f2 -d ':' | \
	sed "s/ ..\///g;s/ \///g" | \
	cut -f1 -d '\' |
	sort -u
)
" | column -t | while read file; do echo -e "Copying $file"; cp --parents $file ../$folder; done

( cd ../$folder; git init; git add .; git commit -m "init" ) &> /dev/null

echo -e "\nInitialized Git Repo Over At $(pwd)/../$folder"
