# Raspberry Pi Image Builder
This directory contains all the scripts and configuration files to build
an image for Raspberry pi 3 + 4 (arm64). The OS is alpine. Kubernetes is installed
using k3s, and the cluster is configured and managed using ansible.

The filesystem layout is unique and provides an A/B switch over mechanism for 
upgrades.

## Upgrades
After running `./build_image.sh` two images are created in the `./output`
directory:
1. `sdcard.img.gz`: complete SD card image for the raspberry
2. `sdcard_update.img.gz`: image of root partition to update running raspberry

use the `sdcard_update.img.gz` to write to the other filesystem.
The script `update_os_ab_flash.sh` can be used to write to the other filesystem
after moving the update image to the host system.

# Updates
Updates can be found [here](https://github.com/raspi-alpine/builder)
