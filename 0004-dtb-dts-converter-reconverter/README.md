## 4. dtstodtb.sh dtbtodts.sh ##

### About: ###

Converts all .dtb in current dir to .dts and .dts in current dir to .dtb

PS: non-recursive so dw about it going to places you don't want it to go to XD

### Usage: ###

`cd dir_with_dtb_or_dts`
`./dtbtodts.sh`
`./dtstodtb.sh`

These will output

your_decompiled_dts_01_extracted.dts
your_decompiled_dts_02_recompiled.dtb

Respectively.

Then you can use the 0003-clean-dts script to cleanup the extracted ones for diffing if you want to,

You can also put this in your bin folder and use it from anywhere
