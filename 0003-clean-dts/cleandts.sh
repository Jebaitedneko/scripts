#!/bin/bash
clean() {
cp $1 ${1::-4}_diff.dts
sed -i 's/linux\,phandle \= [<]0x[0-9 A-Z a-z]*[>][;]//g' ${1::-4}_diff.dts
sed -i 's/phandle \= [<]0x[0-9 A-Z a-z]*[>][;]//g' ${1::-4}_diff.dts
sed -i 's/0x00/0x0/g' ${1::-4}_diff.dts
sed -i 's/okay/ok/g' ${1::-4}_diff.dts
sed -i 's/fragment@\([0-9]*\)/fragment/g' ${1::-4}_diff.dts
sed -i 's/[ \t]*$//' ${1::-4}_diff.dts
awk 'BEGIN{RS="";ORS="\n\n"}1' ${1::-4}_diff.dts > ${1::-4}_diff_final.dts && rm ${1::-4}_diff.dts && mv ${1::-4}_diff_final.dts ${1::-4}_diff.dts
sed -i 's/[ \t]*$//' ${1::-4}_diff.dts
}

clean $1
