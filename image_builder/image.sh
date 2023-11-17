#!/bin/sh
set -e

install_pkg(){
  PKG="$@"
  echo "Installing $PKG..."
  chroot_exec apk add --no-cache $PKG
  echo "Done"
}

install_pkg_from_testing(){
  PKG="$@"
  echo "Installing $PKG..."
  chroot_exec apk add --no-cache $PKG --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing
  echo "Done"
}

map_to_data(){
  DATA_DIR="/data"
  for SRC_PATH in "$@"
  do
    # SRC_PATH should be absolute or this will exit
    if [ "$(echo $SRC_PATH | cut -c1)" != "/" ]
    then
      exit 1
    fi
    rm -rf ${ROOTFS_PATH}${SRC_PATH}
    echo "Running 'mkdir -p ${DATAFS_PATH}${SRC_PATH}'"
    mkdir -p ${DATAFS_PATH}${SRC_PATH}
    ln -fs ${DATA_DIR}${SRC_PATH} ${ROOTFS_PATH}${SRC_PATH} && echo "Created symlink from ${DATA_DIR}${SRC_PATH} to ${ROOTFS_PATH}${SRC_PATH}"
  done
}
  

bind_mount(){
  for path in "$@"
  do
    SRC=$path
    if [ "$(echo $SRC | cut -c1)" != "/" ]
    then
      exit 1
    fi
    FULL_SRC=${ROOTFS_PATH}${path}
    DST=/data${path}
    FULL_DST=${DATAFS_PATH}${path}
    echo "Creating bind mount for $path..."
    if [ -z $path ] || [ ! -d $FULL_SRC ]
    then
      echo "SRC=$SRC, FULL_SRC=$FULL_SRC"
      echo "ls -l $FULL_SRC:"
      ls -l $FULL_SRC
      echo "ERROR: bind_mount missing SRC (destination is created on /data)"
      exit 1
    fi
    echo "Copying contents from $FULL_SRC to $FULL_DST..."
    mkdir -p $(dirname $FULL_DST)
    echo "ls -l FULL_SRC -> $FULL_SRC"
    ls -l $FULL_SRC
    echo "cp -a $FULL_SRC $FULL_DST"
    cp -a $FULL_SRC $FULL_DST
    echo "ls -l FULL_DST -> $FULL_DST"
    ls -l $FULL_DST
    echo "Done"

    echo "Creating bind mount: $DST will be mounted at $SRC"
    echo "$DST   $SRC    none    defaults,bind       0 0" >> ${ROOTFS_PATH}/etc/fstab
    done
}

flannel_workaround(){
  if [ -f /usr/libexec/flannel-arm64 ] && [ -z /usr/libexec/flannel ]
  then
    echo "'/usr/libexec/flannel' was not found"
    echo "Found '/usr/libexec/flannel-arm64'. Creating symlink to '/usr/libexec/flannel'..."
    ln -sf /usr/libexec/flannel-arm64 /usr/libexec/flannel
  fi
}

k8s_main(){
  # curl and bash are for use with longhorn, if not using longhorn they can be removed
  install_pkg k3s nfs-utils openssh-client-common open-iscsi multipath-tools rpcbind curl bash
  flannel_workaround
  install ${INPUT_PATH}/update_os_ab_flash.sh ${ROOTFS_PATH}/sbin/update-rootfs
  # /etc/rancher is only created on first startup, so must be manually created
  mkdir -p ${ROOTFS_PATH}/etc/rancher ${ROOTFS_PATH}/run/k3s
  # chroot_exec rc-update add cgroups default
  chroot_exec rc-update add rpcbind default
  bind_mount /var/lib /var/log /etc/rancher /etc/iscsi /run/k3s
  install -D ${INPUT_PATH}/bind_mount.sh ${ROOTFS_PATH}/sbin/bindmounts
  sed -i 's;# make sure /data is mounted;/sbin/bindmounts;g' ${ROOTFS_PATH}/etc/init.d/data_prepare
}

# For use when setting up jump box
jump_main(){
  install_pkg nfs-utils openssh-client-common vim git tmux fish openssh-client cfdisk openssh-keygen rsync py3-pip docker curl
  install_pkg_from_testing kubectl
  chroot_exec adduser -h /data/home/ryan -s /usr/bin/fish -H ryan
  chroot_exec addgroup ryan wheel
  chroot_exec addgroup ryan docker
  chroot_exec rc-update add docker default
  install ${INPUT_PATH}/update_os_ab_flash.sh ${ROOTFS_PATH}/sbin/update-rootfs
  bind_mount /var/lib /var/log /etc/docker
  install -D ${INPUT_PATH}/bind_mount.sh ${ROOTFS_PATH}/sbin/bindmounts
  sed -i 's;# make sure /data is mounted;/sbin/bindmounts;g' ${ROOTFS_PATH}/etc/init.d/data_prepare
 }

if [ ! -z $ROOTFS_PATH ] && [ ! -z $DATAFS_PATH ]
then
  # jump_main
  k8s_main
else
    echo "ROOTFS_PATH and DATAFS_PATH are not set - this is not meant to be run outside image buliding"
    exit 1
fi
