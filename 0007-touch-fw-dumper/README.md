## 7. dump_touch_fw.sh ##

### About: ###
dump touch fw for poco x3 pro from an input direct fastboot rom link

### Usage: ###

1. `curl -LSsO https://github.com/Jebaitedneko/scripts/raw/master/0007-touch-fw-dumper/dump_touch_fw.sh`
2. `chmod +x dump_touch_fw.sh`
3. `./dump_touch_fw.sh direct_rom_link_here`

### NOTE ###

You can provide `u` as second argument to the script to upload each zipped fw

You can provide `k` as the third argument to the script to keep fw.xxd and kernel image

#### COLAB INSTANCE ####
<a href="https://colab.research.google.com/github/Jebaitedneko/scripts/blob/master/0007-touch-fw-dumper/touchfw_uploader.ipynb" target="_parent"><img src="https://colab.research.google.com/assets/colab-badge.svg" alt="Launch In Colab"/></a>

1. Run Cell 1
2. Open Files tab from left sidebar
3. Drop a file named `.src` with direct links for roms with boot.img, line by line
4. Run Cell 2
5. Wait a bit until the fw are zipped and links generated to `links.txt` file
