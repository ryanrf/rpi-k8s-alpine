#!/bin/sh -e
#
#

DEV=$2

usage(){
  echo "Usage: ./build_image.sh [build|write|all] [device]"
  echo "  build - just build the image and save it to the 'output dir'"
  echo "  write - just write the existing image in the 'output' dir to  the specified device"
  echo "  all - build the image, write the file to the 'output' dir then write that image to the specified device"
  exit 0
}

WRITE="no"
BUILD="no"
case "$1" in
  all)
    WRITE="yes"
    BUILD="yes"
    echo "Building image and writing to device"
    ;;
  write)
    WRITE="yes"
    echo "Writing existing image to device"
    ;;
  build)
    BUILD="yes"
    echo "Building image without writing to device"
    ;;
  *)
    echo "That action is not defined"
    usage
    ;;
esac

if [ $BUILD == "yes" ]
then
  docker run --pull always --rm -it -v "$PWD":/input -v "$PWD"/output:/output --env-file rpi_alpine_k3s_img.env ghcr.io/raspi-alpine/builder
 [ $WRITE == "no" ] && exit 0
fi  

if [[ -z $DEV ]]
then
  echo "Error: missing device (e.g. /dev/sdc)"
  exit 1
elif [ $WRITE == "yes" ]
then
  echo "Writing image to $DEV..."
  gunzip -c output/sdcard.img.gz | sudo dd of=$DEV
  echo "Done writing image to $DEV - the device can be removed"
else
  echo "This is a condition I didn't plan for..."
fi
