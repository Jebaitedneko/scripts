#!/bin/bash

rom_link="$1"
rom_name=$(echo "$rom_link" | sed 's/.*\///;s/.zip//g')
echo "$rom_name" > info.txt
[ ! -f "${rom_name}.zip" ] && aria2c -j32 "$rom_link" &> /dev/null
unzip -p "${rom_name}.zip" boot.img > boot

[ ! -f unpack_bootimg.py ] && wget "https://android.googlesource.com/platform/system/tools/mkbootimg/+archive/refs/heads/master.tar.gz" &> /dev/null && tar -xf master.tar.gz unpack_bootimg.py && rm master.tar.gz
chmod +x unpack_bootimg.py
python3 unpack_bootimg.py --boot_img boot --out . &> /dev/null

xxd -g 1 kernel | grep "40 71 02 00" -B1 -A8702 | grep -oE "[0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+" > firmware.xxd
xxd -r -p <(sed -n '1,8704p' firmware.xxd      | sed "s/ //g" | tr -d '\n') > j20s_novatek_ts_fw01.bin
xxd -r -p <(sed -n '8705,17408p' firmware.xxd  | sed "s/ //g" | tr -d '\n') > j20s_novatek_ts_mp01.bin
xxd -r -p <(sed -n '17409,26112p' firmware.xxd | sed "s/ //g" | tr -d '\n') > j20s_novatek_ts_fw02.bin
xxd -r -p <(sed -n '26113,34816p' firmware.xxd | sed "s/ //g" | tr -d '\n') > j20s_novatek_ts_mp02.bin

find . -type f -iname "*.bin" -exec avr-objcopy -I binary -O ihex {} {}.ihex \;
sed -i "s/\r//g" ./*.bin
sed -i "s/\r//g" ./*.ihex

md5sum ./*.bin ./*.ihex >> info.txt

ZIPNAME="${rom_name}_FW.zip"
zip -r9 "$ZIPNAME" ./*.bin ./*.ihex info.txt &> /dev/null

rm ./*.bin ./*.ihex info.txt dtb ramdisk boot firmware.xxd kernel

UPLOAD=$(curl -s -F f[]=@"$ZIPNAME" "https://oshi.at" | grep DL | sed 's/DL: //g')
echo -e "$UPLOAD\n" >> .links
