# Raspberry Pi Kubernetes Cluster
__This project is based on [raspi-alpine](https://github.com/raspi-alpine/builder)__

## Multi-arch
If you want to build the image on architecture different then the pi's (e.g. build the image on an x86 system and have the images run on arm/ aarch64) just run:
```
docker run --privileged --rm multiarch/qemu-user-static --persistent yes
```
> this is already installed if using docker desktop

## Which pi?

While you can try using at least a raspberry pi 3B+, a raspberry pi 4 is definitely recommended for all worker nodes. The control node should be fine being raspberry pi 3, but it will be slow.

In the future S3 backup of the state file will be added here, but for now, remember that with k3s there is no etcd. The state of the kubernetes cluster is stored in a sqlite file.

## `image_builder`
The `image_builder` directory contains all relevant files to build raspberry pi alpine images. Specifically, the `build_image.sh` script will build the image and write it to the sd card.
**Please remember to check the device of the sdcard (`sudo fdisk -l`), don't just copy `/dev/sdc` from the examples**
Usage:
> Build the image and write to sd card (at /dev/sdc)
```shell
./build_image.sh all /dev/sdc
```

> Just build the image
```shell
./build_image.sh build
```

> Just write the image to the sdcard
```shell
./build_image write /dev/sdc
```

# Ansible
The `ansible` directory contains the relevant files for pushing the initial k3s configuration as well as some initial housekeeping, e.g. setting the hostname, setting up any ssh keys. Ansible make it easy to template out configurations as well as provides ansible vault for encrypting any secrets, like the k3s agent token. Keep in mind that packages cannot be installed using ansible without first remounting the root volume with read/write permissions, (or setting up a bind mount to directory on a writable drive).

Make sure to add your own hosts to the `inventory.yaml` file, where you can set some host specific options, like taints, labels, etc. Check the existing one for examples.

## Provisioning a new host
Assuming you've built the image and written it to the SD card (`./build_image.sh build`, then `./build_iamge.sh write /dev/sdc` or just `./build_image.sh all /dev/sdc`), you'll then need to have ansible setup the host with:
```shell
ansible-playbook --ask-vault-pass provision.yaml
```
Once ansible finishes the hosts should start up k3s.

## Upgrading an existing host
Once an SD card has the proper partition structure (two read-only filesystems, with a writable data partition), the SD cards can be updated without removing them from the raspberry pi node (pretty neat, eh?)

Just make sure to update your existing image (`./build_iamge.sh build`), then run ansible with:
```shell
ansible-playbook upgrade_image.yaml
```
> you can optionally limit the host to upgrade with `-l host` like this:
```shell
ansible-playbook -l host.domain.com upgrade_image.yaml
```

# Kubernetes

