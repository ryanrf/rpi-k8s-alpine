#!/bin/sh -e

# make sure resize is already done
if [ -f /data/resize_done ] && [ -f /etc/fstab.update ]
then
  logger -t "rc.bindmounts" "/data resized and fstab.update found to install"
  mount -o remount,rw /
  cat /etc/fstab.update >> /etc/fstab && rm -f /etc/fstab.update
  mount -o remount,ro /
fi
