#!/bin/sh
NODE=$1

if [[ -z $NODE ]]
then
  echo "Error: missing node name"
  exit 1
fi

ssh-keygen -R ${NODE}
ssh-keygen -R ${NODE}.faircloth.ca
ssh-copy-id -i ~/.ssh/id_ecdsa.pub root@${NODE}
