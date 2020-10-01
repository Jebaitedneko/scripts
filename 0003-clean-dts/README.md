## 2. cleandts.sh ##

### About: ###

Cleans decompiled dts files to make it easier to diff between two for getting major changes in devicetree.

### Issue addressed: ###

There will be times when you only have two dtb files and just want to quickly check what's different between them.

The only issue is that it's riddled with phandles and other addresses which get slightly shifted which completely messes up the diff detection in almost all diffing programs.

My script just cleans said nuisances and tries to make both of the dts as consistent as possible.

### Usage: ###

`./cleandts.sh your_decompiled_dts_01.dts`
`./cleandts.sh your_decompiled_dts_01.dts`

These will output

your_decompiled_dts_01_diff.dts
your_decompiled_dts_02_diff.dts

Then you can use something like meld to compare the two and get only the relevant changes

You can also put this in your bin folder and use it from anywhere
