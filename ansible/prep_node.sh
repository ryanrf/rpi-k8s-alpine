#!/bin/sh
NODE=$1
SSH_KEY=$(cat ~/.ssh/id_ecdsa.pub)
if [[ -z $NODE ]]
then
  echo "Error: missing node name"
  exit 1
fi

ssh-keygen -R ${NODE}
ssh-keygen -R ${NODE}.faircloth.ca
ssh root@${NODE} "mkdir -p ~/.ssh && echo $SSH_KEY > ~/.ssh/authorized_keys && chmod 0600 ~/.ssh/authorized_keys"
