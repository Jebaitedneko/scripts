## 5. catdtb.sh ##

### About: ###

Ever had a moment where you forgot to add some overlay change but your kernel build started already and you're too lazy to recompile just to add that one small change ?

Well look no further lol you can just use this to lazily append the modified dtb to the compiled kernel image (Image.gz)

### Usage: ###

Grab "Image.gz" from out/arch/arm64/boot.

Redo the build with `make dtbs` command.

This will only compile the final dtb using the modded overlay.

Grab the new dtb from out/arch/arm64/boot/dts/qcom/whatever.dtb

Copy it over to the same dir where you copied Image.gz from earlier.

Run

`./catdtb.sh`

This will output

Image.gz-dtb

Aaand there you have it XD flash away and happy building :D
