#!/bin/sh

CONTROL=rpi31.faircloth.ca

get_kubeconfig(){
  KUBE_DIR=~/.kube
  KUBE_PATH=${KUBE_DIR}/config
  CLUSTER_NAME=k3s

  mkdir -p $KUBE_DIR
  scp $CONTROL:/etc/rancher/k3s/k3s.yaml $KUBE_PATH
  echo "Grabbed kubeconfig from $CONTROL"
  sed -i "s/127.0.0.1/$CONTROL/g" $KUBE_PATH
  #sed -i "s/^\( *\)name: default/\1name: $CLUSTER_NAME/g" $KUBE_PATH
  #sed -i "s/cluster: default/name: $CLUSTER_NAME/g" $KUBE_PATH
  #sed -i "s/current-context: default/current-context: $CLUSTER_NAME/g" $KUBE_PATH
  echo "updated cluster name to $CLUSTER_NAME"
}

get_kubectl(){
  if [ ! -x /usr/local/bin/kubectl ]
  then
    echo "kubectl not found. Downloading it..."
    sudo curl -sL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl && sudo chmod 755 /usr/local/bin/kubectl
    echo "Done"
  else
    echo "kubectl found"
  fi
}

get_kubectl
get_kubeconfig
