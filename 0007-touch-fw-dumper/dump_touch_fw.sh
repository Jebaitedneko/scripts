#!/bin/bash

ROM_LINK="$1"

ROM_NAME=$(echo "$ROM_LINK" | sed 's/.*\///;s/.zip//g')
ROM_NAME_MIN="$(echo "$ROM_NAME" | sed 's/miui_VAYU//g;s/Global//g;s/^_/GL_/g')"

if [ ! -d "$ROM_NAME_MIN" ]; then
	mkdir -p "$ROM_NAME_MIN"
fi

if [ ! -f unpack_bootimg.py ]; then
	wget "https://android.googlesource.com/platform/system/tools/mkbootimg/+archive/refs/heads/master.tar.gz" &> /dev/null
	tar -xf master.tar.gz unpack_bootimg.py && chmod +x unpack_bootimg.py && rm master.tar.gz
fi

cd "$ROM_NAME_MIN"

echo "$ROM_NAME" > info.txt

if [ ! -f "${ROM_NAME}.zip" ]; then
	aria2c -j32 "$ROM_LINK" &> /dev/null
fi

unzip -p "${ROM_NAME}.zip" boot.img > boot

python3 "../unpack_bootimg.py" --boot_img boot --out . &> /dev/null

xxd -g 1 kernel | grep "40 71 02 00" -B1 -A8702 | grep -oE "[0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+ [0-9a-f]+" > firmware.xxd

xxd -r -p <(sed -n '1,8704p'      firmware.xxd | sed "s/ //g" | tr -d '\n') > j20s_novatek_ts_fw01.bin
xxd -r -p <(sed -n '8705,17408p'  firmware.xxd | sed "s/ //g" | tr -d '\n') > j20s_novatek_ts_mp01.bin
xxd -r -p <(sed -n '17409,26112p' firmware.xxd | sed "s/ //g" | tr -d '\n') > j20s_novatek_ts_fw02.bin
xxd -r -p <(sed -n '26113,34816p' firmware.xxd | sed "s/ //g" | tr -d '\n') > j20s_novatek_ts_mp02.bin

sed -i "s/\r//g" ./*.bin

find . -type f -iname "*.bin" -exec avr-objcopy -I binary -O ihex {} {}.ihex \;

sed -i "s/\r//g" ./*.ihex

md5sum ./*.bin ./*.ihex >> info.txt

ZIPNAME="${ROM_NAME_MIN}_TOUCH_FW.zip"
zip -r9 "$ZIPNAME" ./*.bin ./*.ihex info.txt firmware.xxd kernel &> /dev/null

rm ./*.bin ./*.ihex info.txt dtb ramdisk boot firmware.xxd kernel "${ROM_NAME}.zip"

if [[ $2 != '' && $2 == 'u' ]]; then
	UPLOAD=$(curl -s -F f[]=@"$ZIPNAME" "https://oshi.at" | grep DL | sed 's/DL: //g')
	echo -e "$UPLOAD\n" >> ../links.txt
fi

mv "$ZIPNAME" ../

cd ../

rm -rf "$ROM_NAME_MIN"
