#!/bin/sh -e
DEV=$1
docker run --pull always --rm -it -v "$PWD":/input -v "$PWD"/output:/output --env-file rpi_alpine_k3s_img.env ghcr.io/raspi-alpine/builder
if [[ -z $DEV ]]
then
  echo "Error: missing device (e.g. /dev/sdc)"
  exit 1
fi
echo "Writing image to $DEV..."
gunzip -c output/sdcard.img.gz | sudo dd of=$DEV
echo "Done writing image to $DEV - the device can be removed"
