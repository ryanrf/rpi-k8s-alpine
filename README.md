# Raspberry Pi Kubernetes Cluster
This repo contains all that is needed to set up and maintain a raspberry pi kubernetes cluster.
> Note: If you want to build the image on architecture different then the pi's (e.g. build the image on an x86 system and have the images run on arm/ aarch64) please see [here](https://github.com/raspi-alpine/builder) for a docker command to run that will prep your system

While you can try using at least a raspberry pi 3B+, a raspberry pi 4 is definitely recommended for all worker nodes. The control node should be fine being raspberry pi 3, but it will be slow.

In the future S3 backup of the state file will be added here, but for now, remember that with k3s there is no etcd. The state of the kubernetes cluster is stored in a sqlite file.

## `image_builder`
The `image_builder` directory contains all relevant files to build raspberry pi alpine images. Specifically, the `build_image.sh` script will build the image and write it to the sd card.
**Please remember to check the device of the sdcard (`sudo fdisk -l`), don't just copy `/dev/sdc` from the examples**
Usage:
> Build the image and write to sd card (at /dev/sdc)
```bash
./build_image.sh all /dev/sdc
```

> Just build the image
```bash
./build_image.sh build
```

> Just write the image to the sdcard
```bash
./build_image write /dev/sdc
```

# Ansible
The `ansible` directory contains the relevant files for pushing the initial k3s configuration as well as some initial housekeeping, e.g. setting the hostname, setting up any ssh keys. Ansible make it easy to template out configurations as well as provides ansible vault for encrypting any secrets, like the k3s agent token. Keep in mind that packages cannot be installed using ansible without first remounting the root volume with read/write permissions, (or setting up a bind mount to directory on a writable drive).

Make sure to add your own hosts to the `inventory.yaml` file, where you can set some host specific options, like taints, labels, etc. Check the existing one for examples.

For provisioning:
```bash
ansible-playbook --ask-vault-pass provision.yaml
```

# Kubernetes

